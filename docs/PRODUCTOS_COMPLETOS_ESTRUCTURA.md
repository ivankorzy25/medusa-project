# 📊 ESTRUCTURA DE PRODUCTOS COMPLETOS - REFERENCIA

**Fecha:** 2025-11-08
**Productos de referencia:** CS200A, CS200S, CS275A
**Estado:** ✅ COMPLETOS Y VALIDADOS

---

## ✅ VERIFICACIÓN DE COMPLETITUD

```sql
-- Query de verificación
SELECT
  p.handle,
  pv.weight,
  pv.hs_code,
  pv.mid_code,
  pv.origin_country,
  length(pv.metadata::text) as metadata_size,
  COUNT(DISTINCT img.id) as images,
  COUNT(DISTINCT psc.sales_channel_id) as sales_channels,
  COUNT(DISTINCT pcp.product_category_id) as categories,
  COUNT(DISTINCT pt.product_tag_id) as tags
FROM product p
JOIN product_variant pv ON p.id = pv.product_id
LEFT JOIN image img ON p.id = img.product_id
LEFT JOIN product_sales_channel psc ON p.id = psc.product_id
LEFT JOIN product_category_product pcp ON p.id = pcp.product_id
LEFT JOIN product_tags pt ON p.id = pt.product_id
WHERE p.handle IN ('cummins-cs200a', 'cummins-cs200s', 'cummins-cs275a')
GROUP BY p.handle, pv.weight, pv.hs_code, pv.mid_code, pv.origin_country, pv.metadata
ORDER BY p.handle;
```

**Resultado esperado:**
```
     handle     | weight  | hs_code |  mid_code  | origin_country | metadata_size | images | sales_channels | categories | tags
----------------+---------+---------+------------+----------------+---------------+--------+----------------+------------+------
 cummins-cs200a | 2850000 | 850211  | GEN-CS200A | China          |          1456 |      8 |              1 |          1 |   11
 cummins-cs200s | 2450000 | 850211  | GEN-CS200S | China          |          1641 |     13 |              1 |          1 |   11
 cummins-cs275a | 2200000 | 850211  | GEN-CS275A | China          |          1463 |     27 |              1 |          1 |   10
```

---

## 📋 CAMPOS OBLIGATORIOS DEL VARIANT

### Dimensiones Físicas
```sql
weight = <peso_en_gramos>,     -- Ejemplo: 2850000 (2850 kg)
length = <largo_mm>,            -- Ejemplo: 3200 mm
height = <alto_mm>,             -- Ejemplo: 1900 mm
width = <ancho_mm>              -- Ejemplo: 1400 mm
```

### Códigos de Identificación
```sql
hs_code = '850211',                    -- Código HS (arancelario) fijo para generadores
mid_code = 'GEN-<MODELO>',             -- Código MID único (ej: GEN-CS200A)
origin_country = 'China'                -- País de origen
```

### Metadata JSONB (Estructura Completa)
```json
{
  "pricing_config": {
    "precio_lista_usd": <precio_sin_iva>,
    "currency_type": "usd_blue",
    "iva_percentage": 10.5,
    "bonificacion_percentage": 11,
    "descuento_contado_percentage": 9,
    "familia": "Generadores Cummins - Línea CS"
  },
  "especificaciones_tecnicas": {
    "potencia": {
      "standby_kva": <kva_standby>,
      "standby_kw": <kw_standby>,
      "prime_kva": <kva_prime>,
      "prime_kw": <kw_prime>,
      "factor_potencia": 0.8,
      "tension": "380/220V",
      "frecuencia": "50 Hz",
      "fases": 3
    },
    "motor": {
      "marca": "Cummins",
      "modelo": "<modelo_motor>",
      "tipo": "<descripcion_tipo>",
      "cilindros": <num_cilindros>,
      "cilindrada_litros": <cilindrada>,
      "potencia_hp": <hp>,
      "velocidad_rpm": 1500,
      "consumo_75_lh": <consumo>,
      "capacidad_aceite_litros": <capacidad>,
      "refrigeracion": "Por agua",
      "turboalimentado": true
    },
    "alternador": {
      "marca": "Stamford",
      "modelo": "<modelo_alternador>",
      "tipo": "Sin escobillas (Brushless)",
      "excitacion": "Autoexcitado"
    },
    "panel_control": {
      "marca": "COMAP" | "ComAp",
      "modelo": "<modelo_panel>",
      "tipo": "Electronico LCD" | "Digital LCD",
      "arranque_automatico": true,
      "caracteristicas": [
        "Tablero digital",
        "Auto-start",
        "Parada de emergencia"
      ]
    },
    "combustible": {
      "tipo": "Diesel",
      "capacidad_tanque_litros": <capacidad>,
      "autonomia_75_horas": <horas>
    },
    "dimensiones": {
      "largo_mm": <largo>,
      "ancho_mm": <ancho>,
      "alto_mm": <alto>,
      "peso_kg": <peso>
    },
    "caracteristicas_principales": [
      "<caracteristica_1>",
      "<caracteristica_2>",
      ...
    ]
  }
}
```

**IMPORTANTE - Modelos Silent (terminan en "S"):**
Si el modelo es Silent/Insonorizado, agregar sección adicional:
```json
"insonorizacion": {
  "cabina": "Silent Premium",
  "nivel_ruido_db": <db>,
  "distancia_metros": 7
}
```

---

## 🏷️ TAGS OBLIGATORIOS

### Tags Comunes (todos los modelos):
```sql
INSERT INTO product_tags (product_id, product_tag_id) VALUES
  (v_product_id, 'ptag_diesel'),
  (v_product_id, 'ptag_cummins'),
  (v_product_id, 'ptag_industrial'),
  (v_product_id, 'ptag_estacionario'),
  (v_product_id, 'ptag_automatico'),
  (v_product_id, 'ptag_trifasico'),
  (v_product_id, 'ptag_standby'),
  (v_product_id, 'ptag_prime'),
  (v_product_id, 'ptag_stamford');
```

### Tag de Potencia (según KVA):
- `ptag_100200kva` → 100-200 KVA (CS200A, CS200S)
- `ptag_200500kva` → 200-500 KVA (CS275A, CS360A, CS375S, CS450A, CS450S)
- `ptag_500kva` → +500 KVA (CS550A, CS550S, CS650S)

### Tag Insonorizado (solo modelos "S"):
```sql
(v_product_id, 'ptag_insonorizado')  -- SOLO para CS200S, CS375S, CS450S, CS550S, CS650S
```

---

## 📁 CATEGORÍAS

### Por Rango de Potencia:
- `pcat_gen_diesel_100_200` → CS200A, CS200S (100-200 KVA)
- `pcat_gen_diesel_200_500` → CS275A, CS360A, CS375S, CS450A, CS450S (200-500 KVA)
- `pcat_gen_diesel_500` → CS550A, CS550S, CS650S (+500 KVA)

```sql
INSERT INTO product_category_product (product_category_id, product_id)
VALUES ('<categoria_id>', v_product_id);
```

---

## 🔗 SALES CHANNEL (CRÍTICO)

**OBLIGATORIO** - Sin esto el producto NO aparece en frontend ni admin:

```sql
INSERT INTO product_sales_channel (id, product_id, sales_channel_id, created_at, updated_at)
VALUES (
  gen_random_uuid()::text,
  v_product_id,
  'sc_01K9FZ84KQM1PG94Q6YT6248EW',  -- Default Sales Channel ID
  NOW(),
  NOW()
);
```

---

## 🖼️ IMÁGENES

### Ordenamiento CRÍTICO
Las imágenes DEBEN estar ordenadas por tamaño de archivo (mayor a menor):

```bash
# Listar imágenes ordenadas por tamaño
ls -lhS /ruta/carpeta/imagenes/*.webp

# La imagen MÁS PESADA va rank=1 (thumbnail)
```

### Inserción
```sql
-- Imagen 1 (MÁS GRANDE - thumbnail)
v_image_id := substring(md5(random()::text) from 1 for 6);
INSERT INTO image (id, url, rank, product_id, created_at, updated_at)
VALUES (v_image_id, 'http://localhost:9000/static/IMAGEN_MAS_GRANDE.webp', 1, v_product_id, NOW(), NOW());

-- Imagen 2 (segunda más grande)
v_image_id := substring(md5(random()::text) from 1 for 6);
INSERT INTO image (id, url, rank, product_id, created_at, updated_at)
VALUES (v_image_id, 'http://localhost:9000/static/IMAGEN_2.webp', 2, v_product_id, NOW(), NOW());

-- ... continuar en orden descendente de tamaño
```

---

## 🔍 REFERENCIAS DE METADATA COMPLETA

### CS275A (Archivo de referencia)
```bash
/scripts/cs275a-metadata-REFERENCE.json
```

Este archivo contiene la estructura JSONB EXACTA que debe replicarse para cada producto nuevo.

---

## 📝 SCRIPTS DE ACTUALIZACIÓN

Para completar productos existentes que falten campos:

```bash
# Actualizar CS200A con estructura completa
psql -f scripts/update-cs200a-complete.sql

# Actualizar CS200S con metadata
psql -f scripts/update-cs200s-complete.sql
```

---

## ✅ CHECKLIST DE PRODUCTO COMPLETO

Antes de considerar un producto terminado, verificar:

- [ ] `product` tabla: title, subtitle, description, handle, thumbnail, type_id, collection_id
- [ ] `product_variant` tabla:
  - [ ] weight (en gramos)
  - [ ] length, height, width (en mm)
  - [ ] hs_code = '850211'
  - [ ] mid_code = 'GEN-<MODELO>'
  - [ ] origin_country = 'China'
  - [ ] metadata JSONB completa (pricing_config + especificaciones_tecnicas)
- [ ] `image` tabla: Mínimo 1 imagen, ordenadas por tamaño (rank 1 = más grande)
- [ ] `product_sales_channel`: Asignado a Default Sales Channel
- [ ] `product_category_product`: Categoría según KVA
- [ ] `product_tags`: 10-11 tags según modelo (con/sin insonorizado)

---

## 🚀 URLs DE VERIFICACIÓN

Después de crear/actualizar un producto, verificar:

1. **Admin**: `http://localhost:9000/app/products/<product_id>`
   - Ver que tenga Sales Channel asignado (no "-")
   - Ver que Attributes estén completos
   - Ver que Metadata tenga keys (no vacía)

2. **Frontend**: `http://localhost:3000/producto/<handle>`
   - Verificar que cargue sin error
   - Verificar que muestre imágenes
   - Verificar que calcule precio correctamente

---

**Última actualización:** 2025-11-08
**Productos validados:** CS200A, CS200S, CS275A (3/10 Línea CS)
**Próximos:** CS360A, CS375S, CS450A, CS450S, CS550A, CS550S, CS650S
