# 🇦🇷 CONFIGURACIÓN REGIONAL ARGENTINA - COMPLETA

**Fecha:** 2025-11-08
**Estado:** ✅ COMPLETADO Y VERIFICADO
**Versión:** 1.0

---

## 📋 RESUMEN EJECUTIVO

Se ha configurado completamente la región Argentina en Medusa con:

- ✅ **Moneda**: ARS (Peso Argentino)
- ✅ **IVA 10.5%** (Bienes de Capital) - Por defecto
- ✅ **IVA 21%** (General)
- ✅ **Sistema de conversión USD → ARS** con 7 tipos de dólar
- ✅ **Frontend 100% dinámico** adaptable a cualquier producto

---

## 🏗️ CONFIGURACIÓN REALIZADA EN MEDUSA

### 1. Región Argentina

```sql
ID: reg_01JCARGENTINA2025
Nombre: Argentina
Moneda: ars
Impuestos Automáticos: Sí
País Asignado: Argentina (iso_2: 'ar')
```

### 2. Tax Region

```sql
ID: txreg_01JCARGENTINA2025
Provider: tp_system
Country Code: ar
```

### 3. Tax Rates (IVA)

#### IVA 10.5% - Bienes de Capital (DEFAULT)

```sql
ID: txrate_01JCAR_IVA_10_5
Tasa: 10.5%
Código: IVA_AR_10_5
Nombre: IVA Argentina 10.5% - Bienes de Capital
Default: SÍ
```

**Aplica a:**
- Generadores eléctricos industriales
- Grupos electrógenos de uso productivo
- Maquinaria industrial
- Equipos de construcción

#### IVA 21% - General

```sql
ID: txrate_01JCAR_IVA_21
Tasa: 21.0%
Código: IVA_AR_21
Nombre: IVA Argentina 21% - General
Default: NO
```

**Aplica a:**
- Generadores portátiles domésticos
- Hidrolavadoras uso general
- Compresores de aire domésticos
- Productos de consumo general

---

## 💱 SISTEMA DE CONVERSIÓN USD → ARS

### API de Cotizaciones

**Endpoint:** `/api/exchange-rates`
**Fuente:** DolarAPI.com (API pública argentina)
**Actualización:** Cada 5 minutos

### Tipos de Dólar Soportados

| Tipo | Descripción | Uso Recomendado |
|------|-------------|-----------------|
| **oficial** | Dólar BNA (Oficial) | Operaciones bancarias, exportación |
| **blue** | Dólar Blue (Billete) | Mercado informal, efectivo |
| **mep** | Dólar MEP (Bolsa) | Inversiones bursátiles |
| **ccl** | Dólar CCL (Cable) | Transferencias internacionales |
| **mayorista** | Dólar Mayorista | Comercio exterior |
| **cripto** | Dólar Cripto | Criptomonedas |
| **tarjeta** | Dólar Tarjeta | Compras internacionales |

### Cotizaciones Actuales (Verificado 2025-11-08)

```
oficial: Compra 1395 - Venta 1445
blue:    Compra 1395 - Venta 1415
mep:     Compra 1449.9 - Venta 1458
ccl:     Compra 1471 - Venta 1474.6
mayorista: Compra 1406 - Venta 1415
cripto:  Compra 1514 - Venta 1520
tarjeta: Compra 1813.5 - Venta 1878.5
```

---

## 🔄 CÓMO FUNCIONA LA CONVERSIÓN POR PRODUCTO

### Producto con Dólar BLUE

```json
{
  "precio_lista_usd": 26411,
  "currency_type": "usd_blue",
  "iva_percentage": 10.5
}
```

**Cálculo Verificado:**
```
USD 26,411 × Blue Venta (1,415) = AR$ 37,371,565 (sin IVA)
IVA 10.5% = AR$ 3,924,014
TOTAL = AR$ 41,295,579
```

### Producto con Dólar OFICIAL

```json
{
  "precio_lista_usd": 26411,
  "currency_type": "usd_oficial",
  "iva_percentage": 10.5
}
```

**Cálculo Verificado:**
```
USD 26,411 × Oficial Venta (1,445) = AR$ 38,163,895 (sin IVA)
IVA 10.5% = AR$ 4,007,209
TOTAL = AR$ 42,171,104
```

### Producto con IVA 21%

```json
{
  "precio_lista_usd": 5000,
  "currency_type": "usd_blue",
  "iva_percentage": 21
}
```

**Cálculo Verificado:**
```
USD 5,000 × Blue Venta (1,415) = AR$ 7,075,000 (sin IVA)
IVA 21% = AR$ 1,485,750
TOTAL = AR$ 8,560,750
```

---

## ⚙️ CONFIGURACIÓN DEL FRONTEND

### Archivo: `src/lib/medusa-client.ts`

```typescript
// Region IDs
export const REGIONS = {
  EUROPE: "reg_01K9FZ96V1AT4PGR95NE8VYZ8N",      // EUR - Europe
  ARGENTINA: "reg_01JCARGENTINA2025",            // ARS - Argentina
} as const

// Default region ID - Argentina (ARS)
// Cambiar a REGIONS.EUROPE si necesitás usar EUR
const DEFAULT_REGION_ID = REGIONS.ARGENTINA
```

**Para cambiar de región:**
```typescript
// Usar EUR (Europa)
const DEFAULT_REGION_ID = REGIONS.EUROPE

// Usar ARS (Argentina) - Actual
const DEFAULT_REGION_ID = REGIONS.ARGENTINA
```

---

## 📦 CÓMO CARGAR PRODUCTOS

### Ejemplo 1: Generador Industrial (Dólar Blue + IVA 10.5%)

```json
{
  "pricing_config": {
    "precio_lista_usd": 26411,
    "currency_type": "usd_blue",
    "iva_percentage": 10.5,
    "bonificacion_percentage": 0,
    "descuento_contado_percentage": 0,
    "familia": "Generadores Cummins - Línea CS"
  }
}
```

### Ejemplo 2: Hidrolavadora Doméstica (Dólar Oficial + IVA 21%)

```json
{
  "pricing_config": {
    "precio_lista_usd": 1200,
    "currency_type": "usd_oficial",
    "iva_percentage": 21,
    "bonificacion_percentage": 0,
    "descuento_contado_percentage": 0,
    "familia": "Hidrolavadoras Karcher - Línea K5"
  }
}
```

### Ejemplo 3: Compresor Industrial (Dólar Blue + IVA 10.5%)

```json
{
  "pricing_config": {
    "precio_lista_usd": 8500,
    "currency_type": "usd_blue",
    "iva_percentage": 10.5,
    "bonificacion_percentage": 5,
    "descuento_contado_percentage": 10,
    "familia": "Compresores Atlas Copco - Tornillo"
  }
}
```

---

## 🧪 PRUEBAS REALIZADAS

### ✅ Prueba 1: API de Cotizaciones
```bash
curl http://localhost:3000/api/exchange-rates
```
**Resultado:** 7 tipos de dólar actualizados correctamente

### ✅ Prueba 2: Cálculo con Dólar Blue + IVA 10.5%
```bash
curl "http://localhost:3000/api/calculate-price?precio_usd=26411&tipo_cambio=blue&incluir_iva=true&iva_porcentaje=10.5"
```
**Resultado:** AR$ 41,295,579 (correcto)

### ✅ Prueba 3: Cálculo con Dólar Oficial + IVA 10.5%
```bash
curl "http://localhost:3000/api/calculate-price?precio_usd=26411&tipo_cambio=oficial&incluir_iva=true&iva_porcentaje=10.5"
```
**Resultado:** AR$ 42,171,104 (correcto)

### ✅ Prueba 4: Cálculo con IVA 21%
```bash
curl "http://localhost:3000/api/calculate-price?precio_usd=5000&tipo_cambio=blue&incluir_iva=true&iva_porcentaje=21"
```
**Resultado:** AR$ 8,560,750 (correcto)

### ✅ Prueba 5: Frontend
```bash
curl http://localhost:3000
```
**Resultado:** ✅ HTML renderizado correctamente

---

## 📊 VERIFICACIÓN EN BASE DE DATOS

```sql
-- Ejecutar para verificar configuración completa
SELECT
  '=== REGIÓN ARGENTINA ===' as seccion,
  r.id,
  r.name as nombre,
  r.currency_code as moneda,
  r.automatic_taxes as impuestos_automaticos,
  COUNT(rc.iso_2) as paises_asignados
FROM region r
LEFT JOIN region_country rc ON r.id = rc.region_id
WHERE r.name = 'Argentina'
GROUP BY r.id, r.name, r.currency_code, r.automatic_taxes

UNION ALL

SELECT
  '=== TAX RATES IVA ===' as seccion,
  t.code as id,
  t.name as nombre,
  CONCAT(t.rate::text, '%') as moneda,
  t.is_default as impuestos_automaticos,
  NULL as paises_asignados
FROM tax_rate t
JOIN tax_region tr ON t.tax_region_id = tr.id
WHERE tr.country_code = 'ar'
ORDER BY seccion, nombre;
```

**Resultado Esperado:**
```
=== REGIÓN ARGENTINA === | reg_01JCARGENTINA2025 | Argentina | ars | t | 1
=== TAX RATES IVA ===    | IVA_AR_10_5          | IVA 10.5% | 10.5% | t
=== TAX RATES IVA ===    | IVA_AR_21            | IVA 21%   | 21%   | f
```

---

## 🚀 VENTAJAS DEL SISTEMA

### 1. **100% Dinámico**
- Cada producto puede tener su propio tipo de dólar
- IVA configurable por producto (10.5% o 21%)
- No hay valores hardcodeados

### 2. **Actualización Automática**
- Cotizaciones actualizadas cada 5 minutos
- No requiere intervención manual
- Fallback si la API falla

### 3. **Múltiples Categorías**
- Generadores → Dólar Blue + IVA 10.5%
- Compresores → Dólar Blue + IVA 10.5%
- Hidrolavadoras → Dólar Oficial + IVA 21%
- Cualquier producto futuro

### 4. **Transparencia**
- Usuario ve precio en ARS
- Se indica tipo de dólar usado
- Desglose de IVA visible

---

## 📁 ARCHIVOS IMPORTANTES

| Archivo | Descripción |
|---------|-------------|
| `/scripts/setup-region-argentina.sql` | Script completo de configuración |
| `/src/lib/medusa-client.ts` | Configuración de región default |
| `/src/app/api/exchange-rates/route.ts` | API de cotizaciones |
| `/src/app/api/calculate-price/route.ts` | API de cálculo de precios |
| `/src/components/products/PriceDisplay.tsx` | Componente de precios |
| `/plantillas/PLANTILLA_PRODUCTO_GENERADOR.json` | Template de producto |

---

## 🔧 MANTENIMIENTO

### Cambiar Tipo de Dólar por Defecto

Editar en metadata del producto:
```json
"currency_type": "usd_blue"    // Dólar Blue
"currency_type": "usd_oficial" // Dólar Oficial
```

### Cambiar IVA de un Producto

```json
"iva_percentage": 10.5  // Bienes de capital
"iva_percentage": 21    // General
```

### Actualizar Script de Configuración

Si necesitás recrear la región:
```bash
psql postgresql://ivankorzyniewski@localhost:5432/medusa-store -f scripts/setup-region-argentina.sql
```

---

## ❓ PREGUNTAS FRECUENTES

### ¿Puedo usar EUR en vez de ARS?

Sí, cambiar en `src/lib/medusa-client.ts`:
```typescript
const DEFAULT_REGION_ID = REGIONS.EUROPE
```

### ¿Cómo sé qué IVA usar?

- **10.5%**: Equipos industriales, bienes de capital
- **21%**: Productos de consumo general, uso doméstico

### ¿Qué pasa si la API de cotizaciones falla?

El sistema tiene un fallback con valores por defecto y continúa funcionando.

### ¿Puedo agregar más tipos de dólar?

Sí, modificando `src/app/api/exchange-rates/route.ts` y agregando el mapeo correspondiente.

---

## ✅ CHECKLIST DE VERIFICACIÓN

- [x] Región Argentina creada en Medusa
- [x] País Argentina asignado a región
- [x] Tax region configurada
- [x] IVA 10.5% creado (default)
- [x] IVA 21% creado
- [x] API de cotizaciones funcionando
- [x] API de cálculo de precios funcionando
- [x] Frontend renderizando correctamente
- [x] Pruebas con Dólar Blue exitosas
- [x] Pruebas con Dólar Oficial exitosas
- [x] Pruebas con IVA 21% exitosas
- [x] Documentación completa

---

## 📞 SOPORTE

Si necesitás ayuda con la configuración regional:

1. Verificar estado de Medusa: `curl http://localhost:9000/health`
2. Verificar cotizaciones: `curl http://localhost:3000/api/exchange-rates`
3. Revisar logs del backend: `cd medusa-backend && npm run dev`
4. Revisar configuración DB: Ejecutar queries de verificación arriba

---

**Configurado por:** Claude Code
**Fecha:** 2025-11-08
**Estado:** ✅ PRODUCCIÓN
