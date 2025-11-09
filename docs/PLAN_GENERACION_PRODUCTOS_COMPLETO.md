# 📋 PLAN DE GENERACIÓN DE PRODUCTOS - PLANTILLA COMPLETA

**Versión**: 2.0  
**Fecha**: 2025-11-09  
**Basado en**: CS200A (producto de referencia validado)  
**Última actualización**: Después de crear CS200S-V2 completo

---

## 🎯 OBJETIVO

Crear productos en Medusa que se rendericen EXACTAMENTE como el PDF de referencia de CS200A, incluyendo:
- ✅ Todos los badges (RECIÉN LLEGADO, Nuevo, Combustible, TTA, dB, peso, dimensiones)
- ✅ Vendor info completa con rating y experiencia
- ✅ Trust signals (garantía oficial, envío gratis, stock disponible)
- ✅ Pricing correcto con financiación
- ✅ Imágenes de características principales
- ✅ "Lo que tenés que saber de este producto" con bullets completos

---

## 📊 ESTRUCTURA COMPLETA DEL PRODUCT.METADATA

### 1. PRICING CONFIG (OBLIGATORIO)
```json
"pricing_config": {
  "familia": "Generadores Cummins - Línea CS",
  "currency_type": "usd_blue",
  "iva_percentage": 10.5,
  "precio_lista_usd": 28707,
  "bonificacion_percentage": 11,
  "contado_descuento_percentage": 9
}
```

### 2. ESPECIFICACIONES BÁSICAS (OBLIGATORIAS)
```json
"fases": "Trifásico",
"voltaje": "220/380V",
"categoria": "Generadores Diesel",
"motor_rpm": 1500,
"frecuencia": "50/60Hz",
"motor_ciclo": "4 tiempos",
"motor_marca": "Cummins",
"motor_modelo": "6CTA83G2 TDI",
"combustible_tipo": "Diesel",
"factor_potencia": 0.8,
"motor_cilindros": 6,
"voltaje_salida": "220/380V",
"tipo_refrigeracion": "Agua",
"motor_refrigeracion": "Agua",
"tipo_arranque": "Eléctrico"
```

### 3. BADGES Y FLAGS (OBLIGATORIOS)
```json
"tiene_tta": "opcional",
"tiene_cabina": true,              // true para modelos Silent (S)
"es_recien_llegado": true,
"es_mas_vendido": false,
"badge_insonorizado": true,        // SOLO para modelos Silent
"badge_nuevo": true,
"estado_producto": "Nuevo"
```

### 4. RUIDO Y DIMENSIONES (OBLIGATORIOS PARA BADGES)
```json
"nivel_ruido_db": 71,              // Varía según modelo (68-75 dB)
"nivel_ruido_distancia_metros": 7,
"dimensiones_largo_cm": 323,       // Desde variant pero duplicado aquí
"dimensiones_ancho_cm": 117,
"dimensiones_alto_cm": 180,
"peso_seco_kg": 2450,
"peso_operativo_kg": 2880
```

### 5. POTENCIAS (OBLIGATORIAS)
```json
"potencia_standby_kva": 200,
"potencia_standby_kw": 160,
"potencia_prime_kva": 180,
"potencia_prime_kw": 144
```

### 6. ALTERNADOR Y PANEL (OBLIGATORIOS)
```json
"alternador_marca": "Stamford",
"alternador_modelo": "UCI274G1",
"alternador_excitacion": "Autoexcitado",
"panel_control_marca": "ComAp",
"panel_control_modelo": "InteliLite MRS16",
"panel_control_auto_start": true
```

### 7. MOTOR DETALLADO (OBLIGATORIOS)
```json
"motor_aspiracion": "Turbo Diesel Intercooled",
"motor_turboalimentado": true,
"motor_tipo_configuracion": "6 cilindros En línea",
"motor_cilindrada_litros": 8.3
```

### 8. COMBUSTIBLE Y AUTONOMÍA (OBLIGATORIOS)
```json
"capacidad_tanque_litros": 430,
"autonomia_75_carga_horas": 12.3,
"consumo_75_carga_lh": 35
```

### 9. INSONORIZACIÓN (SOLO MODELOS SILENT)
```json
"insonorizacion_tipo": "Silent Premium"  // SOLO si tiene_cabina = true
```

### 10. VENDOR INFO (OBLIGATORIO)
```json
"vendor_nombre": "KOR",
"vendor_rating": 5,
"vendor_anos_experiencia": 15,
"vendor_tiempo_respuesta": "Dentro de 24hs",
"vendor_descripcion": "Especialistas en generación de energía eléctrica y grupos electrógenos industriales. Venta, alquiler y servicio técnico multimarca."
```

### 11. TRUST SIGNALS (OBLIGATORIOS - CRÍTICOS PARA BADGES)
```json
"trust_garantia_texto": "Garantía oficial",
"trust_garantia_oficial": true,
"trust_garantia_incluida": true,
"trust_garantia_descripcion": "Respaldado por el fabricante",
"trust_envio_gratis": true,
"trust_envio_texto": "Envío gratis",
"trust_envio_descripcion": "En el ámbito de Buenos Aires",
"trust_acepta_devoluciones": false,
"trust_stock_disponible": true
```

**IMPORTANTE:** Estos campos controlan los badges de confianza que se muestran debajo del precio:
- `trust_garantia_texto` + `trust_garantia_incluida` → Badge "Garantía oficial"
- `trust_envio_gratis` + `trust_envio_texto` → Badge "Envío gratis"
- `trust_stock_disponible` → Badge "Stock disponible"

### 12. UBICACIÓN (OBLIGATORIO)
```json
"ubicacion_pais": "Argentina",
"ubicacion_provincia": "Buenos Aires",
"ubicacion_ciudad": "Florida",
"ubicacion_localidad": "Florida",
"ubicacion_envio": {
  "ciudad": "Florida",
  "provincia": "Buenos Aires",
  "texto_completo": "Florida, Buenos Aires"
}
```

### 13. STOCK Y VENTAS (OBLIGATORIO)
```json
"stock_cantidad": 1,
"stock_disponible": true,
"total_ventas": 0,
"total_reviews": 0,
"rating_promedio": 0,
"precio_anterior": null
```

### 14. FINANCIACIÓN (OBLIGATORIO)
```json
"planes_financiacion": [
  {
    "cuotas": 3,
    "interes": 0.08,
    "costoPorCuota": 14740000
  },
  {
    "cuotas": 6,
    "interes": 0.15,
    "costoPorCuota": 8100000
  },
  {
    "cuotas": 12,
    "interes": 0.25,
    "costoPorCuota": 4400000
  }
]
```

### 15. DOCUMENTOS (OPCIONAL)
```json
"documentos": []
```

---

## 📊 ESTRUCTURA COMPLETA DEL VARIANT.METADATA

### PRICING CONFIG (DUPLICADO - OBLIGATORIO)
```json
"pricing_config": {
  "familia": "Generadores Cummins - Línea CS",
  "currency_type": "usd_blue",
  "iva_percentage": 10.5,
  "precio_lista_usd": 28707,
  "bonificacion_percentage": 11,
  "descuento_contado_percentage": 9
}
```

### ESPECIFICACIONES TÉCNICAS (OBLIGATORIO)
```json
"especificaciones_tecnicas": {
  "potencia": {
    "standby_kva": 200,
    "standby_kw": 160,
    "prime_kva": 180,
    "prime_kw": 144,
    "factor_potencia": 0.8,
    "tension": "380/220V",
    "frecuencia": "50 Hz",
    "fases": 3
  },
  "motor": {
    "marca": "Cummins",
    "modelo": "6CTA83G2 TDI",
    "tipo": "Diesel 4 tiempos, Turbo Diesel Intercooled",
    "cilindros": 6,
    "cilindrada_litros": 8.3,
    "potencia_hp": 241,
    "potencia_kw": 180,
    "velocidad_rpm": 1500,
    "consumo_75_lh": 35,
    "consumo_100_lh": 45,
    "capacidad_aceite_litros": 24,
    "refrigeracion": "Por agua",
    "turboalimentado": true
  },
  "alternador": {
    "marca": "Stamford",
    "modelo": "UCI274G1",
    "tipo": "Sin escobillas (Brushless)",
    "excitacion": "Autoexcitado"
  },
  "panel_control": {
    "marca": "ComAp",
    "modelo": "InteliLite MRS16",
    "tipo": "Digital LCD",
    "arranque_automatico": true,
    "caracteristicas": [
      "Tablero digital",
      "Auto-start",
      "Parada de emergencia"
    ]
  },
  "combustible": {
    "tipo": "Diesel",
    "capacidad_tanque_litros": 430,
    "autonomia_75_horas": 12.3,
    "autonomia_100_horas": 10
  },
  "insonorizacion": {          // SOLO modelos Silent (S)
    "cabina": "Silent Premium",
    "nivel_ruido_db": 71,
    "distancia_metros": 7
  },
  "dimensiones": {
    "largo_mm": 3230,
    "ancho_mm": 1170,
    "alto_mm": 1800,
    "peso_kg": 2450,
    "peso_operativo_kg": 2880
  },
  "caracteristicas_principales": [
    "Motor Cummins turboalimentado",
    "Alternador Stamford brushless",
    "Cabina insonorizada 71 dB",
    "Panel de control digital ComAp",
    "Arranque automático",
    "Tanque de 430 litros",
    "Autonomía 12+ horas"
  ]
}
```

---

## 🔧 CAMPOS DEL VARIANT (NO METADATA)

```sql
weight = 2450000,          -- Peso en gramos (2450 kg)
length = 3230,             -- Largo en mm
height = 1800,             -- Alto en mm
width = 1170,              -- Ancho en mm
hs_code = '850211',        -- Código arancelario (fijo para generadores)
mid_code = 'GEN-CS200S',   -- Código MID único
origin_country = 'China'   -- País de origen
```

---

## 🏷️ TAGS OBLIGATORIOS

### Tags comunes (TODOS los modelos):
- `ptag_diesel`
- `ptag_cummins`
- `ptag_industrial`
- `ptag_estacionario`
- `ptag_automatico`
- `ptag_trifasico`
- `ptag_standby`
- `ptag_prime`
- `ptag_stamford`

### Tag de potencia (según KVA):
- `ptag_100200kva` → 100-200 KVA
- `ptag_200500kva` → 200-500 KVA
- `ptag_500kva` → +500 KVA

### Tag insonorizado (SOLO modelos "S"):
- `ptag_insonorizado` → CS200S, CS375S, CS450S, CS550S, CS650S

---

## 🖼️ IMÁGENES

**CRÍTICO**: Ordenar por tamaño de archivo (mayor a menor)

```bash
# Listar imágenes por tamaño
ls -lhS /carpeta/imagenes/*.webp

# La MÁS GRANDE va en rank = 0 (thumbnail)
# Seguir en orden descendente: rank 1, 2, 3, etc.
```

```sql
INSERT INTO image (id, url, rank, product_id, created_at, updated_at)
VALUES (gen_id(), 'http://localhost:9000/static/IMAGEN_MAS_GRANDE.webp', 0, v_product_id, NOW(), NOW());
```

---

## 📁 CATEGORÍAS

Según rango de potencia:
- `pcat_gen_diesel_100_200` → CS200A, CS200S
- `pcat_gen_diesel_200_500` → CS275A, CS360A, CS375S, CS450A, CS450S
- `pcat_gen_diesel_500` → CS550A, CS550S, CS650S

---

## 🔗 SALES CHANNEL (CRÍTICO)

```sql
INSERT INTO product_sales_channel (id, product_id, sales_channel_id, created_at, updated_at)
VALUES (
  gen_random_uuid()::text,
  v_product_id,
  'sc_01K9FZ84KQM1PG94Q6YT6248EW',
  NOW(),
  NOW()
);
```

---

## 💰 PRICING

```sql
-- Price Set
INSERT INTO price_set (id, created_at, updated_at)
VALUES (v_price_set_id, NOW(), NOW());

-- Precio USD (en centavos)
INSERT INTO price (id, price_set_id, currency_code, amount, raw_amount, created_at, updated_at)
VALUES (v_price_usd_id, v_price_set_id, 'usd', 2870700, '{"value": "2870700"}'::jsonb, NOW(), NOW());

-- Precio ARS (en centavos)
INSERT INTO price (id, price_set_id, currency_code, amount, raw_amount, created_at, updated_at)
VALUES (v_price_ars_id, v_price_set_id, 'ars', 3960834400, '{"value": "3960834400"}'::jsonb, NOW(), NOW());

-- Vincular con variant
INSERT INTO product_variant_price_set (id, variant_id, price_set_id, created_at, updated_at)
VALUES (gen_random_uuid()::text, v_variant_id, v_price_set_id, NOW(), NOW());
```

---

## ✅ CHECKLIST PRE-IMPORTACIÓN

Antes de ejecutar el script, verificar:

- [ ] Imágenes copiadas a `/medusa-backend/static/` y ordenadas por tamaño
- [ ] Precio extraído del PDF de lista de precios
- [ ] Especificaciones técnicas completas de la carpeta del producto
- [ ] Handle único (sin conflictos)
- [ ] SKU único (GEN-<MODELO>)
- [ ] Type ID correcto: `ptype_generador_diesel`
- [ ] Collection ID correcta: `pcoll_cummins_cs`
- [ ] Categoría según KVA
- [ ] Tags según si es Silent o no
- [ ] Sales Channel asignado

---

## ✅ CHECKLIST POST-IMPORTACIÓN

Después de ejecutar el script, verificar:

1. **Base de datos**:
```sql
SELECT 
  p.handle,
  pv.weight,
  pv.hs_code,
  pv.mid_code,
  length(p.metadata::text) as product_meta,
  length(pv.metadata::text) as variant_meta,
  COUNT(DISTINCT img.id) as images,
  COUNT(DISTINCT pt.product_tag_id) as tags,
  COUNT(DISTINCT psc.sales_channel_id) as channels
FROM product p
JOIN product_variant pv ON p.id = pv.product_id
LEFT JOIN image img ON p.id = img.product_id
LEFT JOIN product_tags pt ON p.id = pt.product_id
LEFT JOIN product_sales_channel psc ON p.id = psc.product_id
WHERE p.handle = 'cummins-cs200s-v2'
GROUP BY p.handle, pv.weight, pv.hs_code, pv.mid_code, p.metadata, pv.metadata;
```

**Resultado esperado**:
- product_meta: ~2600-2700 bytes
- variant_meta: ~1600-1700 bytes
- images: 10-13 según modelo
- tags: 10-11 según si es Silent
- channels: 1

2. **Admin Medusa** (http://localhost:9000/app/products):
   - [ ] Sales Channel NO muestra "-"
   - [ ] Attributes completos
   - [ ] Metadata con múltiples keys

3. **Frontend** (http://localhost:3000/producto/<handle>):
   - [ ] Badge "RECIÉN LLEGADO" (verde)
   - [ ] Badge "Nuevo"
   - [ ] Badges: Combustible, TTA, dB, peso (opcional), dimensiones (opcional)
   - [ ] Vendor: KOR con rating 5 estrellas
   - [ ] "+15 años" y "Dentro de 24hs"
   - [ ] ✓ Garantía oficial
   - [ ] 🚚 Envío gratis
   - [ ] Stock disponible
   - [ ] Precio correcto en ARS
   - [ ] Imágenes de características (Tablero, Cerraduras, etc.)
   - [ ] "Lo que tenés que saber" con bullets completos

---

## 📝 SCRIPT DE REFERENCIA

Ver: `/scripts/import-cs200s-v2-complete.sql`

Este script contiene la implementación completa de todos los campos mencionados arriba.

---

**Última actualización:** 2025-11-09  
**Productos validados:** CS200A (original), CS200S-V2 (completo)
