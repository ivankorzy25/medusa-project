-- =========================================================================
-- CREAR CS200A-v2 CON ESTRUCTURA OPTIMIZADA (VERSIÓN SIMPLIFICADA)
-- =========================================================================
-- Producto de referencia con metadata limpia y sin duplicados
-- Sin inventory system (se agregará después si es necesario)
-- =========================================================================

DO $$
DECLARE
  v_product_id text;
  v_variant_id text;
  v_price_set_id text;
  v_price_usd_id text;
  v_price_ars_id text;
  v_image_id text;
  v_region_argentina_id text;
BEGIN

  -- =========================================================================
  -- 1. VERIFICAR/CREAR REGIÓN ARGENTINA
  -- =========================================================================

  SELECT id INTO v_region_argentina_id
  FROM region WHERE name = 'Argentina';

  IF v_region_argentina_id IS NULL THEN
    v_region_argentina_id := 'reg_01ARGENTINA' || substring(gen_random_uuid()::text from 1 for 12);

    INSERT INTO region (id, name, currency_code, automatic_taxes, created_at, updated_at)
    VALUES (v_region_argentina_id, 'Argentina', 'ars', true, NOW(), NOW());

    RAISE NOTICE 'Región Argentina creada: %', v_region_argentina_id;
  ELSE
    RAISE NOTICE 'Región Argentina existe: %', v_region_argentina_id;
  END IF;

  -- =========================================================================
  -- 2. CREAR PRODUCTO (metadata limpia - solo comercial/marketing)
  -- =========================================================================

  v_product_id := 'prod_cs200av2_' || substring(gen_random_uuid()::text from 1 for 12);

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
    discountable,
    metadata,
    created_at,
    updated_at
  ) VALUES (
    v_product_id,
    'Generador Diesel Cummins CS200A-v2 - 200 KVA Stand-By / 180 KVA Prime',
    'Motor Cummins 6CTA8.3-G2 + Alternador Stamford UCI274G1 - Panel COMAP',
    'Generador industrial diesel Cummins CS200A de 200 KVA Stand-By / 180 KVA Prime.

Equipado con motor Cummins 6CTA8.3-G2 de 1500 RPM y alternador Stamford UCI274G1 brushless autoexcitado.

Ideal para uso continuo 24/7 en aplicaciones industriales, comerciales y residenciales de alta potencia.

Panel de control COMAP InteliLite MRS16 con función auto-start. Refrigeración por agua.

Diseñado para máxima confiabilidad y bajo costo operativo.

CARACTERÍSTICAS PRINCIPALES:
• Motor Cummins 6CTA8.3-G2 - 1500 RPM
• Alternador Stamford UCI274G1 Brushless
• 200 KVA Stand-By / 180 KVA Prime
• Panel COMAP InteliLite MRS16 con auto-start
• Refrigeración por agua
• Tanque de combustible: 400 litros
• Consumo a 75 porciento carga: 35.5 L/h
• Uso continuo 24/7

APLICACIONES:
• Industrias
• Comercios de alta potencia
• Edificios residenciales
• Hospitales y clínicas
• Data centers
• Zonas sin red eléctrica',
    'cummins-cs200a-v2',
    false,
    'http://localhost:9000/static/1762564697981-cs200a_page2_img3.png',
    'published',
    'ptype_generador_diesel',
    'pcoll_cummins_cs',
    true,
    '{
      "vendor": {
        "nombre": "KOR",
        "nombre_completo": "KOR - Soluciones Energéticas Profesionales",
        "descripcion": "Especialistas en generación de energía eléctrica y grupos electrógenos industriales.",
        "rating": 5,
        "anos_experiencia": 15,
        "tiempo_respuesta": "Dentro de 24hs"
      },
      "trust": {
        "envio_gratis": true,
        "envio_texto": "Envío gratis",
        "envio_descripcion": "En el ámbito de Buenos Aires",
        "garantia_incluida": true,
        "garantia_texto": "Garantía oficial",
        "garantia_descripcion": "Respaldado por el fabricante",
        "acepta_devoluciones": false
      },
      "comercial": {
        "estado_producto": "Nuevo",
        "es_mas_vendido": false,
        "descuento_porcentaje": 0
      },
      "ubicacion": {
        "pais": "Argentina",
        "provincia": "Buenos Aires",
        "ciudad": "Florida"
      },
      "financiacion": {
        "disponible": true,
        "planes": [
          {"cuotas": 3, "interes": 0.08},
          {"cuotas": 6, "interes": 0.08},
          {"cuotas": 12, "interes": 0.12}
        ]
      },
      "aplicaciones_industriales": [
        {"icon": "🏥", "title": "Hospitales y Clínicas"},
        {"icon": "💻", "title": "Centros de Datos"},
        {"icon": "🏭", "title": "Industria Manufacturera"},
        {"icon": "🏢", "title": "Edificios Comerciales"},
        {"icon": "🌾", "title": "Instalaciones Agrícolas"},
        {"icon": "📡", "title": "Telecomunicaciones"}
      ]
    }'::jsonb,
    NOW(),
    NOW()
  );

  RAISE NOTICE '✅ Producto creado: %', v_product_id;

  -- =========================================================================
  -- 3. CREAR VARIANT (metadata técnica COMPLETA)
  -- =========================================================================

  v_variant_id := 'variant_cs200av2_' || substring(gen_random_uuid()::text from 1 for 12);

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
    hs_code,
    mid_code,
    origin_country,
    material,
    variant_rank,
    metadata,
    created_at,
    updated_at
  ) VALUES (
    v_variant_id,
    'Generador CS200A - Estándar',
    v_product_id,
    'GEN-CS200A-V2-STD',
    false,
    true,
    2850000,  -- 2850 kg
    3200,     -- 3200 mm
    1900,     -- 1900 mm
    1400,     -- 1400 mm
    '850211',
    'GEN-CS200A',
    'CN',
    'Acero industrial',
    0,
    '{
      "pricing": {
        "precio_lista_usd": 26411,
        "currency_type": "usd_blue",
        "iva_percentage": 10.5,
        "bonificacion_percentage": 11,
        "descuento_contado_percentage": 9,
        "familia": "Generadores Cummins - Línea CS"
      },
      "specs": {
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
          "modelo": "6CTA8.3-G2",
          "tipo": "6 cilindros en línea, 4 tiempos",
          "cilindros": 6,
          "cilindrada_litros": 8.3,
          "potencia_hp": 247,
          "velocidad_rpm": 1500,
          "consumo_75_lh": 35.5,
          "consumo_100_lh": 47,
          "capacidad_aceite_litros": 24,
          "refrigeracion": "Agua",
          "turboalimentado": true
        },
        "alternador": {
          "marca": "Stamford",
          "modelo": "UCI274G1",
          "tipo": "Brushless",
          "excitacion": "Autoexcitado"
        },
        "panel_control": {
          "marca": "COMAP",
          "modelo": "InteliLite MRS16",
          "tipo": "Digital LCD",
          "arranque_automatico": true,
          "caracteristicas": ["Tablero digital", "Auto-start", "Parada de emergencia"]
        },
        "combustible": {
          "tipo": "Diesel",
          "capacidad_tanque_litros": 400,
          "autonomia_75_horas": 11.3
        },
        "insonorizacion": {
          "tipo": "Estándar (Abierto)",
          "nivel_ruido_db": 68
        },
        "caracteristicas_principales": [
          "Motor Cummins turboalimentado",
          "Alternador Stamford brushless",
          "Refrigeración por agua",
          "Panel COMAP digital",
          "Arranque automático",
          "Tanque integrado 400L",
          "Uso continuo 24/7"
        ]
      }
    }'::jsonb,
    NOW(),
    NOW()
  );

  RAISE NOTICE '✅ Variant creado: %', v_variant_id;

  -- =========================================================================
  -- 4. CREAR PRICE SET Y PRECIOS
  -- =========================================================================

  v_price_set_id := 'pset_cs200av2_' || substring(gen_random_uuid()::text from 1 for 12);

  INSERT INTO price_set (id, created_at, updated_at)
  VALUES (v_price_set_id, NOW(), NOW());

  INSERT INTO product_variant_price_set (id, variant_id, price_set_id, created_at, updated_at)
  VALUES (gen_random_uuid()::text, v_variant_id, v_price_set_id, NOW(), NOW());

  RAISE NOTICE '✅ Price set creado: %', v_price_set_id;

  -- Precio USD
  v_price_usd_id := 'price_cs200av2_usd_' || substring(gen_random_uuid()::text from 1 for 12);

  INSERT INTO price (id, price_set_id, currency_code, raw_amount, amount, created_at, updated_at)
  VALUES (v_price_usd_id, v_price_set_id, 'usd', '{"value": "2641100"}'::jsonb, 2641100, NOW(), NOW());

  RAISE NOTICE '✅ Precio USD: 26,411.00';

  -- Precio ARS (con rule para región Argentina)
  v_price_ars_id := 'price_cs200av2_ars_' || substring(gen_random_uuid()::text from 1 for 12);

  INSERT INTO price (id, price_set_id, currency_code, raw_amount, amount, created_at, updated_at)
  VALUES (v_price_ars_id, v_price_set_id, 'ars', '{"value": "2641100000"}'::jsonb, 2641100000, NOW(), NOW());

  INSERT INTO price_rule (id, price_id, attribute, operator, value, priority, created_at, updated_at)
  VALUES (
    'prule_cs200av2_' || substring(gen_random_uuid()::text from 1 for 12),
    v_price_ars_id,
    'region_id',
    'eq',
    v_region_argentina_id,
    0,
    NOW(),
    NOW()
  );

  RAISE NOTICE '✅ Precio ARS con rule para región Argentina';

  -- =========================================================================
  -- 5. COPIAR IMÁGENES
  -- =========================================================================

  v_image_id := substring(md5(random()::text) from 1 for 6);
  INSERT INTO image (id, url, rank, product_id, created_at, updated_at)
  VALUES (v_image_id, 'http://localhost:9000/static/1762564697981-cs200a_page2_img3.png', 0, v_product_id, NOW(), NOW());

  v_image_id := substring(md5(random()::text) from 1 for 6);
  INSERT INTO image (id, url, rank, product_id, created_at, updated_at)
  VALUES (v_image_id, 'http://localhost:9000/static/1762564697957-cs200a_full_page_1.png', 1, v_product_id, NOW(), NOW());

  v_image_id := substring(md5(random()::text) from 1 for 6);
  INSERT INTO image (id, url, rank, product_id, created_at, updated_at)
  VALUES (v_image_id, 'http://localhost:9000/static/1762564698071-cs200a_full_page_2.png', 2, v_product_id, NOW(), NOW());

  v_image_id := substring(md5(random()::text) from 1 for 6);
  INSERT INTO image (id, url, rank, product_id, created_at, updated_at)
  VALUES (v_image_id, 'http://localhost:9000/static/1762564698083-cs200a_page1_img3.png', 3, v_product_id, NOW(), NOW());

  v_image_id := substring(md5(random()::text) from 1 for 6);
  INSERT INTO image (id, url, rank, product_id, created_at, updated_at)
  VALUES (v_image_id, 'http://localhost:9000/static/1762564698070-cs200a_page2_img12.png', 4, v_product_id, NOW(), NOW());

  v_image_id := substring(md5(random()::text) from 1 for 6);
  INSERT INTO image (id, url, rank, product_id, created_at, updated_at)
  VALUES (v_image_id, 'http://localhost:9000/static/1762564698064-cs200a_page2_img10.png', 5, v_product_id, NOW(), NOW());

  v_image_id := substring(md5(random()::text) from 1 for 6);
  INSERT INTO image (id, url, rank, product_id, created_at, updated_at)
  VALUES (v_image_id, 'http://localhost:9000/static/1762564698069-cs200a_page2_img11.jpeg', 6, v_product_id, NOW(), NOW());

  v_image_id := substring(md5(random()::text) from 1 for 6);
  INSERT INTO image (id, url, rank, product_id, created_at, updated_at)
  VALUES (v_image_id, 'http://localhost:9000/static/1762564698000-cs200a_page2_img7.png', 7, v_product_id, NOW(), NOW());

  RAISE NOTICE '✅ 8 imágenes creadas';

  -- =========================================================================
  -- 6. ASIGNAR TAXONOMÍA
  -- =========================================================================

  INSERT INTO product_category_product (product_category_id, product_id)
  VALUES ('pcat_gen_diesel_100_200', v_product_id);

  INSERT INTO product_tags (product_id, product_tag_id)
  VALUES
    (v_product_id, 'ptag_diesel'),
    (v_product_id, 'ptag_cummins'),
    (v_product_id, 'ptag_industrial'),
    (v_product_id, 'ptag_estacionario'),
    (v_product_id, 'ptag_automatico'),
    (v_product_id, 'ptag_trifasico'),
    (v_product_id, 'ptag_standby'),
    (v_product_id, 'ptag_prime'),
    (v_product_id, 'ptag_stamford'),
    (v_product_id, 'ptag_100200kva');

  RAISE NOTICE '✅ Categoría y 10 tags asignados';

  -- =========================================================================
  -- 7. ASIGNAR SALES CHANNEL
  -- =========================================================================

  INSERT INTO product_sales_channel (id, product_id, sales_channel_id, created_at, updated_at)
  VALUES (gen_random_uuid()::text, v_product_id, 'sc_01K9FZ84KQM1PG94Q6YT6248EW', NOW(), NOW());

  RAISE NOTICE '✅ Sales Channel asignado';

  -- =========================================================================
  -- RESUMEN
  -- =========================================================================
  RAISE NOTICE '';
  RAISE NOTICE '========================================================';
  RAISE NOTICE '🎉 CS200A-v2 CREADO EXITOSAMENTE';
  RAISE NOTICE '========================================================';
  RAISE NOTICE 'Product ID: %', v_product_id;
  RAISE NOTICE 'Handle: cummins-cs200a-v2';
  RAISE NOTICE 'SKU: GEN-CS200A-V2-STD';
  RAISE NOTICE '';
  RAISE NOTICE 'MEJORAS:';
  RAISE NOTICE '✅ Metadata limpia (sin duplicados)';
  RAISE NOTICE '✅ Pricing USD + ARS nativo';
  RAISE NOTICE '✅ Región Argentina configurada';
  RAISE NOTICE '✅ Estructura optimizada';
  RAISE NOTICE '';
  RAISE NOTICE 'URLs:';
  RAISE NOTICE 'Admin: http://localhost:9000/app/products/%', v_product_id;
  RAISE NOTICE 'Frontend: http://localhost:3000/producto/cummins-cs200a-v2';
  RAISE NOTICE '========================================================';

END $$;

-- Verificación
SELECT
  p.handle,
  pv.sku,
  pv.weight,
  pv.hs_code,
  COUNT(DISTINCT img.id) as imagenes,
  COUNT(DISTINCT psc.sales_channel_id) as sales_channels,
  COUNT(DISTINCT pt.product_tag_id) as tags
FROM product p
JOIN product_variant pv ON p.id = pv.product_id
LEFT JOIN image img ON p.id = img.product_id
LEFT JOIN product_sales_channel psc ON p.id = psc.product_id
LEFT JOIN product_tags pt ON p.id = pt.product_id
WHERE p.handle = 'cummins-cs200a-v2'
GROUP BY p.handle, pv.sku, pv.weight, pv.hs_code;
