-- ============================================
-- SCRIPT: Importación COMPLETA Cummins CS200S
-- ============================================
-- Este script crea el producto CS200S con TODA la información
-- disponible, siguiendo la estructura del CS200A que ya funciona.
--
-- BASADO EN:
--   - CS200A existente (estructura completa)
--   - Carpeta CS200S con JSON, MD, PDF e imágenes
--   - Precio: USD 28,707 (sin IVA)
--
-- INCLUYE:
--   ✓ Producto con metadata completa
--   ✓ Variant con especificaciones técnicas
--   ✓ 13 imágenes (product_images)
--   ✓ Taxonomía completa (Type, Collection, Categories, Tags)
--   ✓ Precios con IVA, bonificaciones y descuentos
-- ============================================

-- ============================================
-- PASO 1: CREAR PRODUCTO PRINCIPAL
-- ============================================

INSERT INTO product (
  id,
  title,
  subtitle,
  description,
  handle,
  is_giftcard,
  thumbnail,
  weight,
  length,
  height,
  width,
  hs_code,
  origin_country,
  mid_code,
  material,
  collection_id,
  type_id,
  discountable,
  external_id,
  created_at,
  updated_at,
  deleted_at,
  metadata
)
VALUES (
  'prod_cummins_cs200s',
  'CUMMINS CS200S - Generador Diesel Industrial 200 KVA',
  'Motor Cummins 6CTAA8.3-G | Alternador Stamford | Panel Comap MRS16 | Insonorizado 71dB',
  'El CUMMINS CS200S es un generador diesel de alta gama diseñado para aplicaciones industriales críticas. Combina el legendario motor Cummins 6CTA83G2 de 8.3 litros turbo diesel intercooled con 241 HP, el alternador Stamford UCI274G1 de tecnología brushless, y el sofisticado panel de control Comap MRS16 con capacidad de arranque automático y monitoreo remoto. Su cabina insonorizada premium reduce el nivel de ruido a solo 71 dB, permitiendo operación en entornos urbanos. Con un tanque de 430 litros proporciona más de 12 horas de autonomía continua, haciéndolo ideal para hospitales, centros de datos, industrias y edificios comerciales donde la continuidad eléctrica es crítica.',
  'cummins-cs200s',
  false,
  '/productos/cummins/cs200s/CS_200_S_20251014_153804_1.webp',
  2500000,  -- 2500 kg en gramos
  3200,     -- 3.2m en mm
  2300,     -- 2.3m en mm
  1200,     -- 1.2m en mm
  '8502.11.00',
  'cn',
  NULL,
  'Acero inoxidable, aislamiento acústico',
  'pcoll_cummins_cs',
  'ptype_generador_diesel',
  true,
  NULL,
  NOW(),
  NOW(),
  NULL,
  jsonb_build_object(
    -- === INFORMACIÓN BÁSICA ===
    'marca', 'Cummins',
    'modelo', 'CS200S',
    'familia', 'Línea CS',
    'año_modelo', '2025',
    'origen', 'China (motor y alternador ensamblados bajo licencia)',
    'distribuidor', 'KOR Generadores / E-Gaucho',

    -- === POTENCIA ===
    'potencia_standby_kva', '200',
    'potencia_standby_kw', '160',
    'potencia_prime_kva', '180',
    'potencia_prime_kw', '144',
    'factor_potencia', '0.8',

    -- === MOTOR ===
    'motor_marca', 'Cummins',
    'motor_modelo', '6CTAA8.3-G',
    'motor_fabricante', 'Cummins Inc. (USA)',
    'motor_potencia_hp', '241',
    'motor_potencia_kw', '180',
    'motor_cilindros', '6',
    'motor_tipo_cilindros', 'En línea',
    'motor_cilindrada', '8.3',
    'motor_cilindrada_unidad', 'litros',
    'motor_aspiracion', 'Turbo Diesel Intercooled (TDI)',
    'motor_rpm', '1500',
    'motor_refrigeracion', 'Agua',
    'tipo_refrigeracion', 'Agua',
    'motor_tipo', 'Diesel 4 tiempos',
    'motor_relacion_compresion', '17.3:1',
    'motor_vida_util_horas', '30000',

    -- === ALTERNADOR ===
    'alternador_marca', 'Stamford',
    'alternador_modelo', 'UCI274G1',
    'alternador_tipo', 'Brushless (sin escobillas)',
    'alternador_tecnologia', 'AVR digital',
    'alternador_clase_aislamiento', 'H',
    'alternador_proteccion_ip', 'IP23',
    'alternador_eficiencia', '94',

    -- === ELÉCTRICO ===
    'voltaje_salida', '220/380V',
    'voltaje_nominal', '380',
    'fases', 'Trifásico',
    'frecuencia', '50Hz',
    'corriente_standby_amp', '304',
    'corriente_prime_amp', '274',
    'conexion', '3F + N + T',

    -- === COMBUSTIBLE Y AUTONOMÍA ===
    'combustible_tipo', 'Diesel / Gasoil',
    'combustible_capacidad_tanque', '430',
    'combustible_consumo_75_carga', '35',
    'autonomia_horas_75_carga', '12.3',
    'autonomia_horas_50_carga', '18',
    'autonomia_horas_25_carga', '24',

    -- === PANEL DE CONTROL ===
    'panel_control_marca', 'Comap',
    'panel_control_modelo', 'MRS16',
    'panel_control_tipo', 'Digital con pantalla LCD',
    'panel_control_funciones', 'Auto start, Monitoreo remoto, ModBus',
    'tipo_arranque', 'Eléctrico automático',
    'arranque_automatico', 'Sí',
    'sistema_transferencia', 'ATS integrado',

    -- === INSONORIZACIÓN ===
    'nivel_ruido_db', '71',
    'nivel_ruido_distancia', '7 metros',
    'tipo_cabina', 'Insonorizada premium',
    'insonorizado', 'Sí',

    -- === DIMENSIONES Y PESO ===
    'largo_mm', '3200',
    'ancho_mm', '1200',
    'alto_mm', '2300',
    'peso_kg', '2500',

    -- === CARACTERÍSTICAS ESPECIALES ===
    'certificaciones', 'CE, ISO 9001, Cummins Certified',
    'garantia_motor', '2 años o 2000 horas',
    'garantia_alternador', '2 años',
    'garantia_equipo', '1 año',
    'aplicaciones', 'Hospitales, Centros de datos, Industrias, Edificios comerciales',
    'modo_operacion', 'Standby/Prime',

    -- === INCLUYE ===
    'incluye', 'Cargador de batería, Baterías, Radiador, Silenciador, Sistema de escape, Manual de operación en español',

    -- === VENTAJAS COMPETITIVAS ===
    'ventajas', 'Motor Cummins original, Bajo consumo 35 L/h, Autonomía 12+ horas, Nivel de ruido ultra bajo 71dB, Monitoreo remoto 24/7',

    -- === SEO ===
    'seo_keywords', 'generador cummins, cs200s, 200 kva, diesel, insonorizado, industrial, standby, prime, trifasico',
    'seo_description', 'Generador Cummins CS200S 200 KVA diesel industrial con motor 6CTAA8.3-G, alternador Stamford, panel Comap MRS16. Insonorizado 71dB. Ideal para hospitales, industrias y centros de datos.'
  )
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  subtitle = EXCLUDED.subtitle,
  description = EXCLUDED.description,
  metadata = EXCLUDED.metadata,
  updated_at = NOW();

-- ============================================
-- PASO 2: CREAR VARIANT (SKU)
-- ============================================

INSERT INTO product_variant (
  id,
  title,
  product_id,
  sku,
  barcode,
  ean,
  upc,
  inventory_quantity,
  allow_backorder,
  manage_inventory,
  hs_code,
  origin_country,
  mid_code,
  material,
  weight,
  length,
  height,
  width,
  variant_rank,
  created_at,
  updated_at,
  deleted_at,
  metadata
)
VALUES (
  'variant_cummins_cs200s_std',
  'Configuración Estándar',
  'prod_cummins_cs200s',
  'GEN-CUM-CS200S-STD',
  '7798345200203',
  NULL,
  NULL,
  5,
  true,
  true,
  '8502.11.00',
  'cn',
  NULL,
  'Acero inoxidable, aislamiento acústico',
  2500000,
  3200,
  2300,
  1200,
  0,
  NOW(),
  NOW(),
  NULL,
  jsonb_build_object(
    'configuracion', 'Estándar',
    'incluye_instalacion', false,
    'incluye_mantenimiento', false,
    'disponibilidad', 'En stock',
    'tiempo_entrega_dias', '15-20',
    'garantia_extendida_disponible', true
  )
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  sku = EXCLUDED.sku,
  metadata = EXCLUDED.metadata,
  updated_at = NOW();

-- ============================================
-- PASO 3: CREAR PRECIOS
-- ============================================

-- Precio base sin IVA: USD 28,707
-- IVA 10.5%: USD 3,014.24
-- Precio con IVA: USD 31,721.24

-- Precio en USD
INSERT INTO price (
  id,
  currency_code,
  amount,
  min_quantity,
  max_quantity,
  price_list_id,
  created_at,
  updated_at
)
VALUES (
  'price_cs200s_usd',
  'usd',
  2870700,  -- USD 28,707.00 (sin IVA, en centavos)
  NULL,
  NULL,
  NULL,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  amount = EXCLUDED.amount,
  updated_at = NOW();

-- Vincular precio con variant
INSERT INTO product_variant_price_set (
  id,
  created_at,
  updated_at
)
VALUES (
  'pvps_cs200s',
  NOW(),
  NOW()
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO price_set_money_amount (
  id,
  price_set_id,
  price_list_id,
  title,
  currency_code,
  amount,
  min_quantity,
  max_quantity,
  created_at,
  updated_at
)
VALUES (
  'psma_cs200s_usd',
  'pvps_cs200s',
  NULL,
  'Precio base USD',
  'usd',
  2870700,  -- USD 28,707.00 en centavos
  NULL,
  NULL,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO UPDATE SET
  amount = EXCLUDED.amount,
  updated_at = NOW();

-- Vincular price_set con variant
UPDATE product_variant
SET price_set_id = 'pvps_cs200s'
WHERE id = 'variant_cummins_cs200s_std';

-- ============================================
-- PASO 4: CREAR IMÁGENES
-- ============================================

-- Crear registros de imagen
INSERT INTO image (id, url, created_at, updated_at, deleted_at, metadata)
VALUES
  ('img_cs200s_01', '/productos/cummins/cs200s/CS_200_S_20251014_153804_1.webp', NOW(), NOW(), NULL, '{"alt": "Cummins CS200S - Vista frontal completa", "order": 1}'),
  ('img_cs200s_02', '/productos/cummins/cs200s/CS_200_S_20251014_153804_2.webp', NOW(), NOW(), NULL, '{"alt": "Cummins CS200S - Vista lateral derecha", "order": 2}'),
  ('img_cs200s_03', '/productos/cummins/cs200s/CS_200_S_20251014_153804_3.webp', NOW(), NOW(), NULL, '{"alt": "Cummins CS200S - Panel de control Comap MRS16", "order": 3}'),
  ('img_cs200s_04', '/productos/cummins/cs200s/CS_200_S_20251014_153804_4.webp', NOW(), NOW(), NULL, '{"alt": "Cummins CS200S - Motor Cummins 6CTAA8.3-G", "order": 4}'),
  ('img_cs200s_05', '/productos/cummins/cs200s/CS_200_S_20251014_153804_5.webp', NOW(), NOW(), NULL, '{"alt": "Cummins CS200S - Alternador Stamford UCI274G1", "order": 5}'),
  ('img_cs200s_06', '/productos/cummins/cs200s/CS_200_S_20251014_153804_6.webp', NOW(), NOW(), NULL, '{"alt": "Cummins CS200S - Vista posterior", "order": 6}'),
  ('img_cs200s_07', '/productos/cummins/cs200s/CS_200_S_20251014_153804_7.webp', NOW(), NOW(), NULL, '{"alt": "Cummins CS200S - Detalle cabina insonorizada", "order": 7}'),
  ('img_cs200s_08', '/productos/cummins/cs200s/CS_200_S_20251014_153804_8.webp', NOW(), NOW(), NULL, '{"alt": "Cummins CS200S - Sistema de escape y silenciador", "order": 8}'),
  ('img_cs200s_09', '/productos/cummins/cs200s/CS_200_S_20251014_153804_9.webp', NOW(), NOW(), NULL, '{"alt": "Cummins CS200S - Radiador y sistema de refrigeración", "order": 9}'),
  ('img_cs200s_10', '/productos/cummins/cs200s/CS_200_S_20251014_153804_10.webp', NOW(), NOW(), NULL, '{"alt": "Cummins CS200S - Tanque de combustible 430L", "order": 10}'),
  ('img_cs200s_11', '/productos/cummins/cs200s/CS_200_S_20251014_153804_11.webp', NOW(), NOW(), NULL, '{"alt": "Cummins CS200S - Conexiones eléctricas", "order": 11}'),
  ('img_cs200s_12', '/productos/cummins/cs200s/CS_200_S_20251014_153804_12.webp', NOW(), NOW(), NULL, '{"alt": "Cummins CS200S - Sistema ATS integrado", "order": 12}'),
  ('img_cs200s_13', '/productos/cummins/cs200s/CS_200_S_20251014_153804_13.webp', NOW(), NOW(), NULL, '{"alt": "Cummins CS200S - Vista general instalado", "order": 13}')
ON CONFLICT (id) DO UPDATE SET
  url = EXCLUDED.url,
  metadata = EXCLUDED.metadata,
  updated_at = NOW();

-- Vincular imágenes con producto
INSERT INTO product_images (product_id, image_id)
VALUES
  ('prod_cummins_cs200s', 'img_cs200s_01'),
  ('prod_cummins_cs200s', 'img_cs200s_02'),
  ('prod_cummins_cs200s', 'img_cs200s_03'),
  ('prod_cummins_cs200s', 'img_cs200s_04'),
  ('prod_cummins_cs200s', 'img_cs200s_05'),
  ('prod_cummins_cs200s', 'img_cs200s_06'),
  ('prod_cummins_cs200s', 'img_cs200s_07'),
  ('prod_cummins_cs200s', 'img_cs200s_08'),
  ('prod_cummins_cs200s', 'img_cs200s_09'),
  ('prod_cummins_cs200s', 'img_cs200s_10'),
  ('prod_cummins_cs200s', 'img_cs200s_11'),
  ('prod_cummins_cs200s', 'img_cs200s_12'),
  ('prod_cummins_cs200s', 'img_cs200s_13')
ON CONFLICT (product_id, image_id) DO NOTHING;

-- ============================================
-- PASO 5: ASIGNAR TAXONOMÍA
-- ============================================

-- TYPE (Tipo de Producto)
UPDATE product
SET type_id = 'ptype_generador_diesel'
WHERE id = 'prod_cummins_cs200s';

-- COLLECTION (Familia/Línea)
UPDATE product
SET collection_id = 'pcoll_cummins_cs'
WHERE id = 'prod_cummins_cs200s';

-- CATEGORIES (Categorías por potencia)
INSERT INTO product_category_product (product_category_id, product_id)
VALUES ('pcat_gen_diesel_100_200', 'prod_cummins_cs200s')
ON CONFLICT DO NOTHING;

-- TAGS (Etiquetas)
INSERT INTO product_tags (product_id, product_tag_id)
VALUES
  -- Combustible y motor
  ('prod_cummins_cs200s', 'ptag_diesel'),
  ('prod_cummins_cs200s', 'ptag_cummins'),

  -- Aplicación
  ('prod_cummins_cs200s', 'ptag_industrial'),
  ('prod_cummins_cs200s', 'ptag_estacionario'),

  -- Características
  ('prod_cummins_cs200s', 'ptag_automatico'),
  ('prod_cummins_cs200s', 'ptag_insonorizado'),  -- DIFERENCIA: CS200S es insonorizado (Silent), CS200A no

  -- Configuración eléctrica
  ('prod_cummins_cs200s', 'ptag_trifasico'),

  -- Modo de operación
  ('prod_cummins_cs200s', 'ptag_standby'),
  ('prod_cummins_cs200s', 'ptag_prime'),

  -- Marca alternador
  ('prod_cummins_cs200s', 'ptag_stamford'),

  -- Rango de potencia
  ('prod_cummins_cs200s', 'ptag_100200kva')
ON CONFLICT DO NOTHING;

-- ============================================
-- PASO 6: CREAR SALES CHANNELS
-- ============================================

-- Asignar a canal de ventas por defecto
INSERT INTO product_sales_channel (product_id, sales_channel_id)
SELECT
  'prod_cummins_cs200s',
  id
FROM sales_channel
WHERE name = 'Default Sales Channel'
ON CONFLICT DO NOTHING;

-- ============================================
-- VERIFICACIÓN FINAL
-- ============================================

-- Mostrar resumen del producto creado
SELECT
  '=== PRODUCTO CREADO ===' as seccion,
  p.id,
  p.title,
  p.handle,
  pt.value as tipo,
  pc.title as coleccion,
  COUNT(DISTINCT pcp.product_category_id) as num_categorias,
  COUNT(DISTINCT ptags.product_tag_id) as num_tags,
  COUNT(DISTINCT pi.image_id) as num_imagenes
FROM product p
LEFT JOIN product_type pt ON p.type_id = pt.id
LEFT JOIN product_collection pc ON p.collection_id = pc.id
LEFT JOIN product_category_product pcp ON p.id = pcp.product_id
LEFT JOIN product_tags ptags ON p.id = ptags.product_id
LEFT JOIN product_images pi ON p.id = pi.product_id
WHERE p.id = 'prod_cummins_cs200s'
GROUP BY p.id, p.title, p.handle, pt.value, pc.title;

-- Mostrar variante
SELECT
  '=== VARIANTE ===' as seccion,
  pv.id,
  pv.title,
  pv.sku,
  pv.inventory_quantity as stock
FROM product_variant pv
WHERE pv.product_id = 'prod_cummins_cs200s';

-- Mostrar precios
SELECT
  '=== PRECIOS ===' as seccion,
  psma.currency_code,
  psma.amount / 100.0 as precio_sin_iva,
  (psma.amount * 1.105) / 100.0 as precio_con_iva_10_5
FROM product_variant pv
JOIN product_variant_price_set pvps ON pv.price_set_id = pvps.id
JOIN price_set_money_amount psma ON pvps.id = psma.price_set_id
WHERE pv.product_id = 'prod_cummins_cs200s';

-- Mostrar categorías
SELECT
  '=== CATEGORÍAS ===' as seccion,
  pcat.name as categoria,
  pcat.handle
FROM product_category_product pcp
JOIN product_category pcat ON pcp.product_category_id = pcat.id
WHERE pcp.product_id = 'prod_cummins_cs200s'
ORDER BY pcat.mpath;

-- Mostrar tags
SELECT
  '=== TAGS ===' as seccion,
  string_agg(ptag.value, ', ' ORDER BY ptag.value) as tags
FROM product_tags ptags
JOIN product_tag ptag ON ptags.product_tag_id = ptag.id
WHERE ptags.product_id = 'prod_cummins_cs200s';

-- Mostrar imágenes
SELECT
  '=== IMÁGENES ===' as seccion,
  COUNT(*) as total_imagenes,
  string_agg(i.url, E'\n' ORDER BY (i.metadata->>'order')::int) as urls
FROM product_images pi
JOIN image i ON pi.image_id = i.id
WHERE pi.product_id = 'prod_cummins_cs200s';

-- Verificar campos de metadata clave
SELECT
  '=== METADATA CLAVE ===' as seccion,
  jsonb_object_keys(metadata) as campo,
  metadata->>jsonb_object_keys(metadata) as valor
FROM product
WHERE id = 'prod_cummins_cs200s'
ORDER BY campo;

-- ============================================
-- RESULTADO ESPERADO
-- ============================================
-- ✅ Producto creado: prod_cummins_cs200s
-- ✅ Título: CUMMINS CS200S - Generador Diesel Industrial 200 KVA
-- ✅ Handle: cummins-cs200s
-- ✅ Tipo: Generador Diesel
-- ✅ Colección: Generadores Cummins - Línea CS
-- ✅ Categorías: 1 (100 a 200 KVA)
-- ✅ Tags: 11 (diesel, cummins, industrial, estacionario, automatico,
--              insonorizado, trifasico, standby, prime, stamford, 100-200kva)
-- ✅ Imágenes: 13 imágenes
-- ✅ Precio: USD 28,707 (sin IVA) / USD 31,721.24 (con IVA 10.5%)
-- ✅ Metadata: 60+ campos completos
-- ✅ Variant: 1 configuración estándar
-- ✅ Stock: 5 unidades disponibles
--
-- DIFERENCIAS CON CS200A:
-- • CS200S tiene tag "insonorizado" (Silent - 71dB)
-- • CS200A NO tiene tag "insonorizado" (sin cabina - 95dB)
-- • CS200S pesa 2500 kg (con cabina)
-- • CS200A pesa 1900 kg (sin cabina)
-- • CS200S: USD 28,707
-- • CS200A: USD 26,411
-- • Diferencia: +USD 2,296 por cabina insonorizada
-- ============================================

RAISE NOTICE '============================================';
RAISE NOTICE 'IMPORTACIÓN COMPLETA CS200S FINALIZADA';
RAISE NOTICE '============================================';
RAISE NOTICE 'Producto: CUMMINS CS200S';
RAISE NOTICE 'Handle: cummins-cs200s';
RAISE NOTICE 'Precio: USD 28,707 (sin IVA)';
RAISE NOTICE 'Precio con IVA 10.5%%: USD 31,721.24';
RAISE NOTICE 'Stock: 5 unidades';
RAISE NOTICE 'Imágenes: 13';
RAISE NOTICE 'Tags: 11 (incluye insonorizado)';
RAISE NOTICE '============================================';
RAISE NOTICE 'Verificar en: http://localhost:9000/products/cummins-cs200s';
RAISE NOTICE '============================================';
