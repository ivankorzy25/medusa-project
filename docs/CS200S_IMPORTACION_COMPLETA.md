# CS200S - Importación Completa

## Estado: ✅ COMPLETADO

---

## Archivos Creados

### 1. Script SQL Principal
📄 **`/scripts/import-cs200s-COMPLETE.sql`**

Este script crea el producto CS200S 100% completo, incluyendo:

#### ✅ Producto Principal
- ID: `prod_cummins_cs200s`
- Handle: `cummins-cs200s`
- Título: "CUMMINS CS200S - Generador Diesel Industrial 200 KVA"
- Descripción completa (245 palabras)
- Metadata: **60+ campos** con toda la información técnica

#### ✅ Variant (SKU)
- ID: `variant_cummins_cs200s_std`
- SKU: `GEN-CUM-CS200S-STD`
- Barcode: `7798345200203`
- Stock: 5 unidades
- Configuración: Estándar

#### ✅ Precios
- **Sin IVA:** USD 28,707.00
- **Con IVA 10.5%:** USD 31,721.24
- Moneda: USD
- Price Set ID: `pvps_cs200s`

#### ✅ Imágenes (13 total)
```
img_cs200s_01 → Vista frontal completa
img_cs200s_02 → Vista lateral derecha
img_cs200s_03 → Panel de control Comap MRS16
img_cs200s_04 → Motor Cummins 6CTAA8.3-G
img_cs200s_05 → Alternador Stamford UCI274G1
img_cs200s_06 → Vista posterior
img_cs200s_07 → Detalle cabina insonorizada
img_cs200s_08 → Sistema de escape y silenciador
img_cs200s_09 → Radiador y sistema de refrigeración
img_cs200s_10 → Tanque de combustible 430L
img_cs200s_11 → Conexiones eléctricas
img_cs200s_12 → Sistema ATS integrado
img_cs200s_13 → Vista general instalado
```

Ruta base: `/productos/cummins/cs200s/`

#### ✅ Taxonomía Completa

**Type:**
- `ptype_generador_diesel`

**Collection:**
- `pcoll_cummins_cs`

**Categories:**
- `pcat_gen_diesel_100_200` (100 a 200 KVA)

**Tags (11 total):**
- `ptag_diesel`
- `ptag_cummins`
- `ptag_industrial`
- `ptag_estacionario`
- `ptag_automatico`
- `ptag_insonorizado` ← **CLAVE: Solo CS200S lo tiene**
- `ptag_trifasico`
- `ptag_standby`
- `ptag_prime`
- `ptag_stamford`
- `ptag_100200kva`

#### ✅ Sales Channel
- Asignado a "Default Sales Channel"

---

## Especificaciones Técnicas Completas

### Metadata del Producto (60+ campos)

#### Información Básica
```json
{
  "marca": "Cummins",
  "modelo": "CS200S",
  "familia": "Línea CS",
  "año_modelo": "2025",
  "origen": "China (motor y alternador ensamblados bajo licencia)",
  "distribuidor": "KOR Generadores / E-Gaucho"
}
```

#### Potencia
```json
{
  "potencia_standby_kva": "200",
  "potencia_standby_kw": "160",
  "potencia_prime_kva": "180",
  "potencia_prime_kw": "144",
  "factor_potencia": "0.8"
}
```

#### Motor Cummins
```json
{
  "motor_marca": "Cummins",
  "motor_modelo": "6CTAA8.3-G",
  "motor_fabricante": "Cummins Inc. (USA)",
  "motor_potencia_hp": "241",
  "motor_potencia_kw": "180",
  "motor_cilindros": "6",
  "motor_tipo_cilindros": "En línea",
  "motor_cilindrada": "8.3",
  "motor_cilindrada_unidad": "litros",
  "motor_aspiracion": "Turbo Diesel Intercooled (TDI)",
  "motor_rpm": "1500",
  "motor_refrigeracion": "Agua",
  "tipo_refrigeracion": "Agua",
  "motor_tipo": "Diesel 4 tiempos",
  "motor_relacion_compresion": "17.3:1",
  "motor_vida_util_horas": "30000"
}
```

#### Alternador Stamford
```json
{
  "alternador_marca": "Stamford",
  "alternador_modelo": "UCI274G1",
  "alternador_tipo": "Brushless (sin escobillas)",
  "alternador_tecnologia": "AVR digital",
  "alternador_clase_aislamiento": "H",
  "alternador_proteccion_ip": "IP23",
  "alternador_eficiencia": "94"
}
```

#### Eléctrico
```json
{
  "voltaje_salida": "220/380V",
  "voltaje_nominal": "380",
  "fases": "Trifásico",
  "frecuencia": "50Hz",
  "corriente_standby_amp": "304",
  "corriente_prime_amp": "274",
  "conexion": "3F + N + T"
}
```

#### Combustible y Autonomía
```json
{
  "combustible_tipo": "Diesel / Gasoil",
  "combustible_capacidad_tanque": "430",
  "combustible_consumo_75_carga": "35",
  "autonomia_horas_75_carga": "12.3",
  "autonomia_horas_50_carga": "18",
  "autonomia_horas_25_carga": "24"
}
```

#### Panel de Control Comap
```json
{
  "panel_control_marca": "Comap",
  "panel_control_modelo": "MRS16",
  "panel_control_tipo": "Digital con pantalla LCD",
  "panel_control_funciones": "Auto start, Monitoreo remoto, ModBus",
  "tipo_arranque": "Eléctrico automático",
  "arranque_automatico": "Sí",
  "sistema_transferencia": "ATS integrado"
}
```

#### Insonorización (CLAVE)
```json
{
  "nivel_ruido_db": "71",
  "nivel_ruido_distancia": "7 metros",
  "tipo_cabina": "Insonorizada premium",
  "insonorizado": "Sí"
}
```

#### Dimensiones y Peso
```json
{
  "largo_mm": "3200",
  "ancho_mm": "1200",
  "alto_mm": "2300",
  "peso_kg": "2500"
}
```

#### Características Especiales
```json
{
  "certificaciones": "CE, ISO 9001, Cummins Certified",
  "garantia_motor": "2 años o 2000 horas",
  "garantia_alternador": "2 años",
  "garantia_equipo": "1 año",
  "aplicaciones": "Hospitales, Centros de datos, Industrias, Edificios comerciales",
  "modo_operacion": "Standby/Prime",
  "incluye": "Cargador de batería, Baterías, Radiador, Silenciador, Sistema de escape, Manual de operación en español",
  "ventajas": "Motor Cummins original, Bajo consumo 35 L/h, Autonomía 12+ horas, Nivel de ruido ultra bajo 71dB, Monitoreo remoto 24/7"
}
```

#### SEO
```json
{
  "seo_keywords": "generador cummins, cs200s, 200 kva, diesel, insonorizado, industrial, standby, prime, trifasico",
  "seo_description": "Generador Cummins CS200S 200 KVA diesel industrial con motor 6CTAA8.3-G, alternador Stamford, panel Comap MRS16. Insonorizado 71dB. Ideal para hospitales, industrias y centros de datos."
}
```

---

## Cómo Ejecutar el Script

### Opción 1: Desde psql
```bash
# Conectar a la base de datos
psql postgresql://[USER]:[PASSWORD]@localhost:5432/medusa-store

# Ejecutar el script
\i /Users/ivankorzyniewski/medusa-storefront-product-template-20251106/scripts/import-cs200s-COMPLETE.sql
```

### Opción 2: Desde línea de comandos
```bash
psql postgresql://[USER]:[PASSWORD]@localhost:5432/medusa-store \
  -f /Users/ivankorzyniewski/medusa-storefront-product-template-20251106/scripts/import-cs200s-COMPLETE.sql
```

### Opción 3: Desde Docker (si usas contenedor)
```bash
docker exec -i medusa-postgres psql -U postgres -d medusa-store < scripts/import-cs200s-COMPLETE.sql
```

---

## Verificaciones Post-Ejecución

### 1. Verificar Producto Creado
```sql
SELECT * FROM product WHERE handle = 'cummins-cs200s';
```

### 2. Verificar Variant
```sql
SELECT * FROM product_variant WHERE product_id = 'prod_cummins_cs200s';
```

### 3. Verificar Precios
```sql
SELECT
  pv.sku,
  psma.currency_code,
  psma.amount / 100.0 as precio_sin_iva,
  (psma.amount * 1.105) / 100.0 as precio_con_iva
FROM product_variant pv
JOIN product_variant_price_set pvps ON pv.price_set_id = pvps.id
JOIN price_set_money_amount psma ON pvps.id = psma.price_set_id
WHERE pv.product_id = 'prod_cummins_cs200s';
```

### 4. Verificar Imágenes
```sql
SELECT COUNT(*) as total_imagenes
FROM product_images pi
WHERE pi.product_id = 'prod_cummins_cs200s';
-- Resultado esperado: 13
```

### 5. Verificar Taxonomía
```sql
-- Type
SELECT pt.value FROM product p
JOIN product_type pt ON p.type_id = pt.id
WHERE p.id = 'prod_cummins_cs200s';
-- Resultado: Generador Diesel

-- Collection
SELECT pc.title FROM product p
JOIN product_collection pc ON p.collection_id = pc.id
WHERE p.id = 'prod_cummins_cs200s';
-- Resultado: Generadores Cummins - Línea CS

-- Categories
SELECT pcat.name FROM product_category_product pcp
JOIN product_category pcat ON pcp.product_category_id = pcat.id
WHERE pcp.product_id = 'prod_cummins_cs200s';
-- Resultado: 100 a 200 KVA

-- Tags
SELECT string_agg(ptag.value, ', ') FROM product_tags ptags
JOIN product_tag ptag ON ptags.product_tag_id = ptag.id
WHERE ptags.product_id = 'prod_cummins_cs200s';
-- Resultado: 11 tags incluyendo "insonorizado"
```

### 6. Verificar Metadata Completo
```sql
SELECT
  jsonb_object_keys(metadata) as campo,
  metadata->>jsonb_object_keys(metadata) as valor
FROM product
WHERE id = 'prod_cummins_cs200s'
ORDER BY campo;
-- Resultado: 60+ campos
```

---

## Frontend URLs

### Storefront
```
http://localhost:8000/products/cummins-cs200s
```

### Admin Panel
```
http://localhost:9000/a/products/prod_cummins_cs200s
```

---

## Diferencias Clave con CS200A

| Aspecto | CS200A | CS200S | Diferencia |
|---------|---------|---------|------------|
| **Insonorización** | ❌ NO | ✅ SÍ | +Cabina Silent |
| **Ruido** | ~95 dB | **71 dB** | -24 dB |
| **Peso** | 1,900 kg | **2,500 kg** | +600 kg |
| **Precio** | USD 26,411 | **USD 28,707** | +USD 2,296 |
| **Tag "insonorizado"** | ❌ NO | ✅ SÍ | En taxonomía |
| **Uso urbano** | ⚠️ Limitado | ✅ Permitido | Normativas |

---

## Archivos Fuente Analizados

### Carpeta CS200S
📁 `/Users/ivankorzyniewski/Desktop/RECUPERACION_V_DRIVE/GENERADORES/001-GENERADORES/GAUCHO Generadores Cummins - Linea CS/CS200S/`

Contenido:
- ✅ `CS 200 S.pdf` (1 MB) - Ficha técnica completa
- ✅ `CS200S.json` (84 KB) - Especificaciones estructuradas
- ✅ `CS200S.md` (91 KB) - Descripción y precio
- ✅ `CS200S_PLACEHOLDER.json` - Metadata inicial
- ✅ `IMAGENES-CS 200 S/` (13 imágenes WebP)
- ✅ `cummins_cs200s_premium_html.html` - HTML promocional

### Carpeta CS200A (Referencia)
📁 `/Users/ivankorzyniewski/Desktop/RECUPERACION_V_DRIVE/GENERADORES/001-GENERADORES/GAUCHO Generadores Cummins - Linea CS/CS200A/`

Contenido:
- ✅ `CS 200 A .pdf` (920 KB)
- ✅ `CS200A.md` (241 bytes)
- ✅ `CS200A_PLACEHOLDER.json`
- ❌ No tiene carpeta de imágenes (diferencia con CS200S)

---

## Documentación Adicional Creada

### 1. Comparativa Detallada
📄 **`/docs/COMPARATIVA_CS200A_VS_CS200S.md`**

Incluye:
- Tabla comparativa completa
- ROI de la cabina insonorizada
- Argumentos de venta
- Aplicaciones recomendadas para cada modelo

### 2. Este Documento
📄 **`/docs/CS200S_IMPORTACION_COMPLETA.md`**

---

## Checklist Final

- [x] Analizar estructura CS200A existente
- [x] Explorar carpeta CS200S completa (JSON, MD, PDF, imágenes)
- [x] Comparar CS200A vs CS200S
- [x] Crear script SQL completo con:
  - [x] Producto principal (60+ campos metadata)
  - [x] Variant con SKU y stock
  - [x] Precios (USD 28,707 sin IVA)
  - [x] 13 imágenes vinculadas
  - [x] Taxonomía completa (Type, Collection, Categories, Tags)
  - [x] Sales Channel asignado
- [x] Incluir tag "insonorizado" (diferencia clave con CS200A)
- [x] Verificaciones SQL integradas en el script
- [x] Crear documentación comparativa
- [x] Crear este documento de resumen

---

## Próximos Pasos

### 1. Ejecutar el Script
```bash
# Desde la carpeta del proyecto
psql [TU_CADENA_CONEXION] -f scripts/import-cs200s-COMPLETE.sql
```

### 2. Copiar Imágenes al Public
```bash
# Crear directorio
mkdir -p public/productos/cummins/cs200s

# Copiar las 13 imágenes
cp "/Users/ivankorzyniewski/Desktop/RECUPERACION_V_DRIVE/GENERADORES/001-GENERADORES/GAUCHO Generadores Cummins - Linea CS/CS200S/IMAGENES-CS 200 S/"*.webp \
   public/productos/cummins/cs200s/
```

### 3. Verificar en Storefront
- Abrir: `http://localhost:8000/products/cummins-cs200s`
- Verificar: Título, descripción, precio, imágenes, specs

### 4. Verificar en Admin
- Abrir: `http://localhost:9000/a/products/prod_cummins_cs200s`
- Verificar: Metadata, taxonomía, variant, precios

### 5. Testing
- [ ] Buscar por "cummins cs200s" en el buscador
- [ ] Filtrar por tag "insonorizado" (debe aparecer)
- [ ] Verificar que "Lo que tenés que saber" muestre 13+ características
- [ ] Comparar visualmente con CS200A

---

## Contacto y Soporte

Si necesitas ajustes o encuentras algún problema:

1. Verificar logs del script SQL
2. Revisar este documento para las verificaciones
3. Comparar con CS200A que ya funciona
4. Consultar `/docs/COMPARATIVA_CS200A_VS_CS200S.md`

---

## Changelog

### 2025-11-08 - Versión 1.0
- ✅ Creación del script SQL completo
- ✅ 60+ campos de metadata
- ✅ 13 imágenes incluidas
- ✅ Taxonomía completa con tag "insonorizado"
- ✅ Precios: USD 28,707 (sin IVA)
- ✅ Documentación comparativa
- ✅ Listo para ejecutar

---

**Estado:** ✅ COMPLETO Y LISTO PARA EJECUTAR

**Script principal:** `/scripts/import-cs200s-COMPLETE.sql`

**Autor:** Claude Code (Sonnet 4.5)

**Fecha:** 2025-11-08
