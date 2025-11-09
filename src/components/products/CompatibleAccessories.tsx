"use client"

interface CompatibleAccessory {
  type: string
  handle: string
  nombre: string
  precio_usd: number
  descripcion: string
  sku?: string
}

interface CompatibleAccessoriesProps {
  accessories: CompatibleAccessory[]
  onAddAccessory?: (handle: string) => void
}

export default function CompatibleAccessories({
  accessories,
  onAddAccessory,
}: CompatibleAccessoriesProps) {
  if (!accessories || accessories.length === 0) {
    return null
  }

  // Group accessories by type
  const groupedAccessories = accessories.reduce((acc, accessory) => {
    const type = accessory.type || "otros"
    if (!acc[type]) {
      acc[type] = []
    }
    acc[type].push(accessory)
    return acc
  }, {} as Record<string, CompatibleAccessory[]>)

  const getTypeTitle = (type: string) => {
    const titles: Record<string, string> = {
      tta: "Transferencia Automática (TTA)",
      servicio: "Servicios Adicionales",
      accesorio: "Accesorios",
      otros: "Otros",
    }
    return titles[type] || type
  }

  const getTypeIcon = (type: string) => {
    const icons: Record<string, string> = {
      tta: "🔌",
      servicio: "🛠️",
      accesorio: "⚙️",
      otros: "📦",
    }
    return icons[type] || "📦"
  }

  return (
    <div className="compatible-accessories mt-8">
      <h3 className="text-xl font-bold mb-6 text-gray-900">
        Accesorios y Servicios Compatibles
      </h3>

      {Object.entries(groupedAccessories).map(([type, items]) => (
        <div key={type} className="mb-8">
          <h4 className="text-lg font-semibold mb-4 text-gray-800 flex items-center gap-2">
            <span>{getTypeIcon(type)}</span>
            <span>{getTypeTitle(type)}</span>
          </h4>

          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
            {items.map((accessory, index) => (
              <div
                key={`${accessory.handle}-${index}`}
                className="border border-gray-200 rounded-lg p-4 bg-white hover:shadow-md transition-shadow"
              >
                {/* Accessory header */}
                <div className="mb-3">
                  <h5 className="font-semibold text-base text-gray-900 mb-1">
                    {accessory.nombre}
                  </h5>
                  {accessory.sku && (
                    <p className="text-xs text-gray-500">SKU: {accessory.sku}</p>
                  )}
                </div>

                {/* Description */}
                <p className="text-sm text-gray-600 mb-4 line-clamp-2">
                  {accessory.descripcion}
                </p>

                {/* Price */}
                <div className="mb-4">
                  <p className="text-sm text-gray-600">Precio adicional:</p>
                  <p className="text-xl font-bold text-blue-600">
                    + USD ${accessory.precio_usd.toLocaleString("es-AR", {
                      minimumFractionDigits: 0,
                      maximumFractionDigits: 0,
                    })}
                  </p>
                </div>

                {/* Action button */}
                <button
                  onClick={() => {
                    if (onAddAccessory) {
                      onAddAccessory(accessory.handle)
                    } else {
                      // Navigate to accessory product page
                      window.location.href = `/producto/${accessory.handle}`
                    }
                  }}
                  className="w-full py-2 px-4 bg-blue-600 hover:bg-blue-700 text-white font-medium rounded-lg transition-colors text-sm"
                >
                  Ver Detalles
                </button>
              </div>
            ))}
          </div>
        </div>
      ))}

      {/* Info banner */}
      <div className="mt-6 p-4 bg-blue-50 border border-blue-200 rounded-lg">
        <p className="text-sm text-blue-800">
          <span className="font-semibold">💡 Recomendación:</span> Los accesorios
          y servicios se agregan por separado al carrito. Consultá con nuestro
          equipo de ventas para armar el paquete ideal según tus necesidades.
        </p>
      </div>
    </div>
  )
}
