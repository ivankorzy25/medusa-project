# Estructura de Metadata para Precios Dinámicos

Este documento describe todos los campos de metadata disponibles para configurar precios dinámicos en productos.

## Campos de Metadata Disponibles

### 1. Configuración de Precios Base (`pricing_config`)

```json
{
  "precio_lista_usd": 26411,
  "currency_type": "usd_blue",
  "iva_percentage": 10.5,
  "bonificacion_percentage": 11,
  "contado_descuento_percentage": 9,
  "familia": "Generadores Diesel"
}
```

**Descripción de campos:**
- `precio_lista_usd`: Precio base en USD antes de impuestos
- `currency_type`: Tipo de cambio a usar (`"usd_oficial"` o `"usd_blue"`)
- `iva_percentage`: Porcentaje de IVA a aplicar (ej: 10.5, 21)
- `bonificacion_percentage`: Bonificación sobre precio lista (opcional)
- `contado_descuento_percentage`: Descuento adicional por pago contado (opcional)
- `familia`: Categoría del producto para agrupación

### 2. Sistema de Descuentos

```json
{
  "descuento_porcentaje": 42,
  "precio_anterior": 75000000
}
```

**Descripción de campos:**
- `descuento_porcentaje`: Porcentaje de descuento a mostrar (ej: 42 para "42% OFF")
- `precio_anterior`: Precio anterior en ARS (opcional, se calcula automáticamente si no se provee)

**Comportamiento:**
- Si `descuento_porcentaje` > 0 → Muestra badge "OFERTA DEL DÍA"
- Si `descuento_porcentaje` > 0 → Muestra precio anterior tachado
- Si `precio_anterior` no existe → Calcula: `precioActual / (1 - descuento/100)`

### 3. Sistema de Ventas y Rankings

```json
{
  "total_ventas": 247,
  "es_mas_vendido": true,
  "categoria": "Generadores Diesel"
}
```

**Descripción de campos:**
- `total_ventas`: Número total de unidades vendidas
- `es_mas_vendido`: Flag para marcar como más vendido de su categoría
- `categoria`: Categoría para comparar rankings (debe coincidir con `familia`)

**Comportamiento:**
- Si `es_mas_vendido` = true → Muestra badge "MÁS VENDIDO"
- Si `total_ventas` > 0 → Muestra "+247 vendidos" en subtítulo
- Script automático disponible: `scripts/auto-rank-bestsellers.sql`

### 4. Sistema de Financiación ✨ NUEVO

```json
{
  "financiacion_disponible": true,
  "planes_financiacion": [
    {"cuotas": 3, "interes": 0.08, "costoPorCuota": 14740000},
    {"cuotas": 6, "interes": 0.08, "costoPorCuota": 7570000},
    {"cuotas": 12, "interes": 0.12, "costoPorCuota": 4180000}
  ]
}
```

**Descripción de campos:**
- `financiacion_disponible`: Flag para habilitar financiación (boolean)
- `planes_financiacion`: Array de objetos con planes disponibles
  - `cuotas`: Número de cuotas (int)
  - `interes`: Tasa de interés decimal (0.08 = 8%)
  - `costoPorCuota`: Costo de cada cuota en ARS (int)

**Comportamiento:**
- Solo muestra si `financiacion_disponible` = true
- Solo muestra planes con `interes` ≤ 0.15 (15%)
- Muestra el primer plan disponible por defecto
- Formato: "Mismo precio en 3 cuotas de $ 14.740.000"

**Validaciones:**
- Interés máximo permitido: 15%
- Costo por cuota debe ser número entero
- Cuotas debe ser número entero positivo

## Lógica de Renderizado (en orden)

El componente `PriceDisplay` renderiza los elementos en este orden:

1. **Precio anterior** (condicional)
   - Solo si `descuento_porcentaje` > 0
   - Formato: $ 75.000.000 (tachado)

2. **Precio principal** (siempre)
   - Formato: $ 42.171.104 (36px, negrita)
   - Calcula: precio_lista_usd × tipo_cambio × (1 + IVA)

3. **Badge descuento** (condicional)
   - Solo si `descuento_porcentaje` > 0
   - Formato: "42% OFF" (verde)

4. **Línea de financiación** (condicional)
   - Solo si `financiacion_disponible` = true
   - Solo si primer plan tiene `interes` ≤ 15%
   - Formato: "Mismo precio en 3 cuotas de $ 14.740.000"

5. **Precio en USD** (siempre)
   - Formato: "USD 26.411,50 + IVA 10.5%"

## Formatos de Números

### Precios en ARS (Pesos Argentinos)
- **Formato**: $ 42.171.104
- **Separador de miles**: Punto (.)
- **Decimales**: No se muestran
- **Función**: `formatARS()`

### Precios en USD (Dólares)
- **Formato**: USD 26.411,50
- **Separador de miles**: Punto (.)
- **Separador decimal**: Coma (,)
- **Decimales**: Siempre 2 dígitos
- **Función**: `formatUSD()`

## Scripts SQL Disponibles

### Descuentos
- `scripts/add-discount-metadata.sql` - Agregar descuento a producto
- `scripts/clear-discount-metadata.sql` - Quitar descuento

### Ventas y Rankings
- `scripts/update-sales-metadata.sql` - Actualizar ventas manualmente
- `scripts/clear-sales-metadata.sql` - Limpiar datos de ventas
- `scripts/auto-rank-bestsellers.sql` - Ranking automático por categoría

### Financiación ✨ NUEVO
- `scripts/add-financiacion-metadata.sql` - Agregar planes de financiación
- `scripts/clear-financiacion-metadata.sql` - Quitar financiación

## Ejemplo Completo de Metadata

```json
{
  "pricing_config": {
    "precio_lista_usd": 26411,
    "currency_type": "usd_blue",
    "iva_percentage": 10.5,
    "bonificacion_percentage": 11,
    "contado_descuento_percentage": 9,
    "familia": "Generadores Diesel"
  },
  "descuento_porcentaje": 42,
  "precio_anterior": 75000000,
  "total_ventas": 247,
  "es_mas_vendido": true,
  "categoria": "Generadores Diesel",
  "financiacion_disponible": true,
  "planes_financiacion": [
    {"cuotas": 3, "interes": 0.08, "costoPorCuota": 14740000},
    {"cuotas": 6, "interes": 0.08, "costoPorCuota": 7570000},
    {"cuotas": 12, "interes": 0.12, "costoPorCuota": 4180000}
  ]
}
```

## Vista Resultante en Frontend

Con todos los campos configurados, el usuario verá:

```
🏆 MÁS VENDIDO  🔵 OFERTA DEL DÍA

Generador Diesel Cummins CS200A
Nuevo | +247 vendidos
⭐⭐⭐⭐⭐ (247)

$ 75.000.000  (tachado)
$ 42.171.104  42% OFF

Mismo precio en 3 cuotas de $ 14.740.000
USD 26.411,50 + IVA 10.5%

[Comprar ahora]
[Agregar al carrito]
```

## Próximos Pasos

1. Reiniciar Medusa backend después de cambios en metadata
2. Recargar página del producto
3. Verificar que todos los elementos se rendericen correctamente
4. Usar scripts SQL para gestión masiva de productos
