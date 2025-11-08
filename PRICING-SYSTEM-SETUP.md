# 📋 Guía de Configuración del Sistema de Pricing Multi-Canal

## 🎯 Resumen Ejecutivo

Este documento describe cómo configurar el sistema de precios para múltiples canales de venta:

- **MercadoLibre**: Precio promocional competitivo
- **Web Pública**: Precio de lista completo
- **Mayorista Contado**: Precio con bonificación + descuento contado
- **Mayorista Financiado**: Precio con bonificación solamente

---

## ✅ Estado Actual (Completado)

- ✅ Metadata agregada al producto CS200A con configuración de pricing
- ✅ Script de configuración generado (`scripts/setup-pricing-system.ts`)
- ✅ Cálculos de precios validados según PDF E-Gaucho Lista #1083

---

## 📊 Estructura de Precios CS200A

### Configuración Base (del PDF)
- **Precio Lista**: USD 26,411
- **Familia**: Generadores Cummins - Línea CS
- **IVA**: 10.5%
- **Bonificación**: 11%
- **Descuento Contado**: 9%
- **Moneda**: Dólar BNA (oficial)

### Precios Calculados por Canal

| Canal | Precio USD | Descuento | Descripción |
|-------|------------|-----------|-------------|
| **MercadoLibre** | $25,090 | 5% | Precio promocional para canal ML |
| **Público** | $26,411 | 0% | Precio lista completo |
| **Mayorista Contado** | $21,390 | 19% | Con bonif 11% + desc contado 9% |
| **Mayorista Financiado** | $23,506 | 11% | Solo bonificación 11% |

---

## 🔧 PASO 1: Configuración en Medusa Admin

### 1.1 Acceder al Admin

Abrir: **http://localhost:9000/app**

### 1.2 Crear Customer Groups

Ir a: **Settings → Customer Groups → Create Group**

Crear los siguientes 3 grupos:

#### Grupo 1: MercadoLibre
```
Name: MercadoLibre
Metadata:
{
  "description": "Clientes de MercadoLibre - Precio competitivo",
  "channel": "mercadolibre",
  "discount_type": "promotional"
}
```
**📝 Guardar el ID**: `cgrp_XXXXXXXX`

#### Grupo 2: Público General
```
Name: Público General
Metadata:
{
  "description": "Clientes de web pública - Precio lista",
  "channel": "web",
  "discount_type": "none"
}
```
**📝 Guardar el ID**: `cgrp_YYYYYYYY`

#### Grupo 3: Mayorista
```
Name: Mayorista
Metadata:
{
  "description": "Clientes mayoristas - Contacto directo",
  "channel": "direct",
  "discount_type": "wholesale"
}
```
**📝 Guardar el ID**: `cgrp_ZZZZZZZZ`

---

## 💰 PASO 2: Crear Price Lists

### 2.1 Acceder a Price Lists

Ir a: **Settings → Pricing → Price Lists → Create Price List**

### 2.2 Crear Price List para MercadoLibre

```
Title: Precios MercadoLibre - CS200A
Description: Precios competitivos para canal MercadoLibre
Type: Override
Status: Active

Prices:
  - Variant: CS200A (variant_9173cb95160e3448)
  - Amount: 2,509,000 cents (USD 25,090.00)
  - Currency: USD
  - Min Quantity: 1
  - Max Quantity: (dejar vacío)

Rules:
  - Customer Group: [Seleccionar "MercadoLibre"]
```

### 2.3 Crear Price List para Público

```
Title: Precios Público - CS200A
Description: Precio lista para público general
Type: Override
Status: Active

Prices:
  - Variant: CS200A (variant_9173cb95160e3448)
  - Amount: 2,641,100 cents (USD 26,411.00)
  - Currency: USD
  - Min Quantity: 1
  - Max Quantity: (dejar vacío)

Rules:
  - Customer Group: [Seleccionar "Público General"]
```

### 2.4 Crear Price List para Mayorista Contado

```
Title: Precios Mayorista Contado - CS200A
Description: Precio mayorista con pago contado
Type: Override
Status: Active

Prices:
  - Variant: CS200A (variant_9173cb95160e3448)
  - Amount: 2,139,000 cents (USD 21,390.00)
  - Currency: USD
  - Min Quantity: 1
  - Max Quantity: (dejar vacío)

Rules:
  - Customer Group: [Seleccionar "Mayorista"]
  - (Si soporta) Payment Method: cash
```

### 2.5 Crear Price List para Mayorista Financiado

```
Title: Precios Mayorista Financiado - CS200A
Description: Precio mayorista financiado
Type: Override
Status: Active

Prices:
  - Variant: CS200A (variant_9173cb95160e3448)
  - Amount: 2,350,600 cents (USD 23,506.00)
  - Currency: USD
  - Min Quantity: 1
  - Max Quantity: (dejar vacío)

Rules:
  - Customer Group: [Seleccionar "Mayorista"]
  - (Si soporta) Payment Method: financed
```

---

## 🧪 PASO 3: Verificación

### 3.1 Verificar Product Metadata

```bash
psql postgresql://ivankorzyniewski@localhost:5432/medusa-store -c "
SELECT id, title, metadata->>'pricing_config'
FROM product
WHERE id = 'prod_cs200a_73150acc-b0b6-413b-8f55-2497142ba4f0';
"
```

**Debe mostrar**:
```json
{
  "precio_lista_usd": 26411,
  "currency_type": "usd_bna",
  "iva_percentage": 10.5,
  "bonificacion_percentage": 11,
  "contado_descuento_percentage": 9,
  "familia": "Generadores Cummins - Línea CS",
  "precios_calculados": {
    "mercadolibre_usd": 25090,
    "publico_usd": 26411,
    "mayorista_contado_usd": 21390,
    "mayorista_financiado_usd": 23506
  }
}
```

### 3.2 Probar Pricing desde Storefront

```bash
# Sin customer group (público)
curl "http://localhost:9000/store/products/prod_cs200a_73150acc-b0b6-413b-8f55-2497142ba4f0?fields=*variants.calculated_price"

# Con customer group mayorista
curl "http://localhost:9000/store/products/prod_cs200a_73150acc-b0b6-413b-8f55-2497142ba4f0?fields=*variants.calculated_price" \
  -H "x-customer-group: cgrp_ZZZZZZZZ"
```

---

## 📱 PASO 4: Integración con Frontend

### 4.1 Leer Metadata del Producto

El frontend ya tiene acceso a metadata cuando hace fetch del producto:

```typescript
const product = await medusa.store.product.retrieve(productId, {
  fields: "*metadata,*variants.calculated_price"
})

const pricingConfig = product.metadata?.pricing_config
```

### 4.2 Calcular ARS Dinámicamente

El sistema actual usa `/api/calculate-price` que ya funciona. Solo necesita:

```typescript
// Obtener precio USD correcto según customer group
const precioUSD = variant.calculated_price.calculated_amount / 100

// Llamar a API existente
const response = await fetch(
  `/api/calculate-price?precio_usd=${precioUSD}&tipo_cambio=oficial&incluir_iva=true`
)
```

---

## 🔄 PASO 5: Próximos Pasos de Desarrollo

### 5.1 Actualizar `calculate-price` API

Agregar soporte para calcular múltiples precios en una sola llamada:

```typescript
GET /api/calculate-price?
  precio_lista_usd=26411
  &bonificacion=11
  &contado_descuento=9
  &tipo_cambio=oficial
  &incluir_iva=true
  &calcular_todos=true  // NUEVO: devuelve los 4 precios
```

### 5.2 Actualizar `PriceDisplay` Component

Mostrar precio según contexto del usuario:

```tsx
{/* Si es público anónimo */}
<div>
  <span>Precio Público: ARS ${precioPublicoARS}</span>
  <span>Precio Mayorista: Contactar</span>
</div>

{/* Si es cliente mayorista logueado */}
<div>
  <span>Precio Contado: ARS ${precioContadoARS}</span>
  <span>Precio Financiado: ARS ${precioFinanciadoARS}</span>
</div>
```

### 5.3 Sistema de Auth para Mayoristas

Implementar login/registro de mayoristas:

```
1. Form de registro mayorista
2. Validación (CUIT, documentación)
3. Asignación al customer group "Mayorista"
4. Login con credenciales
5. Ver precios privados
```

---

## 📦 PASO 6: Replicar para Otros Productos

### Template para Nuevos Productos

1. **Agregar producto en Medusa Admin**
2. **Agregar metadata**:
```json
{
  "pricing_config": {
    "precio_lista_usd": XXXX,
    "currency_type": "usd_bna" | "usd_blue",
    "iva_percentage": 10.5 | 21,
    "bonificacion_percentage": XX,
    "contado_descuento_percentage": XX,
    "familia": "NOMBRE_FAMILIA"
  }
}
```

3. **Crear 4 Price Lists** (o usar las existentes si son generales)
4. **Verificar en frontend**

---

## 🔗 Recursos

- **Medusa Admin**: http://localhost:9000/app
- **API Docs**: https://docs.medusajs.com/resources/commerce-modules/pricing
- **Customer Groups**: https://docs.medusajs.com/resources/commerce-modules/customer/customer-groups
- **Price Lists**: https://docs.medusajs.com/resources/commerce-modules/pricing/price-lists

---

## ⚠️ Notas Importantes

1. **Customer Groups vs Payment Method**: Medusa no soporta nativamente "payment_method" en price rules. Para diferenciar contado vs financiado, necesitarás:
   - Opción A: Crear 2 customer groups ("Mayorista Contado" y "Mayorista Financiado")
   - Opción B: Usar metadata + lógica custom en el storefront

2. **Conversión USD→ARS**: Se hace en tiempo real en el frontend, NO en Medusa. Medusa siempre almacena USD.

3. **IVA**: Se calcula en el frontend con la API `/api/calculate-price`. Medusa no tiene IVA argentino configurado.

4. **Sincronización Multi-Canal**:
   - MercadoLibre: Consulta Medusa API con `customer_group=mercadolibre`
   - Redes Sociales: Consulta Medusa API con `customer_group=publico`
   - Clientes Directos: Login → customer_group automático

---

## 🐛 Troubleshooting

### calculated_price es null
```bash
# Verificar que price_rule existe
psql -c "SELECT * FROM price_rule WHERE price_id IN (
  SELECT id FROM price WHERE variant_id = 'variant_9173cb95160e3448'
);"
```

### Cliente no ve precio correcto
```bash
# Verificar customer group del cliente
psql -c "SELECT c.email, cg.name
FROM customer c
JOIN customer_group_customer cgc ON c.id = cgc.customer_id
JOIN customer_group cg ON cgc.customer_group_id = cg.id
WHERE c.email = 'email@example.com';"
```

---

**Última actualización**: 2025-11-07
**Versión Medusa**: v2.11.3
**Estado**: Metadata configurada, Price Lists pendientes de creación manual
