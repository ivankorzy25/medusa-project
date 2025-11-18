import { notFound } from "next/navigation"
import { Metadata } from "next"
import { ProductGallery, ProductInfo, ProductTabs } from "@/components/products"
import { ImageCarousel } from "@/components/products/ImageCarousel"
import { ProductInfoTabs } from "@/components/products/ProductInfoTabs"
import { ProductAdvantages } from "@/components/products/ProductAdvantages"
import { ProductOptionals } from "@/components/products/ProductOptionals"
import { PriceSummary } from "@/components/products/PriceSummary"
import { PriceDisplay } from "@/components/products/PriceDisplay"
import { ScrollHijackingContainer } from "@/components/products/ScrollHijackingContainer"
import { getProductByHandle as fetchProductByHandle, getVariantPrice } from "@/lib/medusa-client"

// Fetch product from Medusa API
async function getProductByHandle(handle: string) {
  const product = await fetchProductByHandle(handle)

  if (!product) {
    return null
  }

  // Get the first variant (most products have one main variant)
  const mainVariant = product.variants?.[0]
  if (!mainVariant) {
    return null
  }

  // Get prices from variant
  const prices = await getVariantPrice(mainVariant)

  // Enrich all variants with price data
  const enrichedVariants = await Promise.all(
    (product.variants || []).map(async (variant: any) => {
      const variantPrice = await getVariantPrice(variant)
      return {
        id: variant.id,
        title: variant.title || product.title,
        sku: variant.sku || "",
        price: variantPrice,
        metadata: variant.metadata || {},
        weight: variant.weight,
        length: variant.length,
        width: variant.width,
        height: variant.height,
      }
    })
  )

  // Transform Medusa product to component-friendly format
  return {
    id: product.id,
    title: product.title || "",
    handle: product.handle || "",
    sku: mainVariant.sku || "",
    description: product.description || "",
    priceWithoutTax: prices.priceWithoutTax,
    priceWithTax: prices.priceWithTax,
    currency: prices.currency,
    // Campos nativos de Medusa (peso y dimensiones)
    weight: product.weight,
    length: product.length,
    width: product.width,
    height: product.height,
    origin_country: product.origin_country,
    // Pass metadata directly without remapping - the field names in the database are correct
    metadata: product.metadata || {},
    images: (product.images || []).map((img: any, index: number) => ({
      id: img.id || String(index),
      url: img.url || "",
      alt: img.metadata?.alt || `${product.title} - Imagen ${index + 1}`,
    })),
    variants: enrichedVariants,
  }
}

async function getProductDocuments(metadata: any) {
  // Retorna documentos desde metadata del producto
  // Si metadata.documentos existe, lo usa; si no, retorna array vacío

  if (!metadata || !metadata.documentos || !Array.isArray(metadata.documentos)) {
    return []
  }

  return metadata.documentos
}

export async function generateMetadata({
  params,
}: {
  params: Promise<{ handle: string }>
}): Promise<Metadata> {
  const { handle } = await params
  const product = await getProductByHandle(handle)

  if (!product) {
    return {
      title: "Producto no encontrado",
    }
  }

  return {
    title: `${product.title} | Generadores.ar`,
    description: product.description,
    openGraph: {
      title: product.title,
      description: product.description,
      images: product.images.map((img: any) => img.url),
      type: "website",
    },
  }
}

export default async function ProductPage({
  params,
}: {
  params: Promise<{ handle: string }>
}) {
  const { handle } = await params
  const product = await getProductByHandle(handle)

  if (!product) {
    notFound()
  }

  const documents = await getProductDocuments(product.metadata)

  return (
    <div className="min-h-screen bg-[#EDEDED]">
      {/* Breadcrumbs */}
      <div className="bg-white border-b border-gray-200">
        <div className="max-w-[1200px] mx-auto px-4 py-3">
          <nav className="flex items-center gap-2 text-sm text-gray-600">
            <a href="/" className="hover:text-blue-600 hover:underline">
              Inicio
            </a>
            <span className="text-gray-400">›</span>
            <a href="/productos" className="hover:text-blue-600 hover:underline">
              Productos
            </a>
            <span className="text-gray-400">›</span>
            <span className="text-gray-700 truncate">
              {product.title}
            </span>
          </nav>
        </div>
      </div>

      {/* Product Content */}
      <div className="max-w-[1200px] mx-auto px-5 py-5">
        <div className="bg-white rounded-lg p-5 mb-5">
          <ScrollHijackingContainer
            imageContent={
              <ImageCarousel
                images={product.images.map((img: any) => ({
                  id: img.id,
                  url: img.url,
                  rank: 0
                }))}
                title={product.title}
              />
            }
            centerContent={
              <div className="space-y-4">
                {/* Badges estilo MercadoLibre - Dinámicos */}
                {(product.metadata.es_mas_vendido || (product.metadata.descuento_porcentaje > 0) || (product.metadata.estado_producto === 'Nuevo' && (product.metadata.total_ventas === 0 || !product.metadata.total_ventas))) && (
                  <div className="flex flex-wrap gap-2 items-center mb-2">
                    {/* Badge RECIÉN LLEGADO - para productos nuevos sin ventas */}
                    {product.metadata.estado_producto === 'Nuevo' && (!product.metadata.total_ventas || product.metadata.total_ventas === 0) && !product.metadata.es_mas_vendido && (
                      <span className="text-[12px] font-semibold px-2 py-1 rounded" style={{
                        color: 'rgb(255, 255, 255)',
                        backgroundColor: '#10B981',
                        fontFamily: '"Proxima Nova", -apple-system, Roboto, Arial, sans-serif',
                        fontWeight: 600
                      }}>
                        RECIÉN LLEGADO
                      </span>
                    )}
                    {/* Badge MÁS VENDIDO - solo si tiene flag en metadata */}
                    {product.metadata.es_mas_vendido && (
                      <span className="text-[12px] font-semibold px-2 py-1 rounded" style={{
                        color: 'rgb(255, 255, 255)',
                        backgroundColor: '#FF6633',
                        fontFamily: '"Proxima Nova", -apple-system, Roboto, Arial, sans-serif',
                        fontWeight: 600
                      }}>
                        MÁS VENDIDO
                      </span>
                    )}
                    {/* Badge OFERTA - solo si hay descuento */}
                    {product.metadata.descuento_porcentaje > 0 && (
                      <span className="text-[12px] font-semibold px-2 py-1 rounded" style={{
                        color: 'rgb(255, 255, 255)',
                        backgroundColor: '#3483FA',
                        fontFamily: '"Proxima Nova", -apple-system, Roboto, Arial, sans-serif',
                        fontWeight: 600
                      }}>
                        OFERTA DEL DÍA
                      </span>
                    )}
                  </div>
                )}

                <div>
                  {/* Subtítulo dinámico (Estado | +X vendidos) - Leer de metadata */}
                  <p className="text-[14px] font-normal mb-2" style={{
                    color: 'rgba(0, 0, 0, 0.55)',
                    fontFamily: '"Proxima Nova", -apple-system, Roboto, Arial, sans-serif'
                  }}>
                    {product.metadata.estado_producto || 'Nuevo'}
                    {product.metadata.total_ventas > 0 && (
                      <> | +{product.metadata.total_ventas} vendidos</>
                    )}
                  </p>

                  {/* Título H1 */}
                  <h1 className="text-[22px] font-semibold mb-2" style={{
                    color: 'rgba(0, 0, 0, 0.9)',
                    fontFamily: '"Proxima Nova", -apple-system, Roboto, Arial, sans-serif',
                    fontWeight: 600,
                    lineHeight: '1.25'
                  }}>
                    {product.title}
                  </h1>

                  {/* Rating estilo MercadoLibre - Leer de metadata */}
                  {product.metadata.rating_promedio > 0 && product.metadata.total_reviews > 0 && (
                    <div className="flex items-center gap-2" style={{ marginBottom: '16px' }}>
                      <div className="flex items-center gap-1">
                        <span className="text-[14px] font-semibold" style={{ color: 'rgba(0, 0, 0, 0.9)' }}>
                          {product.metadata.rating_promedio.toFixed(1)}
                        </span>
                        <div className="flex text-yellow-400 text-sm">
                          {[...Array(Math.floor(product.metadata.rating_promedio))].map((_, i) => (
                            <span key={i}>★</span>
                          ))}
                          {(product.metadata.rating_promedio % 1 >= 0.5) && <span>☆</span>}
                        </div>
                      </div>
                      <span className="text-[14px] font-normal" style={{
                        color: 'rgba(0, 0, 0, 0.55)',
                        fontFamily: '"Proxima Nova", -apple-system, Roboto, Arial, sans-serif'
                      }}>
                        ({product.metadata.total_reviews})
                      </span>
                    </div>
                  )}
                </div>

                {/* Atributos Principales - Badges estilo MercadoLibre con colores icónicos */}
                <div className="space-y-3 py-4 border-t border-gray-200">
                  <div className="flex flex-wrap gap-2">
                    {/* Tipo de Combustible - Colores representativos del combustible real */}
                    {product.metadata.combustible_tipo && (
                      <div className="px-3 py-1.5 rounded-md text-xs font-medium border" style={{
                        borderColor: product.metadata.combustible_tipo.toLowerCase().includes('diesel')
                          ? '#F59E0B'  // Naranja/dorado como el diesel real
                          : product.metadata.combustible_tipo.toLowerCase().includes('nafta')
                          ? '#EF4444'  // Rojo como la nafta/gasolina
                          : '#10B981', // Verde para gas natural
                        backgroundColor: product.metadata.combustible_tipo.toLowerCase().includes('diesel')
                          ? '#FEF3C7'
                          : product.metadata.combustible_tipo.toLowerCase().includes('nafta')
                          ? '#FEE2E2'
                          : '#D1FAE5',
                        color: product.metadata.combustible_tipo.toLowerCase().includes('diesel')
                          ? '#92400E'
                          : product.metadata.combustible_tipo.toLowerCase().includes('nafta')
                          ? '#991B1B'
                          : '#065F46',
                        fontFamily: '"Proxima Nova", -apple-system, Roboto, Arial, sans-serif'
                      }}>
                        Combustible: {product.metadata.combustible_tipo}
                      </div>
                    )}

                    {/* TTA Incluido - Amarillo eléctrico */}
                    {product.metadata.tiene_tta === 'incluido' && (
                      <div className="px-3 py-1.5 rounded-md text-xs font-medium border" style={{
                        borderColor: '#FBBF24',
                        backgroundColor: '#FEF3C7',
                        color: '#92400E',
                        fontFamily: '"Proxima Nova", -apple-system, Roboto, Arial, sans-serif'
                      }}>
                        TTA Incluido
                      </div>
                    )}
                    {/* TTA Opcional - Amarillo más suave */}
                    {product.metadata.tiene_tta === 'opcional' && (
                      <div className="px-3 py-1.5 rounded-md text-xs font-medium border" style={{
                        borderColor: '#FCD34D',
                        backgroundColor: '#FEFCE8',
                        color: '#92400E',
                        fontFamily: '"Proxima Nova", -apple-system, Roboto, Arial, sans-serif'
                      }}>
                        TTA Opcional
                      </div>
                    )}

                    {/* Cabina - Azul arquitectura/construcción */}
                    {product.metadata.tiene_cabina === true && (
                      <div className="px-3 py-1.5 rounded-md text-xs font-medium border" style={{
                        borderColor: '#60A5FA',
                        backgroundColor: '#DBEAFE',
                        color: '#1E40AF',
                        fontFamily: '"Proxima Nova", -apple-system, Roboto, Arial, sans-serif'
                      }}>
                        Con Cabina
                      </div>
                    )}

                    {/* Nivel de Ruido - Estilo gris igual que peso y dimensiones */}
                    {product.metadata.nivel_ruido_db && (
                      <div className="px-3 py-1.5 rounded-md text-xs font-medium border flex items-center gap-2" style={{
                        borderColor: '#9CA3AF',
                        backgroundColor: '#F3F4F6',
                        color: '#374151',
                        fontFamily: '"Proxima Nova", -apple-system, Roboto, Arial, sans-serif'
                      }}>
                        {product.metadata.nivel_ruido_db} dB
                        <div className="flex gap-0.5">
                          {[...Array(5)].map((_, i) => (
                            <div key={i} className="w-1 h-3 rounded-sm" style={{
                              backgroundColor: i < (5 - Math.floor(Number(product.metadata.nivel_ruido_db) / 20))
                                ? '#10B981'
                                : i < 3
                                ? '#F59E0B'
                                : '#EF4444',
                              opacity: i < Math.ceil(Number(product.metadata.nivel_ruido_db) / 20) ? 1 : 0.2
                            }}></div>
                          ))}
                        </div>
                      </div>
                    )}

                    {/* Peso - Gris con borde más fuerte */}
                    {product.weight && (
                      <div className="px-3 py-1.5 rounded-md text-xs font-medium border" style={{
                        borderColor: '#9CA3AF',
                        backgroundColor: '#F3F4F6',
                        color: '#374151',
                        fontFamily: '"Proxima Nova", -apple-system, Roboto, Arial, sans-serif'
                      }}>
                        {product.weight} kg
                      </div>
                    )}

                    {/* Dimensiones - Gris con borde más fuerte */}
                    {(product.length && product.width && product.height) && (
                      <div className="px-3 py-1.5 rounded-md text-xs font-medium border" style={{
                        borderColor: '#9CA3AF',
                        backgroundColor: '#F3F4F6',
                        color: '#374151',
                        fontFamily: '"Proxima Nova", -apple-system, Roboto, Arial, sans-serif'
                      }}>
                        {Math.round(Number(product.length)/10)}×{Math.round(Number(product.width)/10)}×{Math.round(Number(product.height)/10)} cm
                      </div>
                    )}
                  </div>
                </div>

                {/* Botón de Ficha Técnica PDF */}
                {product.metadata.documentos && Array.isArray(product.metadata.documentos) && product.metadata.documentos.length > 0 && (
                  <div className="mt-3">
                    {product.metadata.documentos.map((doc: any, index: number) => (
                      <a
                        key={index}
                        href={doc.url}
                        target="_blank"
                        rel="noopener noreferrer"
                        className="inline-flex items-center gap-2 px-4 py-2 rounded-md text-sm font-medium border transition-colors hover:bg-gray-50"
                        style={{
                          borderColor: '#D1D5DB',
                          backgroundColor: '#FFFFFF',
                          color: '#374151',
                          fontFamily: '"Proxima Nova", -apple-system, Roboto, Arial, sans-serif'
                        }}
                      >
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                          <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                          <polyline points="14 2 14 8 20 8"></polyline>
                          <line x1="16" y1="13" x2="8" y2="13"></line>
                          <line x1="16" y1="17" x2="8" y2="17"></line>
                          <polyline points="10 9 9 9 8 9"></polyline>
                        </svg>
                        Ver ficha técnica (PDF)
                      </a>
                    ))}
                  </div>
                )}

{/* Características destacadas - Estilo MercadoLibre */}
                <div className="space-y-1">
                  <h2 className="text-[16px] font-semibold mb-2" style={{
                    color: 'rgba(0, 0, 0, 0.9)',
                    fontFamily: '"Proxima Nova", -apple-system, Roboto, Arial, sans-serif'
                  }}>
                    Lo que tenés que saber de este producto
                  </h2>
                  <ul className="space-y-1" style={{
                    fontSize: '14px',
                    lineHeight: '1.25',
                    color: 'rgba(0, 0, 0, 0.8)',
                    fontFamily: '"Proxima Nova", -apple-system, Roboto, Arial, sans-serif'
                  }}>
                    {/* Motor - desde nueva estructura */}
                    {product.metadata?.motor?.motor_marca?.valor && product.metadata?.motor?.motor_modelo?.valor && (
                      <li>• Motor {product.metadata.motor.motor_marca.valor} {product.metadata.motor.motor_modelo.valor}</li>
                    )}

                    {/* Potencias - desde nueva estructura */}
                    {product.metadata?.potencia?.potencia_standby_kva?.valor && (
                      <li>• Potencia Stand-By: {product.metadata.potencia.potencia_standby_kva.valor} kVA {product.metadata?.potencia?.potencia_standby_kw?.valor && `(${product.metadata.potencia.potencia_standby_kw.valor} kW)`}</li>
                    )}
                    {product.metadata?.potencia?.potencia_prime_kva?.valor && (
                      <li>• Potencia Prime: {product.metadata.potencia.potencia_prime_kva.valor} kVA {product.metadata?.potencia?.potencia_prime_kw?.valor && `(${product.metadata.potencia.potencia_prime_kw.valor} kW)`}</li>
                    )}

                    {/* Alternador - desde nueva estructura */}
                    {product.metadata?.alternador?.alternador_marca?.valor && (
                      <li>• Alternador {product.metadata.alternador.alternador_marca.valor} {product.metadata?.alternador?.alternador_modelo?.valor || ''}</li>
                    )}

                    {/* Voltaje y Fases - desde nueva estructura */}
                    {product.metadata?.alternador?.alternador_voltaje?.valor && (
                      <li>• Voltaje: {product.metadata.alternador.alternador_voltaje.valor}V - {product.metadata?.alternador?.alternador_fases?.valor || 'Trifásico'}</li>
                    )}

                    {/* Frecuencia */}
                    {product.metadata?.alternador?.alternador_frecuencia?.valor && (
                      <li>• Frecuencia: {product.metadata.alternador.alternador_frecuencia.valor} Hz</li>
                    )}

                    {/* Combustible - desde nueva estructura */}
                    {product.metadata?.combustible?.combustible_tipo?.valor && (
                      <li>• Tipo de alimentación: {product.metadata.combustible.combustible_tipo.valor}</li>
                    )}
                    {product.metadata?.combustible?.combustible_tanque_capacidad?.valor && (
                      <li>• Capacidad de tanque: {product.metadata.combustible.combustible_tanque_capacidad.valor} litros</li>
                    )}
                    {product.metadata?.combustible?.combustible_autonomia_75?.valor && (
                      <li>• Autonomía al 75%: {product.metadata.combustible.combustible_autonomia_75.valor} horas</li>
                    )}

                    {/* Ruido - desde nueva estructura */}
                    {product.metadata?.ruido_cabina?.ruido_nivel_db?.valor && (
                      <li>• Nivel de ruido: {product.metadata.ruido_cabina.ruido_nivel_db.valor} dB a 7m</li>
                    )}
                    {product.metadata?.ruido_cabina?.cabina_tipo?.valor && (
                      <li>• Cabina: {product.metadata.ruido_cabina.cabina_tipo.valor}</li>
                    )}

                    {/* Panel de control - desde nueva estructura */}
                    {product.metadata?.panel_control?.panel_marca?.valor && (
                      <li>• Panel de control {product.metadata.panel_control.panel_marca.valor} {product.metadata?.panel_control?.panel_modelo?.valor || ''}</li>
                    )}
                    {product.metadata?.panel_control?.panel_arranque_automatico?.valor && (
                      <li>• Arranque automático en {product.metadata?.panel_control?.panel_tiempo_arranque?.valor || '10'} segundos</li>
                    )}

                    {/* Motor técnico */}
                    {product.metadata?.motor?.motor_cilindros?.valor && (
                      <li>• Motor de {product.metadata.motor.motor_cilindros.valor} cilindros {product.metadata?.motor?.motor_disposicion?.valor || ''}</li>
                    )}
                    {product.metadata?.motor?.motor_aspiracion?.valor && (
                      <li>• {product.metadata.motor.motor_aspiracion.valor}</li>
                    )}

                    {/* Fallback para metadata antigua */}
                    {!product.metadata?.motor && product.metadata?.motor_marca && (
                      <li>• Motor {product.metadata.motor_marca} {product.metadata.motor_modelo || ''}</li>
                    )}
                    {!product.metadata?.potencia && product.metadata?.potencia_standby_kva && (
                      <li>• Potencia Stand-By: {product.metadata.potencia_standby_kva} kVA</li>
                    )}
                  </ul>
                </div>
                <div className="pt-4 border-t border-gray-200">
                  <p className="text-xs" style={{
                    color: 'rgba(0, 0, 0, 0.45)',
                    fontFamily: '"Proxima Nova", -apple-system, Roboto, Arial, sans-serif'
                  }}>
                    SKU: {product.sku}
                  </p>
                </div>
              </div>
            }
            rightContent={
              <PriceDisplay
                productId={product.id}
                priceUSD={product.priceWithoutTax}
                pricingConfig={{
                  precio_lista_usd: product.metadata?.precios?.precio_sin_iva?.valor || product.priceWithoutTax,
                  iva_percentage: product.metadata?.precios?.precio_iva_porcentaje?.valor || 10.5,
                  currency_type: "usd_oficial",
                  bonificacion_percentage: 0,
                  contado_descuento_percentage: 0,
                  familia: product.metadata?.condiciones_comerciales?.categoria_comercial || "Generadores"
                }}
                descuentoPorcentaje={product.metadata.descuento_porcentaje}
                precioAnterior={product.metadata.precio_anterior}
                financiacionDisponible={!!product.metadata?.precios?.financiacion?.valor}
                planesFinanciacion={product.metadata?.precios?.financiacion?.valor ? [{
                  cuotas: 4,
                  interes: 0,
                  costoPorCuota: Math.round((product.metadata?.precios?.precio_con_iva?.valor || 0) / 4)
                }] : undefined}
                stockCantidad={product.metadata.stock_cantidad}
                stockDisponible={product.metadata.stock_disponible}
                ubicacionEnvio={product.metadata.ubicacion_envio}
                vendorData={{
                  nombre: product.metadata.vendor_nombre,
                  nombre_completo: product.metadata.vendor_nombre_completo,
                  rating: product.metadata.vendor_rating,
                  anos_experiencia: product.metadata.vendor_anos_experiencia,
                  tiempo_respuesta: product.metadata.vendor_tiempo_respuesta,
                  descripcion: product.metadata.vendor_descripcion
                }}
                trustSignals={{
                  garantia_incluida: product.metadata.trust_garantia_incluida,
                  garantia_texto: product.metadata.trust_garantia_texto,
                  garantia_descripcion: product.metadata.trust_garantia_descripcion,
                  envio_gratis: product.metadata.trust_envio_gratis,
                  envio_texto: product.metadata.trust_envio_texto,
                  envio_descripcion: product.metadata.trust_envio_descripcion
                }}
              />
            }
          />
        </div>

        {/* Product Information Tabs */}
        <div className="bg-white rounded p-6 mb-6">
          <ProductInfoTabs
            description={product.description}
            metadata={product.metadata}
            variants={product.variants}
            productHandle={product.handle}
            weight={product.weight}
            length={product.length}
            width={product.width}
            height={product.height}
          />
        </div>

        {/* Ventajas Competitivas */}
        {product.metadata.ventajas_competitivas && product.metadata.ventajas_competitivas.length > 0 && (
          <div className="bg-white rounded p-6 mb-6">
            <ProductAdvantages advantages={product.metadata.ventajas_competitivas} />
          </div>
        )}

        {/* Opcionales */}
        {product.metadata.opcionales && product.metadata.opcionales.length > 0 && (
          <div className="bg-white rounded p-6 mb-6">
            <ProductOptionals optionals={product.metadata.opcionales} />
          </div>
        )}

        {/* Document Tabs Section - Only show if documents exist and match expected format */}
        {documents && documents.length > 0 && documents[0]?.document_type && (
          <div className="bg-white rounded p-6">
            <ProductTabs documents={documents} />
          </div>
        )}
      </div>
    </div>
  )
}
