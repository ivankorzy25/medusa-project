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
  // Dimensional fields from Medusa product
  weight?: number | null;
  length?: number | null;
  width?: number | null;
  height?: number | null;
}

type TabType = "descripcion" | "especificaciones" | "aplicaciones" | "variantes";

export function ProductInfoTabs({ description, metadata, variants, weight, length, width, height }: ProductInfoTabsProps) {
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
                    {(() => {
                      // Crear especificaciones curadas basadas en JSON y metadata
                      const specs: Record<string, Array<{label: string, value: string}>> = {
                        motor: [
                          { label: "Marca", value: metadata.motor_marca || "Cummins" },
                          { label: "Modelo", value: metadata.motor_modelo || metadata.modelo_motor },
                          { label: "Tipo", value: metadata.motor_aspiracion || "Diesel 4 tiempos Turbo" },
                          { label: "Cilindros", value: metadata.cilindros ? `${metadata.cilindros} en línea` : "6" },
                          { label: "Cilindrada", value: metadata.cilindrada_litros || "8.3 Litros" },
                          { label: "Velocidad", value: metadata.motor_rpm ? `${metadata.motor_rpm} RPM` : "1500 RPM" },
                          { label: "Refrigeración", value: metadata.motor_refrigeracion || "Por agua con radiador" },
                          { label: "Capacidad de aceite", value: "24 Litros" },
                          { label: "Aceite recomendado", value: metadata.motor_marca === "Cummins" ? "SAE 15W-40 API CI-4" : "SAE 15W-40" },
                          { label: "Vida útil esperada", value: "30,000 horas con mantenimiento" },
                        ].filter(item => item.value),

                        alternador: [
                          { label: "Marca", value: metadata.alternador_marca || "Stamford" },
                          { label: "Modelo", value: metadata.alternador_modelo || metadata.modelo_alternador },
                          { label: "Tipo", value: "Sin escobillas (Brushless)" },
                          { label: "Tecnología", value: "Autoexcitado" },
                          { label: "Regulación de voltaje", value: "±0.5% con AVR Digital" },
                          { label: "Clase de aislamiento", value: "Clase H (180°C)" },
                          { label: "Grado de protección", value: "IP23" },
                          { label: "Polos", value: "4 polos" },
                        ].filter(item => item.value),

                        potencia: [
                          { label: "Potencia Stand-by", value: metadata.potencia_standby_kva ? `${metadata.potencia_standby_kva} kVA` : metadata.potencia_kva },
                          { label: "Potencia Stand-by (kW)", value: metadata.potencia_standby_kw ? `${metadata.potencia_standby_kw} kW` : null },
                          { label: "Potencia Prime", value: metadata.potencia_prime_kva ? `${metadata.potencia_prime_kva} kVA` : null },
                          { label: "Potencia Prime (kW)", value: metadata.potencia_prime_kw ? `${metadata.potencia_prime_kw} kW` : null },
                          { label: "Factor de potencia", value: metadata.factor_potencia || "0.8" },
                          { label: "Voltaje", value: metadata.voltaje || metadata.tension },
                          { label: "Frecuencia", value: metadata.frecuencia || "50 Hz" },
                          { label: "Fases", value: metadata.fases || "Trifásico" },
                        ].filter(item => item.value),

                        combustible: [
                          { label: "Tipo", value: metadata.combustible_tipo || "Diesel" },
                          { label: "Grado recomendado", value: "Diesel D2 / ULSD" },
                          { label: "Capacidad del tanque", value: metadata.combustible_tanque_capacidad ? `${metadata.combustible_tanque_capacidad} L` : metadata.tanque },
                          { label: "Consumo al 75%", value: metadata.consumo_75_carga || metadata.consumo },
                          { label: "Consumo al 100%", value: metadata.consumo_100_carga || "42-45 L/h" },
                          { label: "Autonomía al 75%", value: metadata.autonomia_75_carga || metadata.autonomia },
                          { label: "Índice cetano mínimo", value: "45" },
                          { label: "Filtro de combustible", value: "4 micrones - reemplazo cada 500h" },
                        ].filter(item => item.value),

                        panel: [
                          { label: "Marca", value: metadata.panel_marca || "ComAp" },
                          { label: "Modelo", value: metadata.panel_modelo || metadata.modelo_panel },
                          { label: "Tipo", value: metadata.panel_tipo || "Digital LCD" },
                          { label: "Arranque automático", value: metadata.arranque_automatico ? "Sí - en menos de 10 seg" : "Sí" },
                          { label: "Comunicación", value: "ModBus RTU/TCP, CAN bus, USB" },
                          { label: "Protecciones", value: "Sobrecarga, cortocircuito, baja/alta tensión" },
                          { label: "Registro de eventos", value: "Hasta 1000 eventos con fecha/hora" },
                          { label: "Parada de emergencia", value: "Sí - externa" },
                        ].filter(item => item.value),

                        dimensiones: [
                          // Largo - buscar primero en props, luego en metadata
                          {
                            label: "Largo total",
                            value: (() => {
                              const largo = length || metadata.largo_mm || metadata.length_mm || metadata.length || metadata.largo;
                              if (!largo) return null;
                              const largoNum = typeof largo === 'string' ? parseFloat(largo) : largo;
                              return `${largoNum} mm (${(largoNum / 1000).toFixed(2)} m)`;
                            })()
                          },
                          // Ancho - buscar primero en props, luego en metadata
                          {
                            label: "Ancho total",
                            value: (() => {
                              const ancho = width || metadata.ancho_mm || metadata.width_mm || metadata.width || metadata.ancho;
                              if (!ancho) return null;
                              const anchoNum = typeof ancho === 'string' ? parseFloat(ancho) : ancho;
                              return `${anchoNum} mm (${(anchoNum / 1000).toFixed(2)} m)`;
                            })()
                          },
                          // Alto - buscar primero en props, luego en metadata
                          {
                            label: "Alto total",
                            value: (() => {
                              const alto = height || metadata.alto_mm || metadata.height_mm || metadata.height || metadata.alto;
                              if (!alto) return null;
                              const altoNum = typeof alto === 'string' ? parseFloat(alto) : alto;
                              return `${altoNum} mm (${(altoNum / 1000).toFixed(2)} m)`;
                            })()
                          },
                          // Peso en seco - buscar primero en props, luego en metadata
                          {
                            label: "Peso en seco",
                            value: (() => {
                              const peso = weight || metadata.peso_kg || metadata.weight_kg || metadata.weight || metadata.peso;
                              if (!peso) return null;
                              const pesoNum = typeof peso === 'string' ? parseFloat(peso) : peso;
                              return `${pesoNum} kg (${(pesoNum / 1000).toFixed(2)} ton)`;
                            })()
                          },
                          // Peso operativo
                          {
                            label: "Peso operativo",
                            value: (() => {
                              const pesoOp = metadata.peso_operativo_kg || metadata.operating_weight_kg;
                              if (!pesoOp) return null;
                              const pesoOpNum = typeof pesoOp === 'string' ? parseFloat(pesoOp) : pesoOp;
                              return `${pesoOpNum} kg (${(pesoOpNum / 1000).toFixed(2)} ton)`;
                            })()
                          },
                          // Área de base
                          {
                            label: "Área de base",
                            value: (() => {
                              const largo = length || metadata.largo_mm || metadata.length_mm || metadata.length || metadata.largo;
                              const ancho = width || metadata.ancho_mm || metadata.width_mm || metadata.width || metadata.ancho;
                              if (!largo || !ancho) return null;
                              const largoNum = typeof largo === 'string' ? parseFloat(largo) : largo;
                              const anchoNum = typeof ancho === 'string' ? parseFloat(ancho) : ancho;
                              const area = ((largoNum * anchoNum) / 1000000).toFixed(2);
                              return `${area} m² (${largoNum}x${anchoNum} mm)`;
                            })()
                          },
                          // Volumen aproximado
                          {
                            label: "Volumen aproximado",
                            value: (() => {
                              const largo = length || metadata.largo_mm || metadata.length_mm || metadata.length || metadata.largo;
                              const ancho = width || metadata.ancho_mm || metadata.width_mm || metadata.width || metadata.ancho;
                              const alto = height || metadata.alto_mm || metadata.height_mm || metadata.height || metadata.alto;
                              if (!largo || !ancho || !alto) return null;
                              const largoNum = typeof largo === 'string' ? parseFloat(largo) : largo;
                              const anchoNum = typeof ancho === 'string' ? parseFloat(ancho) : ancho;
                              const altoNum = typeof alto === 'string' ? parseFloat(alto) : alto;
                              const volumen = ((largoNum * anchoNum * altoNum) / 1000000000).toFixed(2);
                              return `${volumen} m³`;
                            })()
                          },
                          // Peso sin combustible
                          {
                            label: "Peso sin combustible",
                            value: (() => {
                              const peso = weight || metadata.peso_kg || metadata.weight_kg || metadata.weight || metadata.peso;
                              const tanque = metadata.combustible_tanque_capacidad || metadata.fuel_tank_capacity;
                              if (!peso || !tanque) return null;
                              const pesoNum = typeof peso === 'string' ? parseFloat(peso) : peso;
                              const tanqueNum = typeof tanque === 'string' ? parseFloat(tanque) : tanque;
                              const pesoSinCombustible = pesoNum - Math.round(tanqueNum * 0.85);
                              return `${pesoSinCombustible} kg aprox`;
                            })()
                          },
                          // Base requerida
                          {
                            label: "Base de hormigón",
                            value: (() => {
                              const largo = length || metadata.largo_mm || metadata.length_mm || metadata.length || metadata.largo;
                              const ancho = width || metadata.ancho_mm || metadata.width_mm || metadata.width || metadata.ancho;
                              if (!largo || !ancho) return "Consultar instalador";
                              const largoNum = typeof largo === 'string' ? parseFloat(largo) : largo;
                              const anchoNum = typeof ancho === 'string' ? parseFloat(ancho) : ancho;
                              return `Mínimo ${(largoNum / 1000).toFixed(2)}m x ${(anchoNum / 1000).toFixed(2)}m`;
                            })()
                          },
                          { label: "Separación de paredes", value: "Mínimo 1 metro lateral y posterior" },
                          // Altura libre superior
                          {
                            label: "Altura libre superior",
                            value: (() => {
                              const alto = height || metadata.alto_mm || metadata.height_mm || metadata.height || metadata.alto;
                              if (!alto) return "2.5 m recomendado";
                              const altoNum = typeof alto === 'string' ? parseFloat(alto) : alto;
                              return `Mínimo ${(altoNum / 1000 + 0.5).toFixed(2)} m`;
                            })()
                          },
                          // Capacidad de grúa
                          {
                            label: "Capacidad de grúa",
                            value: (() => {
                              const pesoOp = metadata.peso_operativo_kg || metadata.operating_weight_kg;
                              const peso = weight || metadata.peso_kg || metadata.weight_kg || metadata.weight || metadata.peso;
                              const pesoFinal = pesoOp || peso;
                              if (!pesoFinal) return null;
                              const pesoNum = typeof pesoFinal === 'string' ? parseFloat(pesoFinal) : pesoFinal;
                              return `${Math.ceil(pesoNum / 1000)} toneladas mínimo`;
                            })()
                          },
                        ].filter(item => item.value),

                        garantia: [
                          { label: "Garantía oficial", value: metadata.garantia || "12 meses o 2400 horas" },
                          { label: "Cobertura", value: "Motor, alternador y componentes" },
                          { label: "Validez", value: "Internacional - 190+ países" },
                          { label: "Red de servicio", value: metadata.motor_marca === "Cummins" ? "50+ puntos en Argentina" : "Consultar" },
                          { label: "Disponibilidad repuestos", value: "24-48 horas garantizado" },
                          { label: "Soporte técnico", value: "Atención en menos de 24hs" },
                          { label: "Primera puesta en marcha", value: "Incluida con capacitación" },
                          { label: "Valor de reventa", value: "Mantiene 40-50% a 5 años" },
                        ].filter(item => item.value),

                        certificaciones: [
                          { label: "Rendimiento y seguridad", value: "ISO 8528" },
                          { label: "Emisiones motor", value: "EPA Tier 2 / IMO Tier II" },
                          { label: "Máquinas rotatorias", value: "IEC 60034 (alternadores)" },
                          { label: "Calidad fabricación", value: "ISO 9001:2015" },
                          { label: "Gestión ambiental", value: "ISO 14001" },
                          { label: "Normativas eléctricas", value: "ITC-BT-40 REBT España" },
                          { label: "Normas MERCOSUR", value: "NOM aplicables" },
                          { label: "Certificación fabricante", value: metadata.motor_marca || "Cummins Inc." },
                        ].filter(item => item.value),

                        mantenimiento: [
                          { label: "Primer servicio", value: "50 horas de operación" },
                          { label: "Intervalo estándar", value: "500 horas o 6 meses" },
                          { label: "Cambio de aceite", value: "Cada 500h - 24 litros SAE 15W-40" },
                          { label: "Filtro de aceite", value: "Cada 500 horas" },
                          { label: "Filtro de combustible", value: "Cada 500 horas" },
                          { label: "Filtro de aire", value: "Cada 500 horas o según condiciones" },
                          { label: "Refrigerante", value: "Agua + 50% anticongelante OAT" },
                          { label: "Revisión general", value: "Cada 2000 horas o anualmente" },
                          { label: "Baterías", value: "Verificar carga mensualmente" },
                          { label: "Inspección visual", value: "Semanal (fugas, conexiones)" },
                        ].filter(item => item.value),

                        insonorizacion: [
                          { label: "Tipo de cabina", value: metadata.cabina || (metadata.insonorizado?.includes("Sí") ? "Silent Premium" : "Sin cabina") },
                          { label: "Nivel de ruido", value: metadata.insonorizado || metadata.nivel_ruido || "Consultar según modelo" },
                          { label: "Distancia de medición", value: "7 metros" },
                          { label: "Normativas urbanas", value: metadata.cabina ? "Cumple regulaciones" : "Requiere cabina opcional" },
                          { label: "Material aislante", value: metadata.cabina ? "Espuma de poliuretano" : "N/A" },
                          { label: "Reducción de ruido", value: metadata.cabina ? "Hasta 30 dB de reducción" : "Requiere cabina opcional" },
                        ].filter(item => item.value),
                      };

                      const currentSpecs = specs[activeSpecSection] || [];

                      return currentSpecs.length > 0 ? (
                        currentSpecs.map((item, idx) => (
                          <div
                            key={idx}
                            className="bg-white border border-gray-200 rounded-lg p-4 hover:shadow-md transition-all duration-300 hover:border-[#FF6B00] group"
                          >
                            <p className="text-sm font-medium text-gray-600 capitalize mb-1 group-hover:text-[#FF6B00] transition-colors">
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
                    })()}
                  </div>
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
