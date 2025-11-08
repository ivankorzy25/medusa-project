"use client";

import React, { useState, useEffect } from "react";
import { ChevronDown, RefreshCw, AlertCircle, Info } from "lucide-react";

interface PricingConfig {
  precio_lista_usd: number;
  currency_type: string;
  iva_percentage: number;
  bonificacion_percentage: number;
  contado_descuento_percentage: number;
  familia: string;
  precios_calculados?: {
    mercadolibre_usd: number;
    publico_usd: number;
    mayorista_contado_usd: number;
    mayorista_financiado_usd: number;
  };
}

interface PriceDisplayProps {
  productId: string;
  priceUSD?: number;
  pricingConfig?: PricingConfig;
  descuentoPorcentaje?: number;
  precioAnterior?: number;
  financiacionDisponible?: boolean;
  planesFinanciacion?: Array<{
    cuotas: number;
    interes: number;
    costoPorCuota: number;
  }>;
  stockCantidad?: number;
  stockDisponible?: boolean;
  ubicacionEnvio?: {
    ciudad?: string;
    provincia?: string;
    texto_completo?: string;
  };
  vendorData?: {
    nombre?: string;
    nombre_completo?: string;
    rating?: string;
    anos_experiencia?: string;
    tiempo_respuesta?: string;
    descripcion?: string;
  };
  trustSignals?: {
    garantia_incluida?: boolean;
    garantia_texto?: string;
    garantia_descripcion?: string;
    envio_gratis?: boolean;
    envio_texto?: string;
    envio_descripcion?: string;
  };
}

type ExchangeRateType = "oficial" | "blue" | "mep" | "ccl" | "mayorista" | "cripto" | "tarjeta";

const EXCHANGE_RATE_LABELS: Record<ExchangeRateType, { label: string; shortLabel: string }> = {
  oficial: { label: "Dólar BNA (Oficial)", shortLabel: "BNA Oficial" },
  blue: { label: "Dólar Blue (Billete)", shortLabel: "Blue" },
  mep: { label: "Dólar MEP (Bolsa)", shortLabel: "MEP" },
  ccl: { label: "Dólar CCL (Cable)", shortLabel: "CCL" },
  mayorista: { label: "Dólar Mayorista", shortLabel: "Mayorista" },
  cripto: { label: "Dólar Cripto", shortLabel: "Cripto" },
  tarjeta: { label: "Dólar Tarjeta", shortLabel: "Tarjeta" },
};

export function PriceDisplay({ productId, priceUSD, pricingConfig, descuentoPorcentaje, precioAnterior, financiacionDisponible, planesFinanciacion, stockCantidad, stockDisponible, ubicacionEnvio, vendorData, trustSignals }: PriceDisplayProps) {
  // Determinar tipo de cambio según producto - leer desde metadata
  const tipoCambio: ExchangeRateType = pricingConfig?.currency_type === "usd_blue" ? "blue" : "oficial";

  const [data, setData] = useState<any>(null);
  const [exchangeRates, setExchangeRates] = useState<any[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [showDetails, setShowDetails] = useState(false);
  const [userLocation, setUserLocation] = useState<string | null>(null);
  const [locationLoading, setLocationLoading] = useState(true);

  // Siempre incluir IVA
  const incluirIva = true;

  // Determinar precio USD base y parámetros de cálculo
  const precioListaUSD = pricingConfig?.precio_lista_usd || priceUSD || 0;
  const ivaPorcentaje = pricingConfig?.iva_percentage || 10.5;
  const bonificacion = pricingConfig?.bonificacion_percentage || 0;
  const descuentoContado = pricingConfig?.contado_descuento_percentage || 0;

  const fetchData = async () => {
    setIsLoading(true);
    setError(null);

    try {
      // Obtener tasas de cambio
      const ratesResponse = await fetch('/api/exchange-rates', {
        cache: 'no-store',
        headers: { 'Content-Type': 'application/json' }
      });

      if (!ratesResponse.ok) {
        const errorData = await ratesResponse.json().catch(() => ({}));
        throw new Error(errorData.error || `Error al obtener tasas: ${ratesResponse.status}`);
      }

      const ratesData = await ratesResponse.json();
      if (ratesData.success) {
        setExchangeRates(ratesData.data);
      }

      // Obtener precio calculado con bonificaciones y descuentos
      const priceResponse = await fetch(
        `/api/calculate-price?precio_usd=${precioListaUSD}&tipo_cambio=${tipoCambio}&incluir_iva=${incluirIva}&iva_porcentaje=${ivaPorcentaje}&bonificacion=${bonificacion}&descuento_contado=${descuentoContado}`,
        {
          cache: 'no-store',
          headers: { 'Content-Type': 'application/json' }
        }
      );

      if (!priceResponse.ok) {
        const errorData = await priceResponse.json().catch(() => ({}));
        throw new Error(errorData.error || `Error al calcular precio: ${priceResponse.status}`);
      }

      const priceData = await priceResponse.json();
      if (priceData.success) {
        setData(priceData.data);
      } else {
        throw new Error(priceData.message || "Error al calcular precio");
      }
    } catch (err: any) {
      console.error("[PriceDisplay] Error:", err);
      setError(err.message || "Error al cargar precios");
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    fetchData();
  }, [productId, precioListaUSD, bonificacion, descuentoContado]);

  // Detectar ubicación del usuario
  useEffect(() => {
    const getUserLocation = async () => {
      try {
        if ('geolocation' in navigator) {
          navigator.geolocation.getCurrentPosition(
            async (position) => {
              const { latitude, longitude } = position.coords;

              // Usar servicio de geocoding más preciso para Argentina
              try {
                const response = await fetch(
                  `https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=${latitude}&longitude=${longitude}&localityLanguage=es`
                );
                const data = await response.json();

                console.log('Geocoding response:', data); // Para debug

                // BigDataCloud devuelve locality (ciudad/localidad) de forma más precisa
                const locality = data.locality || data.city || data.principalSubdivision || '';
                const state = data.principalSubdivision || '';

                if (locality) {
                  setUserLocation(locality);
                } else if (state) {
                  setUserLocation(state);
                } else {
                  // Fallback: usar las primeras 2 partes de localityInfo
                  const parts = data.localityInfo?.administrative || [];
                  if (parts.length > 0) {
                    setUserLocation(parts[0].name);
                  }
                }
              } catch (geoError) {
                console.log('Geocoding error:', geoError);
              } finally {
                setLocationLoading(false);
              }
            },
            (error) => {
              console.log('Geolocation permission denied or error:', error);
              setLocationLoading(false);
            },
            { timeout: 5000, maximumAge: 0 } // Sin cache para obtener ubicación actualizada
          );
        } else {
          setLocationLoading(false);
        }
      } catch (err) {
        console.log('Location detection error:', err);
        setLocationLoading(false);
      }
    };

    getUserLocation();
  }, []);

  // Formato ARS: $ 42.171.104 (puntos para miles)
  const formatARS = (price: number): string => {
    return new Intl.NumberFormat("es-AR", {
      minimumFractionDigits: 0,
      maximumFractionDigits: 0,
    }).format(price);
  };

  // Formato USD: 26.411,50 (coma decimal, punto miles)
  const formatUSD = (price: number): string => {
    return new Intl.NumberFormat("es-AR", {
      minimumFractionDigits: 2,
      maximumFractionDigits: 2,
    }).format(price);
  };

  const selectedRateData = exchangeRates.find(r => r.tipo === tipoCambio);
  const selectedRateLabel = EXCHANGE_RATE_LABELS[tipoCambio];

  if (error) {
    return (
      <div className="bg-red-50 border-2 border-red-200 rounded-lg p-4">
        <div className="flex items-center gap-2 text-red-700 mb-2">
          <AlertCircle className="w-5 h-5" />
          <p className="font-semibold text-sm">Error al cargar precios</p>
        </div>
        <p className="text-red-600 text-xs mb-3">{error}</p>
        <button
          onClick={fetchData}
          className="w-full bg-red-600 hover:bg-red-700 text-white font-medium py-2 px-4 rounded text-sm flex items-center justify-center gap-2"
        >
          <RefreshCw className="w-4 h-4" />
          Reintentar
        </button>
      </div>
    );
  }

  return (
    <div className="w-full max-w-full">
      {/* Precio Final */}
      {isLoading ? (
        <div className="bg-gray-50 rounded p-6 text-center">
          <div className="inline-block h-8 w-8 animate-spin rounded-full border-3 border-solid border-blue-600 border-r-transparent mb-2"></div>
          <p className="text-gray-600 text-sm">Calculando precio...</p>
        </div>
      ) : data ? (
        <div className="space-y-0">
          {/* Precio estilo MercadoLibre */}
          <div className="pb-5">
            {/* Precio anterior tachado - solo si hay descuento */}
            {descuentoPorcentaje > 0 && (
              <div className="mb-2">
                <span className="text-[16px] font-normal" style={{
                  color: 'rgba(0, 0, 0, 0.55)',
                  textDecoration: 'line-through',
                  fontFamily: '"Proxima Nova", -apple-system, Roboto, Arial, sans-serif'
                }}>
                  $ {formatARS(precioAnterior
                    ? Math.round(precioAnterior)
                    : Math.round(data.escenarios.publico.con_iva / (1 - descuentoPorcentaje / 100))
                  )}
                </span>
              </div>
            )}

            {/* Precio principal */}
            <div className="flex items-baseline gap-2 mb-2">
              <span className="text-[36px] font-light" style={{
                color: 'rgb(0, 0, 0)',
                fontFamily: '"Proxima Nova", -apple-system, Roboto, Arial, sans-serif',
                fontWeight: 300
              }}>
                $ {formatARS(data.escenarios.publico.con_iva)}
              </span>
              {/* Descuento - solo si existe */}
              {descuentoPorcentaje > 0 && (
                <span className="text-[18px] font-normal" style={{
                  color: 'rgb(76, 175, 80)',
                  fontFamily: '"Proxima Nova", -apple-system, Roboto, Arial, sans-serif',
                  fontWeight: 400
                }}>
                  {descuentoPorcentaje}% OFF
                </span>
              )}
            </div>

            {/* Financiación - solo si está disponible */}
            {financiacionDisponible && planesFinanciacion && planesFinanciacion.length > 0 && (
              <>
                <p className="text-[14px] font-normal mb-1" style={{
                  color: 'rgba(0, 0, 0, 0.9)',
                  fontFamily: '"Proxima Nova", -apple-system, Roboto, Arial, sans-serif'
                }}>
                  {planesFinanciacion[0].interes === 0 || planesFinanciacion[0].interes <= 0.01
                    ? `Mismo precio en ${planesFinanciacion[0].cuotas} cuotas de $ ${formatARS(planesFinanciacion[0].costoPorCuota)}`
                    : `Hasta ${planesFinanciacion[0].cuotas} cuotas de $ ${formatARS(planesFinanciacion[0].costoPorCuota)}`
                  }
                </p>
                <p className="text-[11px] font-normal mb-2" style={{
                  color: 'rgba(0, 0, 0, 0.45)',
                  fontFamily: '"Proxima Nova", -apple-system, Roboto, Arial, sans-serif'
                }}>
                  * Sujeto a disponibilidad. Consultar con el vendedor.
                </p>
              </>
            )}

            <p className="text-xs" style={{ color: 'rgba(0, 0, 0, 0.55)' }}>
              USD {formatUSD(precioListaUSD)} + IVA {ivaPorcentaje}%
            </p>
          </div>

          {/* Botones estilo MercadoLibre */}
          <div className="space-y-3" style={{ marginTop: '20px' }}>
            {/* Botón Comprar ahora */}
            <button className="w-full rounded-md transition-colors" style={{
              height: '48px',
              fontSize: '16px',
              fontWeight: 600,
              backgroundColor: '#3483FA',
              color: 'white',
              fontFamily: '"Proxima Nova", -apple-system, Roboto, Arial, sans-serif',
              border: 'none',
              cursor: 'pointer'
            }}>
              Comprar ahora
            </button>

            {/* Botón Agregar al carrito */}
            <button className="w-full rounded-md transition-colors" style={{
              height: '48px',
              fontSize: '14px',
              fontWeight: 400,
              backgroundColor: 'rgba(65, 137, 230, 0.15)',
              color: '#3483FA',
              fontFamily: '"Proxima Nova", -apple-system, Roboto, Arial, sans-serif',
              border: 'none',
              cursor: 'pointer'
            }}>
              Agregar al carrito
            </button>
          </div>

          {/* Trust Signals - Beneficios de Compra - DINÁMICO desde metadata */}
          {(trustSignals?.garantia_incluida || trustSignals?.envio_gratis) && (
            <div className="py-4 border-t border-gray-200 space-y-3" style={{ marginTop: '20px' }}>
              {/* Garantía - Dinámico */}
              {trustSignals?.garantia_incluida && (
                <div className="flex items-start gap-3">
                  <span className="text-xl flex-shrink-0" style={{ color: '#10B981' }}>✓</span>
                  <div>
                    <p className="text-[13px] font-semibold" style={{
                      color: 'rgba(0, 0, 0, 0.9)',
                      fontFamily: '"Proxima Nova", -apple-system, Roboto, Arial, sans-serif'
                    }}>
                      {trustSignals.garantia_texto || 'Garantía oficial'}
                    </p>
                    {trustSignals.garantia_descripcion && (
                      <p className="text-[12px]" style={{
                        color: 'rgba(0, 0, 0, 0.55)',
                        fontFamily: '"Proxima Nova", -apple-system, Roboto, Arial, sans-serif'
                      }}>
                        {trustSignals.garantia_descripcion}
                      </p>
                    )}
                  </div>
                </div>
              )}

              {/* Envío - Dinámico */}
              {trustSignals?.envio_gratis && (
                <div className="flex items-start gap-3">
                  <span className="text-xl flex-shrink-0" style={{ color: '#10B981' }}>🚚</span>
                  <div>
                    <p className="text-[13px] font-semibold" style={{
                      color: 'rgba(0, 0, 0, 0.9)',
                      fontFamily: '"Proxima Nova", -apple-system, Roboto, Arial, sans-serif'
                    }}>
                      {trustSignals.envio_texto || 'Envío gratis'}
                    </p>
                    {trustSignals.envio_descripcion && (
                      <p className="text-[12px]" style={{
                        color: 'rgba(0, 0, 0, 0.55)',
                        fontFamily: '"Proxima Nova", -apple-system, Roboto, Arial, sans-serif'
                      }}>
                        {trustSignals.envio_descripcion}
                      </p>
                    )}
                  </div>
                </div>
              )}
            </div>
          )}

          {/* Stock - Leer de metadata */}
          <div className="py-4 border-t border-gray-200" style={{ marginTop: '0' }}>
            <p className="text-sm font-medium mb-1" style={{ color: 'rgba(0, 0, 0, 0.9)' }}>
              {stockDisponible ? 'Stock disponible' : 'Sin stock'}
            </p>
            {stockCantidad !== undefined && (
              <p className="text-sm" style={{ color: 'rgba(0, 0, 0, 0.55)' }}>
                Cantidad: {stockCantidad} {stockCantidad === 1 ? 'unidad' : 'unidades'}
              </p>
            )}
          </div>

          {/* Información adicional */}
          <div className="pt-4 border-t border-gray-200 space-y-3">
            {/* Ubicación de envío - Mostrar ubicación del usuario o fallback a ubicación del vendedor */}
            <div>
              <p className="text-[14px] font-normal mb-1" style={{
                color: 'rgba(0, 0, 0, 0.9)',
                fontFamily: '"Proxima Nova", -apple-system, Roboto, Arial, sans-serif'
              }}>
                Entrega a acordar con el vendedor
              </p>
              <p className="text-[14px] font-normal" style={{
                color: 'rgba(0, 0, 0, 0.55)',
                fontFamily: '"Proxima Nova", -apple-system, Roboto, Arial, sans-serif'
              }}>
                {locationLoading ? (
                  'Detectando tu ubicación...'
                ) : userLocation ? (
                  <>
                    Enviar a <span style={{ fontWeight: 600 }}>{userLocation}</span>
                  </>
                ) : ubicacionEnvio ? (
                  ubicacionEnvio.texto_completo || `${ubicacionEnvio.ciudad}, ${ubicacionEnvio.provincia}`
                ) : (
                  'Ubicación no disponible'
                )}
              </p>
            </div>

            <div>
              <p className="text-[14px] font-normal mb-1" style={{
                color: 'rgba(0, 0, 0, 0.9)',
                fontFamily: '"Proxima Nova", -apple-system, Roboto, Arial, sans-serif'
              }}>
                Cotización de referencia
              </p>
              <p className="text-[14px] font-normal" style={{
                color: 'rgba(0, 0, 0, 0.55)',
                fontFamily: '"Proxima Nova", -apple-system, Roboto, Arial, sans-serif'
              }}>
                {selectedRateLabel.label}: ${selectedRateData?.venta.toFixed(2)}
              </p>
            </div>

            {pricingConfig?.familia && (
              <div>
                <p className="text-[14px] font-normal mb-1" style={{
                  color: 'rgba(0, 0, 0, 0.9)',
                  fontFamily: '"Proxima Nova", -apple-system, Roboto, Arial, sans-serif'
                }}>
                  Familia de Producto
                </p>
                <p className="text-[14px] font-normal" style={{
                  color: 'rgba(0, 0, 0, 0.55)',
                  fontFamily: '"Proxima Nova", -apple-system, Roboto, Arial, sans-serif'
                }}>
                  {pricingConfig.familia}
                </p>
              </div>
            )}
          </div>

          {/* Card del Vendedor - DINÁMICO desde metadata */}
          {vendorData && (
            <div className="pt-4 border-t border-gray-200">
              <div className="bg-gray-50 rounded-lg p-4 space-y-3">
                <div className="flex items-center gap-3">
                  <div className="w-12 h-12 bg-blue-600 rounded-full flex items-center justify-center text-white font-bold text-xl">
                    {vendorData.nombre?.charAt(0) || 'V'}
                  </div>
                  <div className="flex-1">
                    <p className="text-[14px] font-semibold" style={{
                      color: 'rgba(0, 0, 0, 0.9)',
                      fontFamily: '"Proxima Nova", -apple-system, Roboto, Arial, sans-serif'
                    }}>
                      {vendorData.nombre_completo || vendorData.nombre || 'Vendedor'}
                    </p>
                    {vendorData.rating && (
                      <div className="flex items-center gap-2 mt-1">
                        <div className="flex">
                          {[1, 2, 3, 4, 5].map((star) => (
                            <span key={star} className="text-yellow-400 text-sm">★</span>
                          ))}
                        </div>
                        <span className="text-[12px]" style={{ color: 'rgba(0, 0, 0, 0.55)' }}>
                          {vendorData.rating}
                        </span>
                      </div>
                    )}
                  </div>
                </div>

                <div className="grid grid-cols-2 gap-3 text-[12px]">
                  {vendorData.anos_experiencia && (
                    <div>
                      <p style={{ color: 'rgba(0, 0, 0, 0.55)' }}>Años vendiendo</p>
                      <p className="font-semibold" style={{ color: 'rgba(0, 0, 0, 0.9)' }}>+{vendorData.anos_experiencia} años</p>
                    </div>
                  )}
                  {vendorData.tiempo_respuesta && (
                    <div>
                      <p style={{ color: 'rgba(0, 0, 0, 0.55)' }}>Respuesta</p>
                      <p className="font-semibold" style={{ color: 'rgba(0, 0, 0, 0.9)' }}>{vendorData.tiempo_respuesta}</p>
                    </div>
                  )}
                </div>

                {vendorData.descripcion && (
                  <div className="pt-2">
                    <p className="text-[11px]" style={{ color: 'rgba(0, 0, 0, 0.55)' }}>
                      {vendorData.descripcion}
                    </p>
                  </div>
                )}

                <button className="w-full rounded-md transition-colors py-2 text-[13px] font-medium" style={{
                  backgroundColor: 'white',
                  color: '#3483FA',
                  border: '1px solid #3483FA',
                  fontFamily: '"Proxima Nova", -apple-system, Roboto, Arial, sans-serif',
                  cursor: 'pointer'
                }}>
                  Ver más productos del vendedor
                </button>
              </div>
            </div>
          )}

          {/* Botón Ver Detalles */}
          <div className="pt-4 border-t border-gray-200 flex justify-center">
            <button
              onClick={() => setShowDetails(!showDetails)}
              className="text-blue-600 hover:text-blue-700 py-2 text-sm font-medium flex items-center gap-1 transition-colors"
            >
              {showDetails ? "Ver menos información del precio" : "Ver más información del precio"}
              <ChevronDown className={`w-4 h-4 transition-transform ${showDetails ? "rotate-180" : ""}`} />
            </button>
          </div>

          {/* Panel de Detalles Expandible */}
          {showDetails && (
            <div className="bg-gray-50 rounded-lg p-3 space-y-3 w-full overflow-hidden">
              <div className="space-y-2">
                <h3 className="text-sm font-bold text-gray-900">Desglose del precio (Público)</h3>

                <div className="space-y-2 bg-white rounded p-2">
                  <div className="flex justify-between text-xs gap-2">
                    <span className="text-gray-600">Precio base</span>
                    <span className="font-semibold text-gray-900 text-right">USD {formatUSD(precioListaUSD)}</span>
                  </div>

                  <div className="flex justify-between text-xs gap-2">
                    <span className="text-gray-600">Cotización ({selectedRateLabel.shortLabel})</span>
                    <span className="font-semibold text-gray-900 text-right">$ {selectedRateData?.venta.toFixed(2)}</span>
                  </div>

                  <div className="flex justify-between text-xs gap-2">
                    <span className="text-gray-600">Precio (sin IVA)</span>
                    <span className="font-semibold text-gray-900 text-right">$ {formatARS(data.escenarios.publico.sin_iva)}</span>
                  </div>

                  {data.escenarios.publico.con_iva > data.escenarios.publico.sin_iva && (
                    <div className="flex justify-between text-xs gap-2">
                      <span className="text-gray-600">IVA ({ivaPorcentaje}%)</span>
                      <span className="font-semibold text-gray-900 text-right">$ {formatARS(data.escenarios.publico.con_iva - data.escenarios.publico.sin_iva)}</span>
                    </div>
                  )}

                  <div className="flex justify-between text-xs pt-2 border-t border-gray-200 gap-2">
                    <span className="font-bold text-gray-900">Total</span>
                    <span className="font-bold text-gray-900 text-right">$ {formatARS(data.escenarios.publico.con_iva)}</span>
                  </div>
                </div>
              </div>

              {/* Referencia de tipo de cambio */}
              <div className="space-y-2">
                <h3 className="text-sm font-bold text-gray-900">Tipo de cambio utilizado</h3>
                <div className="bg-white rounded p-2 text-xs">
                  <div className="flex justify-between items-center">
                    <span className="text-gray-600">{selectedRateLabel.label}</span>
                    <span className="font-semibold text-gray-900">$ {selectedRateData?.venta.toFixed(2)}</span>
                  </div>
                  <p className="text-gray-500 text-xs mt-1">
                    Dólar venta (precio público calculado con esta cotización)
                  </p>
                </div>
              </div>

              {/* Otras cotizaciones */}
              {exchangeRates.length > 0 && (
                <div className="space-y-2">
                  <h3 className="text-sm font-bold text-gray-900">Otras cotizaciones de referencia</h3>
                  <div className="space-y-2">
                    {/* Dólar Blue */}
                    {(() => {
                      const blueRate = exchangeRates.find(r => r.tipo === 'blue');
                      if (!blueRate) return null;
                      return (
                        <div className="bg-white rounded p-2 text-xs">
                          <p className="font-semibold text-gray-900 mb-1">Dólar Blue</p>
                          <div className="flex justify-between">
                            <span className="text-gray-600">Compra:</span>
                            <span className="font-medium text-gray-900">$ {blueRate.compra.toFixed(2)}</span>
                          </div>
                          <div className="flex justify-between">
                            <span className="text-gray-600">Venta:</span>
                            <span className="font-medium text-gray-900">$ {blueRate.venta.toFixed(2)}</span>
                          </div>
                        </div>
                      );
                    })()}

                    {/* Dólar Oficial BNA */}
                    {(() => {
                      const oficialRate = exchangeRates.find(r => r.tipo === 'oficial');
                      if (!oficialRate) return null;
                      return (
                        <div className="bg-white rounded p-2 text-xs">
                          <p className="font-semibold text-gray-900 mb-1">Dólar Oficial BNA</p>
                          <div className="flex justify-between">
                            <span className="text-gray-600">Compra:</span>
                            <span className="font-medium text-gray-900">$ {oficialRate.compra.toFixed(2)}</span>
                          </div>
                          <div className="flex justify-between">
                            <span className="text-gray-600">Venta:</span>
                            <span className="font-medium text-gray-900">$ {oficialRate.venta.toFixed(2)}</span>
                          </div>
                        </div>
                      );
                    })()}
                  </div>
                </div>
              )}
            </div>
          )}
        </div>
      ) : null}
    </div>
  );
}
