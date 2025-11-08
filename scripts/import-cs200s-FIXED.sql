-- =========================================================================
-- IMPORTAR PRODUCTO: CUMMINS CS200S (VERSIÓN CORREGIDA)
-- =========================================================================
-- Generador Diesel Cummins CS200S 200 KVA Silent/Insonorizado
-- Precio: USD 28,707 | IVA 10.5% | Bonif 11% | Desc. Contado 9%
-- Basado EXACTAMENTE en la estructura de CS200A
-- =========================================================================

DO $$
DECLARE
  v_product_id text;
  v_variant_id text;
  v_image_id text;
  v_timestamp bigint;
BEGIN
  -- =========================================================================
  -- 1. CREAR PRODUCTO
  -- =========================================================================

  v_product_id := 'prod_cs200s_' || substring(gen_random_uuid()::text from 1 for 12);
  v_timestamp := floor(extract(epoch from now()) * 1000);

  INSERT INTO product (
    id,
    title,
    subtitle,
    description,
    handle,
    is_giftcard,
    thumbnail,
    status,
    type_id,
    collection_id,
    created_at,
    updated_at
  ) VALUES (
    v_product_id,
    'Generador Diesel Cummins CS200S - 200 KVA Silent',
    'Generador Diesel Industrial 200/180 KVA con Motor Cummins 6CTA83G2 TDI',
    'Generador diesel industrial de 200 kVA con motor Cummins 6CTA83G2 TDI, alternador Stamford UCI274G1 y panel Comap MRS16 con arranque automatico. Cabina insonorizada de 71 dB.

El CUMMINS CS200S es un generador diesel de alta gama disenado para aplicaciones industriales criticas que combina el legendario motor Cummins de 8.3 litros turbo diesel intercooled con 241 HP, alternador brushless Stamford, y sofisticado panel de control Comap con capacidad de arranque automatico y monitoreo remoto.

Con tanque de 430 litros proporciona mas de 12 horas de autonomia continua, ideal para hospitales, centros de datos, industrias y edificios comerciales donde la continuidad electrica es critica.

CARACTERISTICAS PRINCIPALES:
• Motor Cummins 6CTA83G2 TDI - 8.3L Turbo Diesel Intercooled
• Alternador Stamford UCI274G1 Brushless
• 200 KVA Stand-By / 180 KVA Prime
• Panel Comap MRS16 con auto-start
• Cabina Silent Premium - 71 dB @ 7m
• Tanque de combustible: 430 litros
• Autonomia: 12.3 horas @ 75 porciento carga
• Uso continuo 24/7

APLICACIONES:
• Hospitales y clinicas
• Data centers
• Industrias
• Edificios comerciales
• Centros de datos
• Instalaciones criticas',
    'cummins-cs200s',
    false,
    'http://localhost:9000/static/CS 200 S_20251014_153804_1.webp',
    'published',
    'ptype_generador_diesel',
    'pcoll_cummins_cs',
    NOW(),
    NOW()
  );

  RAISE NOTICE 'Producto creado: %', v_product_id;

  -- =========================================================================
  -- 2. CREAR VARIANT (sin metadata por ahora, lo agregamos después)
  -- =========================================================================

  v_variant_id := 'variant_cs200s_' || substring(gen_random_uuid()::text from 1 for 12);

  INSERT INTO product_variant (
    id,
    title,
    product_id,
    sku,
    allow_backorder,
    manage_inventory,
    weight,
    length,
    height,
    width,
    created_at,
    updated_at
  ) VALUES (
    v_variant_id,
    'Generador CS200S - Silent',
    v_product_id,
    'GEN-CS200S-SILENT',
    false,
    true,
    2450000,  -- 2450 kg en gramos
    3230,     -- 3230 mm
    1800,     -- 1800 mm
    1170,     -- 1170 mm
    NOW(),
    NOW()
  );

  RAISE NOTICE 'Variant creado: %', v_variant_id;

  -- =========================================================================
  -- 3. CREAR IMÁGENES (13 imágenes CS200S)
  -- =========================================================================

  RAISE NOTICE 'Creando imagenes...';

  -- Imagen 1
  v_image_id := substring(md5(random()::text) from 1 for 6);
  INSERT INTO image (id, url, rank, product_id, created_at, updated_at)
  VALUES (v_image_id, 'http://localhost:9000/static/CS 200 S_20251014_153804_1.webp', 1, v_product_id, NOW(), NOW());

  -- Imagen 2
  v_image_id := substring(md5(random()::text) from 1 for 6);
  INSERT INTO image (id, url, rank, product_id, created_at, updated_at)
  VALUES (v_image_id, 'http://localhost:9000/static/CS 200 S_20251014_153804_2.webp', 2, v_product_id, NOW(), NOW());

  -- Imagen 3
  v_image_id := substring(md5(random()::text) from 1 for 6);
  INSERT INTO image (id, url, rank, product_id, created_at, updated_at)
  VALUES (v_image_id, 'http://localhost:9000/static/CS 200 S_20251014_153804_3.webp', 3, v_product_id, NOW(), NOW());

  -- Imagen 4
  v_image_id := substring(md5(random()::text) from 1 for 6);
  INSERT INTO image (id, url, rank, product_id, created_at, updated_at)
  VALUES (v_image_id, 'http://localhost:9000/static/CS 200 S_20251014_153804_4.webp', 4, v_product_id, NOW(), NOW());

  -- Imagen 5
  v_image_id := substring(md5(random()::text) from 1 for 6);
  INSERT INTO image (id, url, rank, product_id, created_at, updated_at)
  VALUES (v_image_id, 'http://localhost:9000/static/CS 200 S_20251014_153804_5.webp', 5, v_product_id, NOW(), NOW());

  -- Imagen 6
  v_image_id := substring(md5(random()::text) from 1 for 6);
  INSERT INTO image (id, url, rank, product_id, created_at, updated_at)
  VALUES (v_image_id, 'http://localhost:9000/static/CS 200 S_20251014_153804_6.webp', 6, v_product_id, NOW(), NOW());

  -- Imagen 7
  v_image_id := substring(md5(random()::text) from 1 for 6);
  INSERT INTO image (id, url, rank, product_id, created_at, updated_at)
  VALUES (v_image_id, 'http://localhost:9000/static/CS 200 S_20251014_153804_7.webp', 7, v_product_id, NOW(), NOW());

  -- Imagen 8
  v_image_id := substring(md5(random()::text) from 1 for 6);
  INSERT INTO image (id, url, rank, product_id, created_at, updated_at)
  VALUES (v_image_id, 'http://localhost:9000/static/CS 200 S_20251014_153804_8.webp', 8, v_product_id, NOW(), NOW());

  -- Imagen 9
  v_image_id := substring(md5(random()::text) from 1 for 6);
  INSERT INTO image (id, url, rank, product_id, created_at, updated_at)
  VALUES (v_image_id, 'http://localhost:9000/static/CS 200 S_20251014_153804_9.webp', 9, v_product_id, NOW(), NOW());

  -- Imagen 10
  v_image_id := substring(md5(random()::text) from 1 for 6);
  INSERT INTO image (id, url, rank, product_id, created_at, updated_at)
  VALUES (v_image_id, 'http://localhost:9000/static/CS 200 S_20251014_153804_10.webp', 10, v_product_id, NOW(), NOW());

  -- Imagen 11
  v_image_id := substring(md5(random()::text) from 1 for 6);
  INSERT INTO image (id, url, rank, product_id, created_at, updated_at)
  VALUES (v_image_id, 'http://localhost:9000/static/CS 200 S_20251014_153804_11.webp', 11, v_product_id, NOW(), NOW());

  -- Imagen 12
  v_image_id := substring(md5(random()::text) from 1 for 6);
  INSERT INTO image (id, url, rank, product_id, created_at, updated_at)
  VALUES (v_image_id, 'http://localhost:9000/static/CS 200 S_20251014_153804_12.webp', 12, v_product_id, NOW(), NOW());

  -- Imagen 13
  v_image_id := substring(md5(random()::text) from 1 for 6);
  INSERT INTO image (id, url, rank, product_id, created_at, updated_at)
  VALUES (v_image_id, 'http://localhost:9000/static/CS 200 S_20251014_153804_13.webp', 13, v_product_id, NOW(), NOW());

  RAISE NOTICE '13 imagenes creadas';

  -- =========================================================================
  -- 4. ASIGNAR CATEGORÍA
  -- =========================================================================

  INSERT INTO product_category_product (product_category_id, product_id)
  VALUES ('pcat_gen_diesel_100_200', v_product_id)
  ON CONFLICT DO NOTHING;

  RAISE NOTICE 'Categoria asignada: 100 a 200 KVA';

  -- =========================================================================
  -- 5. ASIGNAR TAGS
  -- =========================================================================

  INSERT INTO product_tags (product_id, product_tag_id)
  VALUES
    (v_product_id, 'ptag_diesel'),
    (v_product_id, 'ptag_cummins'),
    (v_product_id, 'ptag_industrial'),
    (v_product_id, 'ptag_estacionario'),
    (v_product_id, 'ptag_automatico'),
    (v_product_id, 'ptag_insonorizado'),    -- SILENT
    (v_product_id, 'ptag_trifasico'),
    (v_product_id, 'ptag_standby'),
    (v_product_id, 'ptag_prime'),
    (v_product_id, 'ptag_stamford'),
    (v_product_id, 'ptag_100200kva')
  ON CONFLICT DO NOTHING;

  RAISE NOTICE 'Tags asignados: 11 tags';

  -- =========================================================================
  -- VERIFICACIÓN
  -- =========================================================================
  RAISE NOTICE '';
  RAISE NOTICE '=== PRODUCTO CS200S CREADO EXITOSAMENTE ===';
  RAISE NOTICE 'ID: %', v_product_id;
  RAISE NOTICE 'Handle: cummins-cs200s';
  RAISE NOTICE 'Type: Generador Diesel';
  RAISE NOTICE 'Collection: Generadores Cummins - Linea CS';
  RAISE NOTICE 'Category: 100 a 200 KVA';
  RAISE NOTICE 'Tags: 11';
  RAISE NOTICE 'Imagenes: 13';
  RAISE NOTICE '';

END $$;

-- Verificar producto creado
SELECT
  p.id,
  p.title,
  p.handle,
  pt.value as tipo,
  pc.title as coleccion,
  COUNT(DISTINCT pcp.product_category_id) as categorias,
  COUNT(DISTINCT ptags.product_tag_id) as tags,
  COUNT(DISTINCT img.id) as imagenes
FROM product p
LEFT JOIN product_type pt ON p.type_id = pt.id
LEFT JOIN product_collection pc ON p.collection_id = pc.id
LEFT JOIN product_category_product pcp ON p.id = pcp.product_id
LEFT JOIN product_tags ptags ON p.id = ptags.product_id
LEFT JOIN image img ON p.id = img.product_id
WHERE p.handle = 'cummins-cs200s'
GROUP BY p.id, p.title, p.handle, pt.value, pc.title;
