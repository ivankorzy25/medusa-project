-- =========================================================================
-- IMPORTAR CS200S COMPLETO - SIGUIENDO ESTRUCTURA EXACTA DE CS200A
-- =========================================================================
-- PRODUCTO DE REFERENCIA: CS200A (estructura EXACTA con metadata duplicada)
-- DATOS TÉCNICOS: Carpeta CS200S + Lista de Precios PDF
-- DIFERENCIA CLAVE: CS200S es modelo SILENT/INSONORIZADO (71 dB)
-- =========================================================================

DO $$
DECLARE
  v_product_id text;
  v_variant_id text;
  v_price_set_id text;
  v_price_usd_id text;
  v_price_ars_id text;
  v_image_id text;
  v_region_id text;
BEGIN
  -- =========================================================================
  -- GENERAR IDs
  -- =========================================================================
  v_product_id := 'prod_cs200s_' || gen_random_uuid()::text;
  v_variant_id := 'variant_cs200s_' || gen_random_uuid()::text;
  v_price_set_id := 'pset_cs200s_' || gen_random_uuid()::text;
  v_price_usd_id := 'price_usd_cs200s_' || gen_random_uuid()::text;
  v_price_ars_id := 'price_ars_cs200s_' || gen_random_uuid()::text;

  RAISE NOTICE '';
  RAISE NOTICE '=== IMPORTANDO CS200S - MODELO SILENT ===';
  RAISE NOTICE 'Product ID: %', v_product_id;
  RAISE NOTICE '';

  -- =========================================================================
  -- INSERTAR PRODUCTO (con metadata DUPLICADA igual que CS200A)
  -- =========================================================================
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
    updated_at,
    metadata
  ) VALUES (
    v_product_id,
    'Generador Cummins CS200S - 200 KVA Silent',
    '200 KVA Standby / 180 KVA Prime - Insonorizado 71 dB',
    'Generador industrial Cummins CS200S de 200 KVA en modalidad Standby y 180 KVA en modalidad Prime. Motor Cummins 6CTA83G2 TDI de 8.3 litros turboalimentado e intercooled, 6 cilindros en línea. Alternador Stamford UCI274G1 sin escobillas. Panel de control digital ComAp InteliLite MRS16 con arranque automático. Cabina insonorizada premium con nivel de ruido de 71 dB a 7 metros. Tanque de combustible de 430 litros con autonomía de 12.3 horas al 75% de carga. Refrigeración por agua. Dimensiones: 3230 x 1170 x 1800 mm. Peso operativo: 2880 kg. Ideal para aplicaciones industriales, comerciales y residenciales que requieren bajo nivel de ruido.',
    'cummins-cs200s',
    false,
    'http://localhost:9000/static/CS 200 S_20251014_153804_6.webp',
    'published',
    'ptyp_generadores',
    'pcol_cummins_cs',
    NOW(),
    NOW(),
    '{"pricing_config": {"familia": "Generadores Cummins - Línea CS", "currency_type": "usd_blue", "iva_percentage": 10.5, "precio_lista_usd": 28707, "bonificacion_percentage": 11, "descuento_contado_percentage": 9}, "fases": "Trifásico", "voltaje": "220/380V", "motor_rpm": 1500, "motor_marca": "Cummins", "motor_modelo": "6CTA83G2 TDI", "vendor": "Cummins Power Generation", "trust": "Oficial", "ubicacion": "Disponible", "garantia": "12 meses", "aplicacion": "Industrial, Comercial, Residencial Premium", "tipo_uso": "Standby / Prime Power", "insonorizado": "Sí - 71 dB @ 7m", "cabina": "Silent Premium"}'::jsonb
  );

  RAISE NOTICE '✅ Producto CS200S creado';

  -- =========================================================================
  -- INSERTAR VARIANT (con metadata DUPLICADA + especificaciones_tecnicas)
  -- =========================================================================
  INSERT INTO product_variant (
    id,
    title,
    product_id,
    sku,
    barcode,
    ean,
    upc,
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
    created_at,
    updated_at,
    metadata
  ) VALUES (
    v_variant_id,
    'Cummins CS200S - 200 KVA Silent',
    v_product_id,
    'GEN-CS200S',
    NULL,
    NULL,
    NULL,
    false,
    true,
    '850211',
    'China',
    'GEN-CS200S',
    NULL,
    2450000,
    3230,
    1800,
    1170,
    NOW(),
    NOW(),
    '{"pricing_config": {"familia": "Generadores Cummins - Línea CS", "currency_type": "usd_blue", "iva_percentage": 10.5, "precio_lista_usd": 28707, "bonificacion_percentage": 11, "descuento_contado_percentage": 9}, "especificaciones_tecnicas": {"potencia": {"standby_kva": 200, "standby_kw": 160, "prime_kva": 180, "prime_kw": 144, "factor_potencia": 0.8, "tension": "380/220V", "frecuencia": "50 Hz", "fases": 3}, "motor": {"marca": "Cummins", "modelo": "6CTA83G2 TDI", "tipo": "Diesel 4 tiempos, Turbo Diesel Intercooled", "cilindros": 6, "cilindrada_litros": 8.3, "potencia_hp": 241, "potencia_kw": 180, "velocidad_rpm": 1500, "consumo_75_lh": 35, "consumo_100_lh": 45, "capacidad_aceite_litros": 24, "refrigeracion": "Por agua", "turboalimentado": true}, "alternador": {"marca": "Stamford", "modelo": "UCI274G1", "tipo": "Sin escobillas (Brushless)", "excitacion": "Autoexcitado"}, "panel_control": {"marca": "ComAp", "modelo": "InteliLite MRS16", "tipo": "Digital LCD", "arranque_automatico": true, "caracteristicas": ["Tablero digital", "Auto-start", "Parada de emergencia"]}, "combustible": {"tipo": "Diesel", "capacidad_tanque_litros": 430, "autonomia_75_horas": 12.3, "autonomia_100_horas": 10}, "insonorizacion": {"cabina": "Silent Premium", "nivel_ruido_db": 71, "distancia_metros": 7}, "dimensiones": {"largo_mm": 3230, "ancho_mm": 1170, "alto_mm": 1800, "peso_kg": 2450, "peso_operativo_kg": 2880}, "caracteristicas_principales": ["Motor Cummins turboalimentado", "Alternador Stamford brushless", "Cabina insonorizada 71 dB", "Panel de control digital ComAp", "Arranque automático", "Tanque de 430 litros", "Autonomía 12+ horas"]}}'::jsonb
  );

  RAISE NOTICE '✅ Variant CS200S creado con dimensiones y metadata completa';

  -- =========================================================================
  -- CREAR PRICE SET Y PRECIOS (USD y ARS)
  -- =========================================================================
  SELECT id INTO v_region_id FROM region WHERE name = 'Argentina' LIMIT 1;

  INSERT INTO price_set (id, created_at, updated_at)
  VALUES (v_price_set_id, NOW(), NOW());

  INSERT INTO price (id, price_set_id, currency_code, amount, raw_amount, created_at, updated_at)
  VALUES (v_price_usd_id, v_price_set_id, 'usd', 2870700, '{"value": "2870700"}'::jsonb, NOW(), NOW());

  INSERT INTO price (id, price_set_id, currency_code, amount, raw_amount, created_at, updated_at)
  VALUES (v_price_ars_id, v_price_set_id, 'ars', 3960834400, '{"value": "3960834400"}'::jsonb, NOW(), NOW());

  INSERT INTO product_variant_price_set (id, variant_id, price_set_id, created_at, updated_at)
  VALUES (gen_random_uuid()::text, v_variant_id, v_price_set_id, NOW(), NOW());

  RAISE NOTICE '✅ Precios configurados (USD 28,707)';

  -- =========================================================================
  -- ASIGNAR SALES CHANNEL (CRÍTICO)
  -- =========================================================================
  INSERT INTO product_sales_channel (id, product_id, sales_channel_id, created_at, updated_at)
  VALUES (gen_random_uuid()::text, v_product_id, 'sc_01K9FZ84KQM1PG94Q6YT6248EW', NOW(), NOW());

  RAISE NOTICE '✅ Sales Channel asignado';

  -- =========================================================================
  -- ASIGNAR CATEGORÍA (100-200 KVA)
  -- =========================================================================
  INSERT INTO product_category_product (product_category_id, product_id)
  VALUES ('pcat_gen_diesel_100_200', v_product_id);

  RAISE NOTICE '✅ Categoría asignada';

  -- =========================================================================
  -- ASIGNAR TAGS (11 tags: 10 comunes + insonorizado)
  -- =========================================================================
  INSERT INTO product_tags (product_id, product_tag_id) VALUES
    (v_product_id, 'ptag_diesel'),
    (v_product_id, 'ptag_cummins'),
    (v_product_id, 'ptag_industrial'),
    (v_product_id, 'ptag_estacionario'),
    (v_product_id, 'ptag_automatico'),
    (v_product_id, 'ptag_trifasico'),
    (v_product_id, 'ptag_standby'),
    (v_product_id, 'ptag_prime'),
    (v_product_id, 'ptag_stamford'),
    (v_product_id, 'ptag_100200kva'),
    (v_product_id, 'ptag_insonorizado');

  RAISE NOTICE '✅ 11 Tags asignados (incluido insonorizado)';

  -- =========================================================================
  -- INSERTAR IMÁGENES (13 imágenes ordenadas por tamaño)
  -- =========================================================================
  v_image_id := substring(md5(random()::text) from 1 for 6);
  INSERT INTO image (id, url, rank, product_id, created_at, updated_at)
  VALUES (v_image_id, 'http://localhost:9000/static/CS 200 S_20251014_153804_6.webp', 1, v_product_id, NOW(), NOW());

  v_image_id := substring(md5(random()::text) from 1 for 6);
  INSERT INTO image (id, url, rank, product_id, created_at, updated_at)
  VALUES (v_image_id, 'http://localhost:9000/static/CS 200 S_20251014_153804_4.webp', 2, v_product_id, NOW(), NOW());

  v_image_id := substring(md5(random()::text) from 1 for 6);
  INSERT INTO image (id, url, rank, product_id, created_at, updated_at)
  VALUES (v_image_id, 'http://localhost:9000/static/CS 200 S_20251014_153804_1.webp', 3, v_product_id, NOW(), NOW());

  v_image_id := substring(md5(random()::text) from 1 for 6);
  INSERT INTO image (id, url, rank, product_id, created_at, updated_at)
  VALUES (v_image_id, 'http://localhost:9000/static/CS 200 S_20251014_153804_2.webp', 4, v_product_id, NOW(), NOW());

  v_image_id := substring(md5(random()::text) from 1 for 6);
  INSERT INTO image (id, url, rank, product_id, created_at, updated_at)
  VALUES (v_image_id, 'http://localhost:9000/static/CS 200 S_20251014_153804_12.webp', 5, v_product_id, NOW(), NOW());

  v_image_id := substring(md5(random()::text) from 1 for 6);
  INSERT INTO image (id, url, rank, product_id, created_at, updated_at)
  VALUES (v_image_id, 'http://localhost:9000/static/CS 200 S_20251014_153804_5.webp', 6, v_product_id, NOW(), NOW());

  v_image_id := substring(md5(random()::text) from 1 for 6);
  INSERT INTO image (id, url, rank, product_id, created_at, updated_at)
  VALUES (v_image_id, 'http://localhost:9000/static/CS 200 S_20251014_153804_10.webp', 7, v_product_id, NOW(), NOW());

  v_image_id := substring(md5(random()::text) from 1 for 6);
  INSERT INTO image (id, url, rank, product_id, created_at, updated_at)
  VALUES (v_image_id, 'http://localhost:9000/static/CS 200 S_20251014_153804_8.webp', 8, v_product_id, NOW(), NOW());

  v_image_id := substring(md5(random()::text) from 1 for 6);
  INSERT INTO image (id, url, rank, product_id, created_at, updated_at)
  VALUES (v_image_id, 'http://localhost:9000/static/CS 200 S_20251014_153804_9.webp', 9, v_product_id, NOW(), NOW());

  v_image_id := substring(md5(random()::text) from 1 for 6);
  INSERT INTO image (id, url, rank, product_id, created_at, updated_at)
  VALUES (v_image_id, 'http://localhost:9000/static/CS 200 S_20251014_153804_7.webp', 10, v_product_id, NOW(), NOW());

  v_image_id := substring(md5(random()::text) from 1 for 6);
  INSERT INTO image (id, url, rank, product_id, created_at, updated_at)
  VALUES (v_image_id, 'http://localhost:9000/static/CS 200 S_20251014_153804_13.webp', 11, v_product_id, NOW(), NOW());

  v_image_id := substring(md5(random()::text) from 1 for 6);
  INSERT INTO image (id, url, rank, product_id, created_at, updated_at)
  VALUES (v_image_id, 'http://localhost:9000/static/CS 200 S_20251014_153804_11.webp', 12, v_product_id, NOW(), NOW());

  v_image_id := substring(md5(random()::text) from 1 for 6);
  INSERT INTO image (id, url, rank, product_id, created_at, updated_at)
  VALUES (v_image_id, 'http://localhost:9000/static/CS 200 S_20251014_153804_3.webp', 13, v_product_id, NOW(), NOW());

  RAISE NOTICE '✅ 13 Imágenes insertadas';

  RAISE NOTICE '';
  RAISE NOTICE '╔════════════════════════════════════════════════════════════╗';
  RAISE NOTICE '║         CS200S IMPORTADO EXITOSAMENTE                      ║';
  RAISE NOTICE '╚════════════════════════════════════════════════════════════╝';
  RAISE NOTICE '';
  RAISE NOTICE '📦 Handle: cummins-cs200s';
  RAISE NOTICE '⚙️  SKU: GEN-CS200S';
  RAISE NOTICE '💰 Precio: USD 28,707';
  RAISE NOTICE '🔧 Potencia: 200 KVA Standby / 180 KVA Prime';
  RAISE NOTICE '🔇 Insonorizado: 71 dB @ 7m';
  RAISE NOTICE '🏷️  Tags: 11 (incluido insonorizado)';
  RAISE NOTICE '🖼️  Imágenes: 13';
  RAISE NOTICE '';
  RAISE NOTICE '🌐 Frontend: http://localhost:3000/producto/cummins-cs200s';
  RAISE NOTICE '';
END $$;

-- Verificación
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
WHERE p.handle = 'cummins-cs200s'
GROUP BY p.handle, pv.weight, pv.hs_code, pv.mid_code, pv.origin_country, pv.metadata;
