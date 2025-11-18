"use client";

import React, { useState, useEffect } from "react";
import { FileText, Settings, Zap, Package, Loader2 } from "lucide-react";
import VariantSelector from "./VariantSelector";
import CompatibleAccessories from "./CompatibleAccessories";
import RelatedProducts from "./RelatedProducts";

interface ProductInfoTabsProps {
  description?: string;
  metadata?: Record<string, any>;
  variants?: Array<{
    id: string;
    title: string;
    sku: string;
    price?: {
      priceWithoutTax: number;
      priceWithTax: number;
      currency: string;
    };
    metadata?: Record<string, any>;
    weight?: number;
    length?: number;
    width?: number;
    height?: number;
  }>;
  productHandle?: string;
  weight?: number | null;
  length?: number | null;
  width?: number | null;
  height?: number | null;
}

type TabType = "descripcion" | "especificaciones" | "aplicaciones" | "variantes";

// Helper function to format field values
function formatValue(field: any): string {
  if (!field) return "";

  const valor = field.valor;
  const unidad = field.unidad || "";

  if (typeof valor === "boolean") {
    return valor ? "Sí" : "No";
  }

  if (Array.isArray(valor)) {
    return valor.join(", ");
  }

  if (unidad) {
    return `${valor} ${unidad}`;
  }

  return String(valor);
}

// Helper function to get readable label from field key
function getLabel(key: string): string {
  return key
    .replace(/_/g, " ")
    .replace(/\b\w/g, l => l.toUpperCase())
    .replace(/Kva/g, "kVA")
    .replace(/Kw/g, "kW")
    .replace(/Db/g, "dB")
    .replace(/Hp/g, "HP")
    .replace(/Rpm/g, "RPM");
}

export function ProductInfoTabs({ description, metadata, variants, productHandle, weight, length, width, height }: ProductInfoTabsProps) {
  const [activeTab, setActiveTab] = useState<TabType>("descripcion");
  const [activeSpecSection, setActiveSpecSection] = useState<string>("motor");
  const [dynamicMetadata, setDynamicMetadata] = useState<any>(null);
  const [loading, setLoading] = useState(false);
  const contentRef = React.useRef<HTMLDivElement>(null);

  // Fetch dynamic metadata from API
  useEffect(() => {
    if (productHandle) {
      setLoading(true);
      fetch(`/api/product-metadata/${productHandle}`)
        .then(res => res.json())
        .then(data => {
          if (data.success && data.metadata) {
            setDynamicMetadata(data.metadata);
          }
          setLoading(false);
        })
        .catch(err => {
          console.error("Error fetching metadata:", err);
          setLoading(false);
        });
    }
  }, [productHandle]);

  // Use dynamic metadata if available, otherwise fall back to props
  const effectiveMetadata = dynamicMetadata || metadata || {};

  const handleSectionChange = (sectionId: string) => {
    setActiveSpecSection(sectionId);
    setTimeout(() => {
      contentRef.current?.scrollIntoView({
        behavior: 'smooth',
        block: 'center'
      });
    }, 100);
  };

  const tabs = [
    { id: "descripcion" as TabType, label: "Descripción", icon: FileText },
    { id: "especificaciones" as TabType, label: "Especificaciones", icon: Settings },
    { id: "aplicaciones" as TabType, label: "Aplicaciones", icon: Zap },
    ...(variants && variants.length > 0
      ? [{ id: "variantes" as TabType, label: "Variantes", icon: Package }]
      : []),
  ];

  // Category mapping for the new structure
  const categoryConfig = [
    { id: 'motor', label: 'Motor', icon: '🔧', key: 'motor' },
    { id: 'alternador', label: 'Alternador', icon: '⚡', key: 'alternador' },
    { id: 'potencia', label: 'Potencia', icon: '💪', key: 'potencia' },
    { id: 'combustible', label: 'Combustible', icon: '⛽', key: 'combustible' },
    { id: 'panel', label: 'Panel', icon: '🎛️', key: 'panel_control' },
    { id: 'ruido', label: 'Cabina/Ruido', icon: '🔇', key: 'ruido_cabina' },
    { id: 'dimensiones', label: 'Dimensiones', icon: '📏', key: 'dimensiones' },
    { id: 'electrico', label: 'Eléctrico', icon: '🔌', key: 'sistema_electrico' },
    { id: 'garantia', label: 'Garantía', icon: '🛡️', key: 'garantia' },
    { id: 'certificaciones', label: 'Certificaciones', icon: '✅', key: 'certificaciones' },
  ];

  // Function to render specifications from dynamic metadata
  const renderSpecifications = (categoryKey: string) => {
    const categoryData = effectiveMetadata[categoryKey];

    if (!categoryData) {
      return (
        <p className="text-gray-500 italic text-center py-4 col-span-2">
          No hay especificaciones disponibles para esta categoría
        </p>
      );
    }

    // Handle array type (like certificaciones)
    if (Array.isArray(categoryData)) {
      return (
        <div className="col-span-2">
          <div className="flex flex-wrap gap-2">
            {categoryData.map((item: string, idx: number) => (
              <span
                key={idx}
                className="bg-green-100 text-green-800 px-3 py-1 rounded-full text-sm font-medium"
              >
                ✓ {item}
              </span>
            ))}
          </div>
        </div>
      );
    }

    // Handle object with typed valor
    if (categoryData.tipo && categoryData.valor !== undefined) {
      return (
        <div className="bg-white border border-gray-200 rounded-lg p-4 hover:shadow-md transition-all duration-300 hover:border-[#FF6B00] group col-span-2">
          <p className="text-sm font-medium text-gray-600 mb-1">
            {categoryData.descripcion || getLabel(categoryKey)}
          </p>
          <p className="text-gray-900 font-semibold text-lg">
            {formatValue(categoryData)}
          </p>
        </div>
      );
    }

    // Handle nested object structure
    const specs: Array<{label: string, value: string, destacado?: boolean}> = [];

    for (const key in categoryData) {
      const field = categoryData[key];
      if (field && typeof field === 'object' && field.valor !== undefined) {
        specs.push({
          label: field.descripcion || getLabel(key.replace(categoryKey + '_', '')),
          value: formatValue(field),
          destacado: field.destacado
        });
      }
    }

    // Sort: highlighted first, then alphabetical
    specs.sort((a, b) => {
      if (a.destacado && !b.destacado) return -1;
      if (!a.destacado && b.destacado) return 1;
      return 0;
    });

    return specs.length > 0 ? (
      specs.map((item, idx) => (
        <div
          key={idx}
          className={`bg-white border rounded-lg p-4 hover:shadow-md transition-all duration-300 hover:border-[#FF6B00] group ${
            item.destacado ? 'border-[#FF6B00] bg-orange-50' : 'border-gray-200'
          }`}
        >
          <p className="text-sm font-medium text-gray-600 mb-1 group-hover:text-[#FF6B00] transition-colors">
            {item.label}
          </p>
          <p className="text-gray-900 font-semibold text-lg">
            {item.value}
          </p>
        </div>
      ))
    ) : (
      <p className="text-gray-500 italic text-center py-4 col-span-2">
        No hay especificaciones disponibles para esta categoría
      </p>
    );
  };

  return (
    <div className="w-full">
      {/* Tab Headers */}
      <div className="flex gap-1 border-b-2 border-gray-200 overflow-x-auto">
        {tabs.map((tab) => {
          const Icon = tab.icon;
          return (
            <button
              key={tab.id}
              onClick={() => setActiveTab(tab.id)}
              className={`flex items-center gap-2 px-6 py-4 font-semibold text-sm transition-all duration-300 whitespace-nowrap ${
                activeTab === tab.id
                  ? "text-[#FF6B00] border-b-4 border-[#FF6B00] -mb-[2px] bg-red-50"
                  : "text-gray-600 hover:text-gray-900 hover:bg-gray-50"
              }`}
            >
              <Icon className="w-5 h-5" />
              {tab.label}
            </button>
          );
        })}
      </div>

      {/* Tab Content */}
      <div className="mt-8 animate-fadeIn">
        {/* Descripción */}
        {activeTab === "descripcion" && (
          <div className="prose max-w-none">
            {description ? (
              <div className="bg-white rounded-lg p-6 border border-gray-200 shadow-sm">
                <h3 className="text-2xl font-bold text-gray-900 mb-4 flex items-center gap-2">
                  <FileText className="w-6 h-6 text-[#FF6B00]" />
                  Descripción del Producto
                </h3>
                <p className="text-gray-700 leading-relaxed whitespace-pre-line">
                  {description}
                </p>
              </div>
            ) : (
              <p className="text-gray-500 italic">No hay descripción disponible</p>
            )}
          </div>
        )}

        {/* Especificaciones */}
        {activeTab === "especificaciones" && (
          <div>
            <h3 className="text-2xl font-bold text-gray-900 mb-6 flex items-center gap-2">
              <Settings className="w-6 h-6 text-[#FF6B00]" />
              Especificaciones Técnicas
              {loading && <Loader2 className="w-5 h-5 animate-spin text-gray-400" />}
            </h3>

            <div className="space-y-6">
              {/* Category Buttons */}
              <div className="overflow-x-auto pb-2">
                <div className="grid grid-cols-3 sm:grid-cols-4 md:grid-cols-5 lg:grid-cols-6 xl:grid-cols-8 gap-2 min-w-max">
                  {categoryConfig.map((category) => (
                    <button
                      key={category.id}
                      onClick={() => handleSectionChange(category.id)}
                      className={`flex flex-col items-center justify-center px-2 py-2.5 border rounded-lg transition-all duration-300 ${
                        activeSpecSection === category.id
                          ? 'bg-[#FF6B00] text-white border-[#FF6B00] scale-110 shadow-lg'
                          : 'bg-white text-gray-700 border-gray-300 hover:border-[#FF6B00] hover:bg-red-50'
                      }`}
                    >
                      <span className="text-xl mb-1">{category.icon}</span>
                      <span className="text-[10px] font-medium text-center leading-tight">
                        {category.label}
                      </span>
                    </button>
                  ))}
                </div>
              </div>

              {/* Content Panel */}
              <div
                ref={contentRef}
                className="scroll-mt-4 bg-gradient-to-br from-gray-50 to-white border border-gray-200 rounded-lg p-6 shadow-sm"
              >
                <h4 className="text-xl font-bold text-[#FF6B00] mb-4 capitalize">
                  {categoryConfig.find(c => c.id === activeSpecSection)?.label || activeSpecSection}
                </h4>

                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  {renderSpecifications(
                    categoryConfig.find(c => c.id === activeSpecSection)?.key || activeSpecSection
                  )}
                </div>
              </div>
            </div>
          </div>
        )}

        {/* Aplicaciones */}
        {activeTab === "aplicaciones" && (
          <div>
            <h3 className="text-2xl font-bold text-gray-900 mb-6 flex items-center gap-2">
              <Zap className="w-6 h-6 text-[#FF6B00]" />
              Aplicaciones Industriales
            </h3>
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
              {/* Dynamic from metadata.aplicaciones */}
              {(effectiveMetadata?.aplicaciones && Array.isArray(effectiveMetadata.aplicaciones)
                ? effectiveMetadata.aplicaciones
                : effectiveMetadata?.aplicaciones_industriales || []
              ).map((app: any, index: number) => (
                <div
                  key={index}
                  className="bg-white border border-gray-200 rounded-lg p-6 hover:shadow-xl transition-all duration-300 hover:border-[#FF6B00] hover:-translate-y-1 group"
                >
                  <div className="text-4xl mb-4 group-hover:scale-110 transition-transform">
                    {app.icon || '🏭'}
                  </div>
                  <h4 className="text-lg font-semibold text-gray-900 mb-2 group-hover:text-[#FF6B00] transition-colors">
                    {app.industria || app.title}
                  </h4>
                  <p className="text-gray-600 text-sm mb-3">
                    {app.casos_uso?.join(", ") || app.description}
                  </p>
                  {app.beneficios && (
                    <ul className="text-xs text-gray-500 space-y-1">
                      {app.beneficios.map((b: string, i: number) => (
                        <li key={i}>✓ {b}</li>
                      ))}
                    </ul>
                  )}
                </div>
              ))}

              {/* Fallback if no applications */}
              {(!effectiveMetadata?.aplicaciones && !effectiveMetadata?.aplicaciones_industriales) && (
                <p className="text-gray-500 italic col-span-3">
                  No hay aplicaciones definidas para este producto
                </p>
              )}
            </div>
          </div>
        )}

        {/* Variantes */}
        {activeTab === "variantes" && variants && variants.length > 0 && (
          <div>
            <h3 className="text-2xl font-bold text-gray-900 mb-6 flex items-center gap-2">
              <Package className="w-6 h-6 text-[#FF6B00]" />
              Variantes Disponibles
            </h3>

            {variants.length > 1 && (
              <VariantSelector
                variants={variants as any}
                productHandle={productHandle || ""}
              />
            )}

            {effectiveMetadata?.accesorios_compatibles && effectiveMetadata.accesorios_compatibles.length > 0 && (
              <div className="mt-10">
                <CompatibleAccessories accessories={effectiveMetadata.accesorios_compatibles} />
              </div>
            )}

            {effectiveMetadata?.productos_relacionados && effectiveMetadata.productos_relacionados.length > 0 && (
              <div className="mt-10">
                <RelatedProducts
                  products={effectiveMetadata.productos_relacionados}
                  currentProductHandle={productHandle}
                />
              </div>
            )}

            {effectiveMetadata?.servicios_disponibles && effectiveMetadata.servicios_disponibles.length > 0 && (
              <div className="mt-10">
                <CompatibleAccessories accessories={effectiveMetadata.servicios_disponibles} />
              </div>
            )}
          </div>
        )}
      </div>

      <style jsx>{`
        @keyframes fadeIn {
          from {
            opacity: 0;
            transform: translateY(10px);
          }
          to {
            opacity: 1;
            transform: translateY(0);
          }
        }
        .animate-fadeIn {
          animation: fadeIn 0.4s ease-out;
        }
      `}</style>
    </div>
  );
}
