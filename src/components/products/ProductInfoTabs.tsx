"use client";

import React, { useState } from "react";
import { FileText, Settings, Zap, Package } from "lucide-react";

interface ProductInfoTabsProps {
  description?: string;
  metadata?: Record<string, any>;
  variants?: Array<{
    id: string;
    title: string;
    sku: string;
  }>;
}

type TabType = "descripcion" | "especificaciones" | "aplicaciones" | "variantes";

export function ProductInfoTabs({ description, metadata, variants }: ProductInfoTabsProps) {
  const [activeTab, setActiveTab] = useState<TabType>("descripcion");
  const [activeSpecSection, setActiveSpecSection] = useState<string>("motor");
  const contentRef = React.useRef<HTMLDivElement>(null);

  // Función para cambiar sección y hacer scroll centrado
  const handleSectionChange = (sectionId: string) => {
    setActiveSpecSection(sectionId);
    // Scroll suave hacia el contenido centrado
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
            </h3>

            {metadata && Object.keys(metadata).length > 0 ? (
              <div className="space-y-6">
                {/* Compact Category Buttons */}
                <div className="overflow-x-auto pb-2">
                  <div className="grid grid-cols-3 sm:grid-cols-4 md:grid-cols-5 lg:grid-cols-6 xl:grid-cols-8 gap-2 min-w-max">
                    {[
                      { id: 'motor', label: 'Motor', icon: '🔧' },
                      { id: 'alternador', label: 'Alternador', icon: '⚡' },
                      { id: 'potencia', label: 'Potencia', icon: '💪' },
                      { id: 'combustible', label: 'Combustible', icon: '⛽' },
                      { id: 'panel', label: 'Panel', icon: '🎛️' },
                      { id: 'dimensiones', label: 'Dimensiones', icon: '📏' },
                      { id: 'garantia', label: 'Garantía', icon: '🛡️' },
                      { id: 'certificaciones', label: 'Certificaciones', icon: '✅' },
                      { id: 'mantenimiento', label: 'Mantenimiento', icon: '🔨' },
                      { id: 'insonorizacion', label: 'Insonorización', icon: '🔇' },
                    ].map((category) => (
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
                    {activeSpecSection.replace(/_/g, " ")}
                  </h4>

                  <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                    {Object.entries(metadata)
                      .filter(([key, value]) => {
                        // Solo mostrar valores simples (string, number, boolean)
                        if (typeof value === 'object' && value !== null) return false;
                        // Excluir campos internos que empiezan con _
                        if (key.startsWith('_')) return false;
                        // Excluir documentos (ya se muestra como botón PDF)
                        if (key === 'documentos') return false;

                        // Filtrar por categoría activa
                        const keyLower = key.toLowerCase();
                        const sectionLower = activeSpecSection.toLowerCase();

                        // Mapeo de campos a categorías
                        if (sectionLower === 'motor' && (
                          keyLower.includes('motor') ||
                          keyLower.includes('cilindros') ||
                          keyLower.includes('cilindrada') ||
                          keyLower.includes('refrigeracion')
                        )) return true;

                        if (sectionLower === 'alternador' && (
                          keyLower.includes('alternador') ||
                          keyLower.includes('generador')
                        )) return true;

                        if (sectionLower === 'potencia' && (
                          keyLower.includes('potencia') ||
                          keyLower.includes('kva') ||
                          keyLower.includes('kw') ||
                          keyLower.includes('standby') ||
                          keyLower.includes('prime')
                        )) return true;

                        if (sectionLower === 'combustible' && (
                          keyLower.includes('combustible') ||
                          keyLower.includes('tanque') ||
                          keyLower.includes('consumo') ||
                          keyLower.includes('autonomia')
                        )) return true;

                        if (sectionLower === 'panel' && (
                          keyLower.includes('panel') ||
                          keyLower.includes('control') ||
                          keyLower.includes('transferencia')
                        )) return true;

                        if (sectionLower === 'dimensiones' && (
                          keyLower.includes('dimension') ||
                          keyLower.includes('peso') ||
                          keyLower.includes('largo') ||
                          keyLower.includes('ancho') ||
                          keyLower.includes('alto')
                        )) return true;

                        if (sectionLower === 'garantia' && (
                          keyLower.includes('garantia') ||
                          keyLower.includes('warranty')
                        )) return true;

                        if (sectionLower === 'certificaciones' && (
                          keyLower.includes('certificacion') ||
                          keyLower.includes('norma') ||
                          keyLower.includes('iso')
                        )) return true;

                        if (sectionLower === 'mantenimiento' && (
                          keyLower.includes('mantenimiento') ||
                          keyLower.includes('servicio') ||
                          keyLower.includes('aceite')
                        )) return true;

                        if (sectionLower === 'insonorizacion' && (
                          keyLower.includes('ruido') ||
                          keyLower.includes('sonoro') ||
                          keyLower.includes('decibel') ||
                          keyLower.includes('db')
                        )) return true;

                        return false;
                      })
                      .map(([key, value]) => (
                        <div
                          key={key}
                          className="bg-white border border-gray-200 rounded-lg p-4 hover:shadow-md transition-all duration-300 hover:border-[#FF6B00] group"
                        >
                          <p className="text-sm font-medium text-gray-600 capitalize mb-1 group-hover:text-[#FF6B00] transition-colors">
                            {key.replace(/_/g, " ")}
                          </p>
                          <p className="text-gray-900 font-semibold text-lg">
                            {typeof value === "boolean"
                              ? value
                                ? "Sí"
                                : "No"
                              : String(value)}
                          </p>
                        </div>
                      ))}
                  </div>

                  {Object.entries(metadata).filter(([key, value]) => {
                    if (typeof value === 'object' && value !== null) return false;
                    if (key.startsWith('_')) return false;
                    if (key === 'documentos') return false;
                    const keyLower = key.toLowerCase();
                    const sectionLower = activeSpecSection.toLowerCase();

                    if (sectionLower === 'motor' && (keyLower.includes('motor') || keyLower.includes('cilindros') || keyLower.includes('cilindrada') || keyLower.includes('refrigeracion'))) return true;
                    if (sectionLower === 'alternador' && (keyLower.includes('alternador') || keyLower.includes('generador'))) return true;
                    if (sectionLower === 'potencia' && (keyLower.includes('potencia') || keyLower.includes('kva') || keyLower.includes('kw') || keyLower.includes('standby') || keyLower.includes('prime'))) return true;
                    if (sectionLower === 'combustible' && (keyLower.includes('combustible') || keyLower.includes('tanque') || keyLower.includes('consumo') || keyLower.includes('autonomia'))) return true;
                    if (sectionLower === 'panel' && (keyLower.includes('panel') || keyLower.includes('control') || keyLower.includes('transferencia'))) return true;
                    if (sectionLower === 'dimensiones' && (keyLower.includes('dimension') || keyLower.includes('peso') || keyLower.includes('largo') || keyLower.includes('ancho') || keyLower.includes('alto'))) return true;
                    if (sectionLower === 'garantia' && (keyLower.includes('garantia') || keyLower.includes('warranty'))) return true;
                    if (sectionLower === 'certificaciones' && (keyLower.includes('certificacion') || keyLower.includes('norma') || keyLower.includes('iso'))) return true;
                    if (sectionLower === 'mantenimiento' && (keyLower.includes('mantenimiento') || keyLower.includes('servicio') || keyLower.includes('aceite'))) return true;
                    if (sectionLower === 'insonorizacion' && (keyLower.includes('ruido') || keyLower.includes('sonoro') || keyLower.includes('decibel') || keyLower.includes('db'))) return true;

                    return false;
                  }).length === 0 && (
                    <p className="text-gray-500 italic text-center py-4">
                      No hay especificaciones disponibles para esta categoría
                    </p>
                  )}
                </div>
              </div>
            ) : (
              <p className="text-gray-500 italic">No hay especificaciones disponibles</p>
            )}
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
              {/* DINÁMICO desde metadata.aplicaciones_industriales */}
              {(metadata.aplicaciones_industriales && Array.isArray(metadata.aplicaciones_industriales)
                ? metadata.aplicaciones_industriales
                : []
              ).map((app: any, index: number) => (
                <div
                  key={index}
                  className="bg-white border border-gray-200 rounded-lg p-6 hover:shadow-xl transition-all duration-300 hover:border-[#FF6B00] hover:-translate-y-1 group"
                >
                  <div className="text-4xl mb-4 group-hover:scale-110 transition-transform">
                    {app.icon}
                  </div>
                  <h4 className="text-lg font-semibold text-gray-900 mb-2 group-hover:text-[#FF6B00] transition-colors">
                    {app.title}
                  </h4>
                  <p className="text-gray-600 text-sm">{app.description}</p>
                </div>
              ))}
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
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              {variants.map((variant) => (
                <div
                  key={variant.id}
                  className="bg-white border-2 border-gray-200 rounded-lg p-6 hover:border-[#FF6B00] hover:shadow-lg transition-all duration-300"
                >
                  <p className="font-semibold text-lg text-gray-900 mb-2">
                    {variant.title}
                  </p>
                  <p className="text-sm text-gray-600">
                    <span className="font-medium">SKU:</span> {variant.sku}
                  </p>
                </div>
              ))}
            </div>
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
