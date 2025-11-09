# Guía de Implementación: Sistema de Variantes Híbrido

Implementación completada el 2025-11-09

---

## Resumen del Sistema

Se ha implementado un **sistema híbrido de variantes** basado en la arquitectura definida en `ARQUITECTURA-PRODUCTOS-DEFINITIVA.md`. Este sistema combina:

1. **Variantes Nativas de Medusa** - Para configuraciones del mismo producto (Ej: CS200 Abierto vs CS200 Silent)
2. **Accesorios Compatibles** - Productos independientes mostrados como opciones (Ej: TTAs, servicios)
3. **Productos Relacionados** - Versiones alternativas del producto (Ej: CS170, CS200, CS275)

---

## Componentes Creados

### 1. VariantSelector Component
**Archivo:** `src/components/products/VariantSelector.tsx`

Muestra las variantes del producto con estilo MercadoLibre:
- Selector visual de variantes (tarjetas clicables)
- Muestra precio, peso, nivel de ruido, y otras especificaciones
- Indicador visual de variante seleccionada
- Solo se muestra si el producto tiene 2+ variantes

**Props:**
```typescript
interface VariantSelectorProps {
  variants: VariantOption[]
  currentVariantId?: string
  onVariantChange?: (variantId: string) => void
  productHandle: string
}
```

**Uso:**
```tsx
<VariantSelector
  variants={product.variants}
  productHandle="cummins-cs200"
/>
```

### 2. CompatibleAccessories Component
**Archivo:** `src/components/products/CompatibleAccessories.tsx`

Muestra accesorios y servicios compatibles con el producto:
- Agrupa accesorios por tipo (TTA, Servicio, etc.)
- Muestra precio adicional
- Botón para ver detalles o agregar al carrito
- Banner informativo sobre cómo agregar accesorios

**Props:**
```typescript
interface CompatibleAccessoriesProps {
  accessories: CompatibleAccessory[]
  onAddAccessory?: (handle: string) => void
}
```

**Uso:**
```tsx
<CompatibleAccessories
  accessories={metadata.accesorios_compatibles}
/>
```

### 3. RelatedProducts Component
**Archivo:** `src/components/products/RelatedProducts.tsx`

Muestra productos relacionados (versiones alternativas):
- Badges de tipo (Mayor Potencia, Más Económico, etc.)
- Links a páginas de productos relacionados
- Muestra potencia y precio estimado
- Animaciones hover

**Props:**
```typescript
interface RelatedProductsProps {
  products: RelatedProduct[]
  currentProductHandle?: string
}
```

**Uso:**
```tsx
<RelatedProducts
  products={metadata.productos_relacionados}
  currentProductHandle="cummins-cs200"
/>
```

### 4. Utility Functions
**Archivo:** `src/lib/variant-utils.ts`

Funciones auxiliares para manejo de variantes:
- `enrichVariantWithPrice()` - Agrega datos de precio a una variante
- `enrichVariantsWithPrices()` - Enriquece array de variantes
- `getVariantConfiguration()` - Extrae configuración de variante
- `hasVariants()` - Verifica si hay variantes significativas

---

## Integración en ProductInfoTabs

**Archivo:** `src/components/products/ProductInfoTabs.tsx`

Se actualizó la pestaña "Variantes" para mostrar:

1. **VariantSelector** - Si hay 2+ variantes
2. **CompatibleAccessories** - Si `metadata.accesorios_compatibles` existe
3. **RelatedProducts** - Si `metadata.productos_relacionados` existe
4. **Services** - Si `metadata.servicios_disponibles` existe

**Props Actualizados:**
```typescript
interface ProductInfoTabsProps {
  description?: string
  metadata?: Record<string, any>
  variants?: Array<{
    id: string
    title: string
    sku: string
    price?: {
      priceWithoutTax: number
      priceWithTax: number
      currency: string
    }
    metadata?: Record<string, any>
    weight?: number
    length?: number
    width?: number
    height?: number
  }>
  productHandle?: string
  weight?: number | null
  length?: number | null
  width?: number | null
  height?: number | null
}
```

---

## Integración en Product Page

**Archivo:** `src/app/producto/[handle]/page.tsx`

Se actualizó `getProductByHandle()` para:

1. **Enriquecer variantes con precios:**
```typescript
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
```

2. **Pasar `productHandle` a ProductInfoTabs:**
```tsx
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
```

---

## Estructura de Metadata Requerida

Para que el sistema funcione correctamente, los productos deben tener esta estructura en metadata:

### Producto Base (Ej: Cummins CS200)

```json
{
  "motor_marca": "Cummins",
  "motor_modelo": "6CTAA8.3-G",
  "potencia_standby_kva": 200,
  "potencia_prime_kva": 180,

  "productos_relacionados": [
    {
      "type": "version_mayor",
      "handle": "cummins-cs275",
      "descripcion": "Versión más potente - 275 KVA",
      "potencia_kva": 275,
      "precio_usd": 32720
    },
    {
      "type": "version_menor",
      "handle": "cummins-cs170",
      "descripcion": "Versión más económica - 170 KVA",
      "potencia_kva": 170,
      "precio_usd": 22842
    }
  ],

  "accesorios_compatibles": [
    {
      "type": "tta",
      "handle": "tta-psy200-icsa",
      "nombre": "TTA 200 KVA - ICSA",
      "precio_usd": 3322,
      "descripcion": "Transferencia Automática ICSA"
    },
    {
      "type": "tta",
      "handle": "tta-psy200-abb",
      "nombre": "TTA 200 KVA - ABB",
      "precio_usd": 9523,
      "descripcion": "Transferencia Automática ABB (Premium)"
    }
  ],

  "servicios_disponibles": [
    {
      "type": "puesta_marcha",
      "codigo": "PMCS200",
      "nombre": "Puesta en marcha con fluidos",
      "precio_usd": 156,
      "descripcion": "Aceite, refrigerante y prueba con carga 1hr"
    }
  ]
}
```

### Variantes (Ej: CS200A y CS200S)

Cada variante debe tener metadata que indique sus características:

**CS200A (Abierto):**
```json
{
  "tiene_cabina": false,
  "nivel_ruido_db": 85,
  "tipo_producto": "abierto"
}
```

**CS200S (Silent):**
```json
{
  "tiene_cabina": true,
  "nivel_ruido_db": 55,
  "tipo_producto": "silent",
  "peso_cabina_kg": 600
}
```

---

## Tipos de Relaciones Soportadas

### Related Products (`productos_relacionados`)

- `version_alternativa` - Producto alternativo similar
- `version_mayor` - Mayor potencia/capacidad
- `version_menor` - Menor potencia (más económico)
- `version_similar` - Similar en características

### Accessories (`accesorios_compatibles`)

- `tta` - Transferencia Automática
- `accesorio` - Accesorios generales
- `servicio` - Servicios (también puede ir en `servicios_disponibles`)
- Cualquier otro tipo personalizado

---

## Cómo Crear un Producto con Variantes

### Paso 1: Crear Producto Base en Medusa Admin

1. Ir a Medusa Admin → Products → Create Product
2. Crear producto base: "Cummins CS200 - 200 KVA"
3. Handle: `cummins-cs200`

### Paso 2: Agregar Opciones

1. En el producto, agregar Option: "Configuración"
2. Valores: "Abierto", "Silent (Insonorizado)"

### Paso 3: Crear Variantes

**Variante 1: CS200A**
- Title: "CS200 Abierto"
- SKU: "GEN-CS200A"
- Precio: 26411 USD (en centavos: 2641100)
- Weight: 1900000 gramos (1900 kg)
- Metadata:
  ```json
  {
    "tiene_cabina": false,
    "nivel_ruido_db": 85,
    "tipo_producto": "abierto"
  }
  ```

**Variante 2: CS200S**
- Title: "CS200 Silent"
- SKU: "GEN-CS200S"
- Precio: 28707 USD (en centavos: 2870700)
- Weight: 2500000 gramos (2500 kg)
- Metadata:
  ```json
  {
    "tiene_cabina": true,
    "nivel_ruido_db": 55,
    "tipo_producto": "silent",
    "peso_cabina_kg": 600
  }
  ```

### Paso 4: Agregar Metadata del Producto

En el producto base, agregar metadata con productos relacionados, accesorios y servicios según la estructura mostrada arriba.

---

## Testing

### Verificar que Funciona

1. Ir a `http://localhost:3000/producto/cummins-cs200s`
2. Click en pestaña "Variantes"
3. Verificar que se muestra:
   - ✅ Selector de variantes (CS200A vs CS200S)
   - ✅ Precios de cada variante
   - ✅ Especificaciones (peso, ruido, cabina)
   - ✅ Accesorios compatibles (TTAs)
   - ✅ Productos relacionados (CS170, CS275)
   - ✅ Servicios disponibles (Puesta en marcha)

### Casos de Uso a Probar

1. **Producto con 2 variantes:** CS200 (Abierto/Silent)
2. **Producto con 1 variante:** Debe ocultar selector
3. **Producto sin accesorios:** No debe mostrar sección de accesorios
4. **Producto sin relacionados:** No debe mostrar sección de relacionados

---

## Próximos Pasos Sugeridos

1. ✅ Crear productos CS200A y CS200S en Medusa con estructura definida
2. ✅ Crear productos accesorios (TTA-PSY200-ICSA, TTA-PSY200-ABB)
3. ✅ Crear productos servicios (PMCS200, PMCS275, PMCS375)
4. ⏳ Agregar metadata de relaciones en productos existentes
5. ⏳ Implementar funcionalidad "Agregar Accesorio" al carrito
6. ⏳ Crear bundle products con descuentos especiales
7. ⏳ Migrar todos los productos del catálogo PDF a esta estructura

---

## Troubleshooting

### Problema: Variantes no se muestran
**Solución:** Verificar que:
- El producto tiene 2+ variantes
- Las variantes tienen metadata con configuración diferente
- `product.variants` se pasa correctamente a ProductInfoTabs

### Problema: Precios no aparecen
**Solución:** Verificar que:
- Las variantes tienen price sets configurados en Medusa
- La región (Argentina/ARS o Europa/EUR) está correctamente configurada
- La API de precios está funcionando (`/api/product-prices/[variantId]`)

### Problema: Accesorios no se muestran
**Solución:** Verificar que:
- `metadata.accesorios_compatibles` existe y es un array
- Cada accesorio tiene los campos requeridos (type, handle, nombre, precio_usd, descripcion)

---

## Archivos Modificados

1. ✅ `src/components/products/VariantSelector.tsx` - Creado
2. ✅ `src/components/products/CompatibleAccessories.tsx` - Creado
3. ✅ `src/components/products/RelatedProducts.tsx` - Creado
4. ✅ `src/lib/variant-utils.ts` - Creado
5. ✅ `src/components/products/ProductInfoTabs.tsx` - Actualizado
6. ✅ `src/app/producto/[handle]/page.tsx` - Actualizado

---

## Referencias

- [ARQUITECTURA-PRODUCTOS-DEFINITIVA.md](./ARQUITECTURA-PRODUCTOS-DEFINITIVA.md) - Arquitectura completa del sistema
- [Lista de Precios Mayorista E-Gaucho 1083](./Lista%20de%20Precios%20Mayorista%20E-Gaucho%201083%20-%20Dolarizada.pdf) - Catálogo fuente
