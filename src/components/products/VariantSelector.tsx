"use client"

import { useState, useEffect } from "react"

interface VariantOption {
  id: string
  title: string
  sku: string
  price: {
    priceWithoutTax: number
    priceWithTax: number
    currency: string
  }
  metadata?: {
    tiene_cabina?: boolean
    nivel_ruido_db?: number
    tipo_producto?: string
    peso_cabina_kg?: number
  }
  weight?: number
  length?: number
  width?: number
  height?: number
}

interface VariantSelectorProps {
  variants: VariantOption[]
  currentVariantId?: string
  onVariantChange?: (variantId: string) => void
  productHandle: string
}

export default function VariantSelector({
  variants,
  currentVariantId,
  onVariantChange,
  productHandle,
}: VariantSelectorProps) {
  const [selectedVariantId, setSelectedVariantId] = useState<string>(
    currentVariantId || variants[0]?.id || ""
  )

  useEffect(() => {
    if (currentVariantId && currentVariantId !== selectedVariantId) {
      setSelectedVariantId(currentVariantId)
    }
  }, [currentVariantId])

  const handleVariantSelect = (variantId: string) => {
    setSelectedVariantId(variantId)
    if (onVariantChange) {
      onVariantChange(variantId)
    }
  }

  if (!variants || variants.length === 0) {
    return null
  }

  // If only one variant, don't show selector
  if (variants.length === 1) {
    return null
  }

  return (
    <div className="variant-selector">
      <h3 className="text-lg font-semibold mb-4 text-gray-900">
        Configuración Disponible
      </h3>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
        {variants.map((variant) => {
          const isSelected = variant.id === selectedVariantId
          const tieneCabina = variant.metadata?.tiene_cabina
          const nivelRuido = variant.metadata?.nivel_ruido_db
          const weightKg = variant.weight ? variant.weight / 1000 : null
          const pesoCabina = variant.metadata?.peso_cabina_kg

          return (
            <button
              key={variant.id}
              onClick={() => handleVariantSelect(variant.id)}
              className={`
                relative p-4 rounded-lg border-2 transition-all text-left
                ${
                  isSelected
                    ? "border-blue-600 bg-blue-50 shadow-md"
                    : "border-gray-300 bg-white hover:border-gray-400 hover:shadow-sm"
                }
              `}
            >
              {/* Selected indicator */}
              {isSelected && (
                <div className="absolute top-3 right-3">
                  <div className="w-6 h-6 bg-blue-600 rounded-full flex items-center justify-center">
                    <svg
                      className="w-4 h-4 text-white"
                      fill="none"
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      strokeWidth="2"
                      viewBox="0 0 24 24"
                      stroke="currentColor"
                    >
                      <path d="M5 13l4 4L19 7"></path>
                    </svg>
                  </div>
                </div>
              )}

              {/* Variant title */}
              <div className="mb-2">
                <h4
                  className={`font-semibold text-base ${
                    isSelected ? "text-blue-900" : "text-gray-900"
                  }`}
                >
                  {tieneCabina ? "Silent (Insonorizado)" : "Abierto"}
                </h4>
                <p className="text-sm text-gray-600 mt-1">SKU: {variant.sku}</p>
              </div>

              {/* Price */}
              <div className="mb-3">
                <p className="text-2xl font-bold text-gray-900">
                  {variant.price.currency} ${variant.price.priceWithoutTax.toLocaleString("es-AR", {
                    minimumFractionDigits: 0,
                    maximumFractionDigits: 0,
                  })}
                </p>
                <p className="text-xs text-gray-500">+ IVA</p>
              </div>

              {/* Specifications */}
              <div className="space-y-1 text-sm text-gray-700">
                {nivelRuido && (
                  <div className="flex items-center gap-2">
                    <span className="text-gray-500">🔊</span>
                    <span>{nivelRuido} dB</span>
                  </div>
                )}
                {weightKg && (
                  <div className="flex items-center gap-2">
                    <span className="text-gray-500">⚖️</span>
                    <span>
                      {weightKg.toLocaleString("es-AR")} kg
                      {pesoCabina && tieneCabina && (
                        <span className="text-gray-500 ml-1">
                          (+{pesoCabina} kg cabina)
                        </span>
                      )}
                    </span>
                  </div>
                )}
                {tieneCabina !== undefined && (
                  <div className="flex items-center gap-2">
                    <span className="text-gray-500">📦</span>
                    <span>
                      {tieneCabina ? "Con cabina insonorizada" : "Sin cabina"}
                    </span>
                  </div>
                )}
              </div>
            </button>
          )
        })}
      </div>

      {/* Selected variant info */}
      <div className="mt-4 p-3 bg-gray-50 rounded-lg border border-gray-200">
        <p className="text-sm text-gray-700">
          <span className="font-semibold">Seleccionado:</span>{" "}
          {variants.find((v) => v.id === selectedVariantId)?.title || ""}
        </p>
      </div>
    </div>
  )
}
