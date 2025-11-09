"use client"

import Link from "next/link"

interface RelatedProduct {
  type: string
  handle: string
  descripcion: string
  title?: string
  precio_usd?: number
  potencia_kva?: number
  imagen_url?: string
}

interface RelatedProductsProps {
  products: RelatedProduct[]
  currentProductHandle?: string
}

export default function RelatedProducts({
  products,
  currentProductHandle,
}: RelatedProductsProps) {
  if (!products || products.length === 0) {
    return null
  }

  // Filter out current product if specified
  const filteredProducts = currentProductHandle
    ? products.filter((p) => p.handle !== currentProductHandle)
    : products

  if (filteredProducts.length === 0) {
    return null
  }

  const getTypeLabel = (type: string) => {
    const labels: Record<string, { text: string; color: string }> = {
      version_alternativa: {
        text: "Alternativa",
        color: "bg-blue-100 text-blue-800",
      },
      version_mayor: {
        text: "Mayor Potencia",
        color: "bg-green-100 text-green-800",
      },
      version_menor: {
        text: "Más Económico",
        color: "bg-orange-100 text-orange-800",
      },
      version_similar: {
        text: "Similar",
        color: "bg-gray-100 text-gray-800",
      },
    }
    return labels[type] || { text: type, color: "bg-gray-100 text-gray-800" }
  }

  const getTypeIcon = (type: string) => {
    const icons: Record<string, string> = {
      version_alternativa: "🔄",
      version_mayor: "⬆️",
      version_menor: "⬇️",
      version_similar: "↔️",
    }
    return icons[type] || "📦"
  }

  return (
    <div className="related-products mt-8">
      <h3 className="text-xl font-bold mb-6 text-gray-900">
        Productos Relacionados
      </h3>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
        {filteredProducts.map((product, index) => {
          const typeInfo = getTypeLabel(product.type)

          return (
            <Link
              key={`${product.handle}-${index}`}
              href={`/producto/${product.handle}`}
              className="block border border-gray-200 rounded-lg p-4 bg-white hover:shadow-lg hover:border-blue-300 transition-all group"
            >
              {/* Type badge */}
              <div className="mb-3 flex items-center gap-2">
                <span className="text-xl">{getTypeIcon(product.type)}</span>
                <span
                  className={`text-xs font-semibold px-2 py-1 rounded-full ${typeInfo.color}`}
                >
                  {typeInfo.text}
                </span>
              </div>

              {/* Product title */}
              <h4 className="font-semibold text-base text-gray-900 mb-2 group-hover:text-blue-600 transition-colors">
                {product.title || product.handle}
              </h4>

              {/* Description */}
              <p className="text-sm text-gray-600 mb-3">{product.descripcion}</p>

              {/* Specs */}
              <div className="space-y-1 mb-3">
                {product.potencia_kva && (
                  <div className="flex items-center gap-2 text-sm">
                    <span className="text-gray-500">⚡</span>
                    <span className="text-gray-700 font-medium">
                      {product.potencia_kva} KVA
                    </span>
                  </div>
                )}
                {product.precio_usd && (
                  <div className="flex items-center gap-2 text-sm">
                    <span className="text-gray-500">💰</span>
                    <span className="text-gray-700 font-medium">
                      USD ${product.precio_usd.toLocaleString("es-AR", {
                        minimumFractionDigits: 0,
                        maximumFractionDigits: 0,
                      })}
                    </span>
                  </div>
                )}
              </div>

              {/* View button */}
              <div className="mt-4 pt-3 border-t border-gray-100">
                <span className="text-sm text-blue-600 font-medium group-hover:text-blue-700 flex items-center gap-1">
                  Ver Producto
                  <svg
                    className="w-4 h-4 group-hover:translate-x-1 transition-transform"
                    fill="none"
                    strokeLinecap="round"
                    strokeLinejoin="round"
                    strokeWidth="2"
                    viewBox="0 0 24 24"
                    stroke="currentColor"
                  >
                    <path d="M9 5l7 7-7 7"></path>
                  </svg>
                </span>
              </div>
            </Link>
          )
        })}
      </div>
    </div>
  )
}
