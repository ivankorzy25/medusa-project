-- =========================================================================
-- CREAR CS200S-V2 COMPLETO - ESTRUCTURA TOTAL SIGUIENDO CS200A
-- =========================================================================
-- Basado en la estructura COMPLETA de CS200A del PDF de referencia
-- Incluye TODA la metadata necesaria para el frontend
-- =========================================================================

DO $$
DECLARE
  v_product_id text;
  v_variant_id text;
  v_price_set_id text;
  v_price_usd_id text;
  v_price_ars_id text;
  v_image_id text;
BEGIN
  -- IDs
  v_product_id := 'prod_cs200sv2_' || gen_random_uuid()::text;
  v_variant_id := 'variant_cs200sv2_' || gen_random_uuid()::text;
  v_price_set_id := 'pset_cs200sv2_' || gen_random_uuid()::text;
  v_price_usd_id := 'price_usd_cs200sv2_' || gen_random_uuid()::text;
  v_price_ars_id := 'price_ars_cs200sv2_' || gen_random_uuid()::text;

  RAISE NOTICE '';
  RAISE NOTICE '╔════════════════════════════════════════════════════════════╗';
  RAISE NOTICE '║   IMPORTANDO CS200S-V2 CON ESTRUCTURA COMPLETA             ║';
  RAISE NOTICE '╚════════════════════════════════════════════════════════════╝';
  RAISE NOTICE '';

  -- =========================================================================
  -- 1. INSERTAR PRODUCT CON METADATA COMPLETA
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
    'Generador Diesel Cummins CS200S - 200 KVA Stand-By / 180 KVA Prime',
    'Motor Cummins 6CTA83G2 TDI + Alternador Stamford UCI274G1 - Insonorizado 71 dB',
    'Generador industrial diesel Cummins CS200S de 200 KVA Stand-By / 180 KVA Prime.

Equipado con motor Cummins 6CTA83G2 TDI de 1500 RPM turboalimentado e intercooled, y alternador Stamford UCI274G1 brushless.

Ideal para uso continuo 24/7 en aplicaciones industriales, comerciales y residenciales de alta potencia que requieren bajo nivel de ruido.

Panel de control ComAp InteliLite MRS16 con función auto-start. Refrigeración líquida.

Cabina insonorizada premium - 71 dB @ 7 metros.

Diseñado para máxima confiabilidad y bajo costo operativo.

CARACTERÍSTICAS PRINCIPALES:
• Motor Cummins 6CTA83G2 TDI - 1500 RPM
• Alternador Stamford UCI274G1
• 200 KVA Stand-By / 180 KVA Prime
• Panel ComAp InteliLite MRS16 con auto-start
• Cabina Silent Premium - 71 dB @ 7m
• Refrigeración líquida
• Tanque de combustible: 430 litros
• Consumo a 75% carga: 35 L/h
• Autonomía: 12.3 horas
• Uso continuo 24/7

APLICACIONES:
• Industrias
• Comercios de alta potencia
• Edificios residenciales
• Hospitales y clínicas
• Data centers
• Zonas sin red eléctrica',
    'cummins-cs200s-v2',
    false,
    'http://localhost:9000/static/CS 200 S_20251014_153804_6.webp',
    'published',
    'ptype_generador_diesel',
    'pcoll_cummins_cs',
    NOW(),
    NOW(),
    '{
      "pricing_config": {
        "familia": "Generadores Cummins - Línea CS",
        "currency_type": "usd_blue",
        "iva_percentage": 10.5,
        "precio_lista_usd": 28707,
        "bonificacion_percentage": 11,
        "contado_descuento_percentage": 9
      },
      "fases": "Trifásico",
      "voltaje": "220/380V",
      "categoria": "Generadores Diesel",
      "motor_rpm": 1500,
      "tiene_tta": "opcional",
      "documentos": [],
      "frecuencia": "50/60Hz",
      "motor_ciclo": "4 tiempos",
      "motor_marca": "Cummins",
      "motor_modelo": "6CTA83G2 TDI",
      "tiene_cabina": true,
      "total_ventas": 0,
      "tipo_arranque": "Eléctrico",
      "total_reviews": 0,
      "vendor_nombre": "KOR",
      "vendor_rating": 5,
      "es_mas_vendido": false,
      "nivel_ruido_db": 71,
      "stock_cantidad": 1,
      "ubicacion_pais": "Argentina",
      "voltaje_salida": "220/380V",
      "estado_producto": "Nuevo",
      "factor_potencia": 0.8,
      "motor_cilindros": 6,
      "precio_anterior": null,
      "rating_promedio": 0,
      "ubicacion_envio": {
        "ciudad": "Florida",
        "provincia": "Buenos Aires",
        "texto_completo": "Florida, Buenos Aires"
      },
      "alternador_marca": "Stamford",
      "combustible_tipo": "Diesel",
      "motor_aspiracion": "Turbo Diesel Intercooled",
      "stock_disponible": true,
      "ubicacion_ciudad": "Florida",
      "alternador_modelo": "UCI274G1",
      "potencia_prime_kw": 144,
      "trust_envio_texto": "Envío gratis",
      "potencia_prime_kva": 180,
      "tipo_refrigeracion": "Agua",
      "trust_envio_gratis": true,
      "vendor_descripcion": "Especialistas en generación de energía eléctrica y grupos electrógenos industriales. Venta, alquiler y servicio técnico multimarca.",
      "insonorizacion_tipo": "Silent Premium",
      "motor_refrigeracion": "Agua",
      "panel_control_marca": "ComAp",
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
      ],
      "potencia_standby_kw": 160,
      "potencia_standby_kva": 200,
      "alternador_excitacion": "Autoexcitado",
      "capacidad_tanque_litros": 430,
      "es_recien_llegado": true,
      "panel_control_modelo": "InteliLite MRS16",
      "trust_garantia_oficial": true,
      "ubicacion_provincia": "Buenos Aires",
      "ubicacion_localidad": "Florida",
      "panel_control_auto_start": true,
      "trust_garantia_texto": "Garantía oficial",
      "vendor_anos_experiencia": 15,
      "motor_tipo_configuracion": "6 cilindros En línea",
      "autonomia_75_carga_horas": 12.3,
      "consumo_75_carga_lh": 35,
      "motor_cilindrada_litros": 8.3,
      "trust_stock_disponible": true,
      "vendor_tiempo_respuesta": "Dentro de 24hs",
      "motor_turboalimentado": true,
      "nivel_ruido_distancia_metros": 7,
      "dimensiones_largo_cm": 323,
      "dimensiones_ancho_cm": 117,
      "dimensiones_alto_cm": 180,
      "peso_seco_kg": 2450,
      "peso_operativo_kg": 2880,
      "badge_insonorizado": true,
      "badge_nuevo": true
    }'::jsonb
  );

  RAISE NOTICE '✅ Product CS200S-V2 creado con metadata completa';

  -- =========================================================================
  -- 2. INSERTAR VARIANT CON ESPECIFICACIONES TÉCNICAS
  -- =========================================================================
  INSERT INTO product_variant (
    id,
    title,
    product_id,
    sku,
    allow_backorder,
    manage_inventory,
    hs_code,
    origin_country,
    mid_code,
    weight,
    length,
    height,
    width,
    created_at,
    updated_at,
    metadata
  ) VALUES (
    v_variant_id,
    'Cummins CS200S - 200 KVA Stand-By / 180 KVA Prime - Silent',
    v_product_id,
    'GEN-CS200S-STD',
    false,
    true,
    '850211',
    'China',
    'GEN-CS200S',
    2450000,  -- 2450 kg
    3230,     -- 3230 mm
    1800,     -- 1800 mm
    1170,     -- 1170 mm
    NOW(),
    NOW(),
    '{
      "pricing_config": {
        "familia": "Generadores Cummins - Línea CS",
        "currency_type": "usd_blue",
        "iva_percentage": 10.5,
        "precio_lista_usd": 28707,
        "bonificacion_percentage": 11,
        "descuento_contado_percentage": 9
      },
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
        "insonorizacion": {
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
    }'::jsonb
  );

  RAISE NOTICE '✅ Variant CS200S-V2 creado';

  -- =========================================================================
  -- 3. CREAR PRECIOS
  -- =========================================================================
  INSERT INTO price_set (id, created_at, updated_at)
  VALUES (v_price_set_id, NOW(), NOW());

  INSERT INTO price (id, price_set_id, currency_code, amount, raw_amount, created_at, updated_at)
  VALUES (v_price_usd_id, v_price_set_id, 'usd', 2870700, '{"value": "2870700"}'::jsonb, NOW(), NOW());

  INSERT INTO price (id, price_set_id, currency_code, amount, raw_amount, created_at, updated_at)
  VALUES (v_price_ars_id, v_price_set_id, 'ars', 3960834400, '{"value": "3960834400"}'::jsonb, NOW(), NOW());

  INSERT INTO product_variant_price_set (id, variant_id, price_set_id, created_at, updated_at)
  VALUES (gen_random_uuid()::text, v_variant_id, v_price_set_id, NOW(), NOW());

  RAISE NOTICE '✅ Precios configurados';

  -- =========================================================================
  -- 4. SALES CHANNEL
  -- =========================================================================
  INSERT INTO product_sales_channel (id, product_id, sales_channel_id, created_at, updated_at)
  VALUES (gen_random_uuid()::text, v_product_id, 'sc_01K9FZ84KQM1PG94Q6YT6248EW', NOW(), NOW());

  RAISE NOTICE '✅ Sales Channel asignado';

  -- =========================================================================
  -- 5. CATEGORÍA
  -- =========================================================================
  INSERT INTO product_category_product (product_category_id, product_id)
  VALUES ('pcat_gen_diesel_100_200', v_product_id);

  RAISE NOTICE '✅ Categoría asignada';

  -- =========================================================================
  -- 6. TAGS
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

  RAISE NOTICE '✅ 11 Tags asignados';

  -- =========================================================================
  -- 7. IMÁGENES (13 imágenes ordenadas por tamaño)
  -- =========================================================================
  v_image_id := substring(md5(random()::text) from 1 for 6);
  INSERT INTO image (id, url, rank, product_id, created_at, updated_at)
  VALUES (v_image_id, 'http://localhost:9000/static/CS 200 S_20251014_153804_6.webp', 0, v_product_id, NOW(), NOW());

  v_image_id := substring(md5(random()::text) from 1 for 6);
  INSERT INTO image (id, url, rank, product_id, created_at, updated_at)
  VALUES (v_image_id, 'http://localhost:9000/static/CS 200 S_20251014_153804_4.webp', 1, v_product_id, NOW(), NOW());

  v_image_id := substring(md5(random()::text) from 1 for 6);
  INSERT INTO image (id, url, rank, product_id, created_at, updated_at)
  VALUES (v_image_id, 'http://localhost:9000/static/CS 200 S_20251014_153804_1.webp', 2, v_product_id, NOW(), NOW());

  v_image_id := substring(md5(random()::text) from 1 for 6);
  INSERT INTO image (id, url, rank, product_id, created_at, updated_at)
  VALUES (v_image_id, 'http://localhost:9000/static/CS 200 S_20251014_153804_2.webp', 3, v_product_id, NOW(), NOW());

  v_image_id := substring(md5(random()::text) from 1 for 6);
  INSERT INTO image (id, url, rank, product_id, created_at, updated_at)
  VALUES (v_image_id, 'http://localhost:9000/static/CS 200 S_20251014_153804_12.webp', 4, v_product_id, NOW(), NOW());

  v_image_id := substring(md5(random()::text) from 1 for 6);
  INSERT INTO image (id, url, rank, product_id, created_at, updated_at)
  VALUES (v_image_id, 'http://localhost:9000/static/CS 200 S_20251014_153804_5.webp', 5, v_product_id, NOW(), NOW());

  v_image_id := substring(md5(random()::text) from 1 for 6);
  INSERT INTO image (id, url, rank, product_id, created_at, updated_at)
  VALUES (v_image_id, 'http://localhost:9000/static/CS 200 S_20251014_153804_10.webp', 6, v_product_id, NOW(), NOW());

  v_image_id := substring(md5(random()::text) from 1 for 6);
  INSERT INTO image (id, url, rank, product_id, created_at, updated_at)
  VALUES (v_image_id, 'http://localhost:9000/static/CS 200 S_20251014_153804_8.webp', 7, v_product_id, NOW(), NOW());

  v_image_id := substring(md5(random()::text) from 1 for 6);
  INSERT INTO image (id, url, rank, product_id, created_at, updated_at)
  VALUES (v_image_id, 'http://localhost:9000/static/CS 200 S_20251014_153804_9.webp', 8, v_product_id, NOW(), NOW());

  v_image_id := substring(md5(random()::text) from 1 for 6);
  INSERT INTO image (id, url, rank, product_id, created_at, updated_at)
  VALUES (v_image_id, 'http://localhost:9000/static/CS 200 S_20251014_153804_7.webp', 9, v_product_id, NOW(), NOW());

  v_image_id := substring(md5(random()::text) from 1 for 6);
  INSERT INTO image (id, url, rank, product_id, created_at, updated_at)
  VALUES (v_image_id, 'http://localhost:9000/static/CS 200 S_20251014_153804_13.webp', 10, v_product_id, NOW(), NOW());

  v_image_id := substring(md5(random()::text) from 1 for 6);
  INSERT INTO image (id, url, rank, product_id, created_at, updated_at)
  VALUES (v_image_id, 'http://localhost:9000/static/CS 200 S_20251014_153804_11.webp', 11, v_product_id, NOW(), NOW());

  v_image_id := substring(md5(random()::text) from 1 for 6);
  INSERT INTO image (id, url, rank, product_id, created_at, updated_at)
  VALUES (v_image_id, 'http://localhost:9000/static/CS 200 S_20251014_153804_3.webp', 12, v_product_id, NOW(), NOW());

  RAISE NOTICE '✅ 13 Imágenes insertadas';

  -- =========================================================================
  -- RESUMEN
  -- =========================================================================
  RAISE NOTICE '';
  RAISE NOTICE '╔════════════════════════════════════════════════════════════╗';
  RAISE NOTICE '║     CS200S-V2 CREADO CON ESTRUCTURA COMPLETA               ║';
  RAISE NOTICE '╚════════════════════════════════════════════════════════════╝';
  RAISE NOTICE '';
  RAISE NOTICE '📦 Handle: cummins-cs200s-v2';
  RAISE NOTICE '🆔 Product ID: %', v_product_id;
  RAISE NOTICE '💰 Precio: USD 28,707 (sin IVA)';
  RAISE NOTICE '🔧 200 KVA Standby / 180 KVA Prime';
  RAISE NOTICE '🔇 Insonorizado: 71 dB @ 7m';
  RAISE NOTICE '🖼️  13 Imágenes';
  RAISE NOTICE '🏷️  11 Tags';
  RAISE NOTICE '';
  RAISE NOTICE '🌐 Frontend: http://localhost:3000/producto/cummins-cs200s-v2';
  RAISE NOTICE '';

END $$;

-- Verificación
SELECT
  p.handle,
  p.title,
  pv.sku,
  pv.weight,
  pv.hs_code,
  pv.mid_code,
  length(p.metadata::text) as product_meta_size,
  length(pv.metadata::text) as variant_meta_size,
  COUNT(DISTINCT img.id) as images,
  COUNT(DISTINCT pt.product_tag_id) as tags
FROM product p
JOIN product_variant pv ON p.id = pv.product_id
LEFT JOIN image img ON p.id = img.product_id
LEFT JOIN product_tags pt ON p.id = pt.product_id
WHERE p.handle = 'cummins-cs200s-v2'
GROUP BY p.handle, p.title, pv.sku, pv.weight, pv.hs_code, pv.mid_code, p.metadata, pv.metadata;
