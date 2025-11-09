# 📊 Análisis: Sistema de Variantes para Generadores

**Fecha:** 2025-11-09
**Objetivo:** Implementar variantes de productos (con/sin cabina, con/sin TTA, etc.)

---

## 🔍 Estado Actual del Sistema

### Frontend (Storefront)

**Ubicación:** `src/app/producto/[handle]/page.tsx`

**Líneas 50-54** - Mapeo actual de variantes:
```typescript
variants: (product.variants || []).map((variant: any) => ({
  id: variant.id,
  title: variant.title || product.title,
  sku: variant.sku || "",
})),
```

**Problema:** Solo muestra `id`, `title` y `sku`. No incluye:
- ❌ Precio de la variante
- ❌ Opciones (color, cabina, TTA, etc.)
- ❌ Link a la variante
- ❌ Imagen de la variante
- ❌ Stock/disponibilidad
- ❌ Dimensiones específicas de la variante

### Display de Variantes

**Ubicación:** `src/components/products/ProductInfoTabs.tsx` (líneas 162-184)

Muestra variantes de forma muy básica:
- Solo título
- Solo SKU
- Sin interactividad (no redirige, no cambia producto)

---

## 🎯 Casos de Uso Reales

### Ejemplo 1: CS200S con/sin Cabina

**Producto base:** Cummins CS200S
**Variantes:**
1. CS200S Standard (sin cabina) - GEN-CS200S-STD
2. CS200S Silent (con cabina insonorizada) - GEN-CS200S-SIL

**Diferencias:**
- Precio: ~15-20% más caro con cabina
- Peso: +200-300 kg con cabina
- Dimensiones: Largo/ancho similares, alto +300mm
- Nivel de ruido: 85 dB vs 55 dB
- Metadata: `tiene_cabina: true/false`

### Ejemplo 2: Generador con/sin TTA

**Producto base:** Cualquier generador
**Variantes:**
1. Sin TTA automático
2. Con TTA automático incluido

**Diferencias:**
- Precio: +$2000-5000 USD
- Metadata: `tiene_tta: "no" | "incluido" | "opcional"`
- Panel de control diferente

### Ejemplo 3: Diferentes Combustibles

**Producto base:** Mismo motor, diferente combustible
**Variantes:**
1. Diesel
2. Gas Natural
3. Dual Fuel (Diesel + Gas)

**Diferencias:**
- Sistema de combustible completamente diferente
- Potencia puede variar 5-10%
- Precio varía según configuración

---

## 🏗️ Arquitectura de Medusa v2

### Productos con Opciones y Variantes

```javascript
// Estructura en Medusa v2
const product = {
  id: "prod_123",
  title: "Cummins CS200S",
  handle: "cummins-cs200s",
  
  // OPCIONES (características que varían)
  options: [
    {
      id: "opt_cabina",
      title: "Cabina",
      values: ["Sin Cabina", "Cabina Insonorizada"]
    },
    {
      id: "opt_tta",
      title: "TTA",
      values: ["No", "Incluido"]
    }
  ],
  
  // VARIANTES (combinaciones de opciones)
  variants: [
    {
      id: "var_001",
      title: "CS200S Standard",
      sku: "GEN-CS200S-STD",
      options: {
        "Cabina": "Sin Cabina",
        "TTA": "No"
      },
      prices: [...],
      inventory_quantity: 5,
      metadata: {
        tiene_cabina: false,
        tiene_tta: "no",
        nivel_ruido_db: 85
      }
    },
    {
      id: "var_002",
      title: "CS200S Silent con TTA",
      sku: "GEN-CS200S-SIL-TTA",
      options: {
        "Cabina": "Cabina Insonorizada",
        "TTA": "Incluido"
      },
      prices: [...],
      inventory_quantity: 2,
      metadata: {
        tiene_cabina: true,
        tiene_tta: "incluido",
        nivel_ruido_db: 55,
        peso_adicional_kg: 250
      }
    }
  ]
}
```

---

## 📝 Propuesta de Implementación

### Opción A: Sistema Completo de Variantes (RECOMENDADO)

**Ventajas:**
- ✅ Usa correctamente las variantes de Medusa
- ✅ Cada variante tiene su propio precio, stock, SKU
- ✅ Fácil de gestionar desde Medusa Admin
- ✅ Permite seleccionar variante y cambiar en tiempo real
- ✅ Funciona con cualquier tipo de variación

**Desventajas:**
- ⚠️ Requiere modificar frontend y backend
- ⚠️ Más complejo de configurar inicialmente

**Implementación:**

1. **Backend (Medusa Admin):**
   - Crear Product Options (Cabina, TTA, Combustible, etc.)
   - Crear Variants con valores específicos
   - Asignar precios, SKUs y metadata a cada variante

2. **Frontend (Storefront):**
   - Mejorar el fetch de variantes (incluir prices, options, metadata)
   - Crear selector de variantes interactivo
   - Al cambiar variante, actualizar: precio, specs, imágenes, SKU
   - Agregar botón "Ver esta variante" que redirige a URL específica

### Opción B: Links a Productos Relacionados (MÁS SIMPLE)

**Ventajas:**
- ✅ Más simple de implementar
- ✅ Cada producto es independiente
- ✅ Fácil de gestionar

**Desventajas:**
- ❌ No usa el sistema de variantes de Medusa
- ❌ Duplicación de datos
- ❌ Más difícil mantener sincronizado

**Implementación:**

1. **Metadata del producto:**
```json
{
  "productos_relacionados": [
    {
      "handle": "cummins-cs200a",
      "tipo_relacion": "sin_cabina",
      "descripcion": "Versión sin cabina insonorizada"
    },
    {
      "handle": "cummins-cs200s-v2",
      "tipo_relacion": "con_cabina",
      "descripcion": "Versión con cabina insonorizada"
    }
  ]
}
```

2. **Frontend:**
   - Leer `productos_relacionados` de metadata
   - Mostrar cards con links a esos productos
   - Mantener la tab "Variantes" pero cambiarle el nombre a "Versiones Disponibles"

---

## 🎨 Propuesta de UI/UX

### Diseño 1: Selector de Opciones (como MercadoLibre)

```
┌─────────────────────────────────────────────┐
│ Cummins CS200S - 200 KVA                   │
├─────────────────────────────────────────────┤
│                                             │
│ Cabina:                                     │
│ ┌───────────────┐  ┌───────────────────┐  │
│ │ Sin Cabina    │  │ Con Cabina ✓      │  │
│ │ $28,707       │  │ $33,500           │  │
│ └───────────────┘  └───────────────────┘  │
│                                             │
│ TTA Automático:                             │
│ ┌───────────────┐  ┌───────────────────┐  │
│ │ No ✓          │  │ Incluido          │  │
│ │               │  │ +$4,200           │  │
│ └───────────────┘  └───────────────────┘  │
│                                             │
│ Variante seleccionada:                      │
│ CS200S Silent - GEN-CS200S-SIL             │
│                                             │
│ Stock: 2 unidades disponibles              │
│                                             │
└─────────────────────────────────────────────┘
```

### Diseño 2: Cards de Variantes (más visual)

```
┌─────────────────────────────────────────────────────────┐
│ Variantes Disponibles                                   │
├─────────────────────────────────────────────────────────┤
│                                                         │
│ ┌──────────────┐  ┌──────────────┐  ┌──────────────┐ │
│ │ CS200S STD   │  │ CS200S Silent│  │ CS200S SIL+  │ │
│ │              │  │              │  │   TTA        │ │
│ │ 85 dB        │  │ 55 dB        │  │ 55 dB        │ │
│ │ $28,707      │  │ $33,500 ✓    │  │ $37,700      │ │
│ │              │  │              │  │              │ │
│ │ [Ver detalles]│  │ ACTUAL       │  │ [Seleccionar]│ │
│ └──────────────┘  └──────────────┘  └──────────────┘ │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## 💾 Estructura de Datos Propuesta

### En el Backend (Medusa)

```typescript
// Cuando se crea el producto en Medusa Admin
product: {
  title: "Cummins CS200S",
  handle: "cummins-cs200s",
  
  options: [
    { title: "Cabina", values: ["Sin Cabina", "Cabina Insonorizada"] },
    { title: "TTA", values: ["No", "Incluido", "Opcional"] }
  ],
  
  variants: [
    {
      title: "CS200S Standard",
      sku: "GEN-CS200S-STD",
      options: { Cabina: "Sin Cabina", TTA: "No" },
      prices: [{ amount: 2870700, currency_code: "usd" }],
      weight: 2200,
      length: 3800,
      width: 1500,
      height: 1800,
      metadata: {
        nivel_ruido_db: 85,
        tiene_cabina: false,
        tiene_tta: "no"
      }
    },
    {
      title: "CS200S Silent con TTA",
      sku: "GEN-CS200S-SIL-TTA",
      options: { Cabina: "Cabina Insonorizada", TTA: "Incluido" },
      prices: [{ amount: 3770000, currency_code: "usd" }],
      weight: 2450,
      length: 3800,
      width: 1500,
      height: 2100,
      metadata: {
        nivel_ruido_db: 55,
        tiene_cabina: true,
        tiene_tta: "incluido",
        peso_cabina_kg: 250
      }
    }
  ]
}
```

### En el Frontend (Storefront)

```typescript
interface VariantInfo {
  id: string
  title: string
  sku: string
  price: number
  currency: string
  options: Record<string, string>  // { "Cabina": "Sin Cabina", "TTA": "No" }
  stock: number
  isAvailable: boolean
  metadata: Record<string, any>
  dimensions: {
    weight: number
    length: number
    width: number
    height: number
  }
  image?: string
  url: string  // URL para navegar a esta variante específica
}
```

---

## 🚀 Pasos para Implementar

### Fase 1: Backend (Medusa Admin)

1. Crear Product Options para los productos existentes
2. Crear Variants con opciones específicas
3. Asignar precios, SKUs y metadata a cada variante
4. Configurar imágenes específicas por variante (opcional)

### Fase 2: Frontend - Fetch de Datos

1. Modificar `getProductByHandle` en `page.tsx` para incluir:
   - Product options
   - Todas las variantes con precios
   - Metadata de cada variante
   - Dimensiones de cada variante

2. Actualizar medusa-client.ts para hacer fetch completo de variantes

### Fase 3: Frontend - UI/UX

1. Crear componente `VariantSelector` 
2. Modificar tab "Variantes" en ProductInfoTabs
3. Agregar lógica para cambiar variante seleccionada
4. Actualizar precio, specs y dimensiones al cambiar variante

### Fase 4: Testing

1. Crear producto de prueba con 2-3 variantes
2. Verificar que precios se actualizan correctamente
3. Verificar que specs cambian según variante
4. Verificar que stock se muestra correctamente

---

## ❓ Preguntas para el Usuario

1. **¿Querés usar el sistema nativo de variantes de Medusa (Opción A) o links a productos relacionados (Opción B)?**
   - Recomiendo Opción A para aprovechar Medusa al máximo

2. **¿Qué opciones de variación son las más comunes en tus productos?**
   - Cabina (Sí/No)
   - TTA (No/Incluido/Opcional)
   - Combustible (Diesel/Gas/Dual)
   - ¿Otras?

3. **¿Querés que al seleccionar una variante se recargue la página o cambien los datos en tiempo real sin recargar?**

4. **¿Las variantes tienen imágenes diferentes?**
   - ej: foto con cabina vs sin cabina

5. **¿Necesitás mostrar stock en tiempo real para cada variante?**

---

## 📋 Conclusión

El sistema de variantes es esencial para tu negocio. La **Opción A (Sistema Completo)** es la más profesional y escalable, aunque requiere más trabajo inicial.

¿Querés que implemente la Opción A (sistema completo de variantes) o preferís algo más simple como la Opción B?
