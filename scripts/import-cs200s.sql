-- =========================================================================
-- IMPORTAR PRODUCTO: CUMMINS CS200S
-- =========================================================================
-- Generador Diesel Cummins CS200S 200 KVA Silent/Insonorizado
-- Precio: USD 28,707 | IVA 10.5% | Bonif 11% | Desc. Contado 9%
-- =========================================================================

DO $$
DECLARE
  v_product_id text;
  v_variant_id text;
BEGIN
  -- =========================================================================
  -- 1. CREAR PRODUCTO
  -- =========================================================================

  v_product_id := 'prod_cs200s_' || gen_random_uuid();

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
    'Generador diesel industrial de 200 kVA con motor Cummins 6CTA83G2 TDI, alternador Stamford UCI274G1 y panel Comap MRS16 con arranque automático. Cabina insonorizada de 71 dB. El CUMMINS CS200S es un generador diesel de alta gama diseñado para aplicaciones industriales críticas que combina el legendario motor Cummins de 8.3 litros turbo diesel intercooled con 241 HP, alternador brushless Stamford, y sofisticado panel de control Comap con capacidad de arranque automático y monitoreo remoto. Con tanque de 430 litros proporciona más de 12 horas de autonomía continua, ideal para hospitales, centros de datos, industrias y edificios comerciales donde la continuidad eléctrica es crítica.',
    'cummins-cs200s',
    false,
    null,
    'published',
    'ptype_generador_diesel',
    'pcoll_cummins_cs',
    NOW(),
    NOW()
  );

  RAISE NOTICE 'Producto creado: %', v_product_id;

  -- =========================================================================
  -- 2. CREAR VARIANT
  -- =========================================================================

  v_variant_id := 'variant_cs200s_' || gen_random_uuid();

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
    metadata,
    created_at,
    updated_at
  ) VALUES (
    v_variant_id,
    'CS200S',
    v_product_id,
    'CS200S',
    null,
    null,
    null,
    false,
    false,
    null,
    null,
    null,
    null,
    2450000,  -- 2450 kg en gramos
    3230,     -- 3230 mm longitud
    1800,     -- 1800 mm altura
    1170,     -- 1170 mm ancho
    jsonb_build_object(
      'pricing_config', jsonb_build_object(
        'precio_lista_usd', 28707,
        'currency_type', 'usd_blue',
        'iva_percentage', 10.5,
        'bonificacion_percentage', 11,
        'descuento_contado_percentage', 9,
        'familia', 'Generadores Cummins - Línea CS'
      ),
      'especificaciones_tecnicas', jsonb_build_object(
        'potencia', jsonb_build_object(
          'standby_kva', 200,
          'standby_kw', 160,
          'prime_kva', 180,
          'prime_kw', 144,
          'factor_potencia', 0.8,
          'tension', '380/220V',
          'frecuencia', '50 Hz'
        ),
        'motor', jsonb_build_object(
          'marca', 'Cummins',
          'modelo', '6CTA83G2 TDI',
          'tipo', 'Diesel 4 tiempos, Turbo Diesel Intercooled',
          'cilindros', 6,
          'cilindrada_litros', 8.3,
          'potencia_hp', 241,
          'potencia_kw', 180,
          'velocidad_rpm', 1500,
          'consumo_75_lh', 35,
          'consumo_100_lh', 45,
          'capacidad_aceite_litros', 24
        ),
        'alternador', jsonb_build_object(
          'marca', 'Stamford',
          'modelo', 'UCI274G1',
          'tipo', 'Brushless',
          'regulacion', '±0.5%',
          'clase_aislamiento', 'H',
          'proteccion', 'IP23'
        ),
        'panel_control', jsonb_build_object(
          'marca', 'ComAp',
          'modelo', 'InteliLite MRS16',
          'tipo', 'Digital LCD',
          'arranque_automatico', true
        ),
        'combustible', jsonb_build_object(
          'tipo', 'Diesel',
          'capacidad_tanque_litros', 430,
          'autonomia_75_horas', 12.3,
          'autonomia_100_horas', 10
        ),
        'insonorizacion', jsonb_build_object(
          'cabina', 'Silent Premium',
          'nivel_ruido_db', 71,
          'distancia_metros', 7
        ),
        'dimensiones', jsonb_build_object(
          'largo_mm', 3230,
          'ancho_mm', 1170,
          'alto_mm', 1800,
          'peso_kg', 2450,
          'peso_operativo_kg', 2880
        )
      )
    ),
    NOW(),
    NOW()
  );

  RAISE NOTICE 'Variant creado: %', v_variant_id;

  -- =========================================================================
  -- 3. ASIGNAR PRECIO (REGIÓN ARGENTINA)
  -- =========================================================================

  -- NO ASIGNAMOS PRECIO AQUÍ - Se calcula dinámicamente desde metadata
  RAISE NOTICE 'Precio configurado en metadata USD 28707 con IVA 10.5 porciento';

  -- =========================================================================
  -- 4. ASIGNAR CATEGORÍA
  -- =========================================================================

  INSERT INTO product_category_product (product_category_id, product_id)
  VALUES ('pcat_gen_diesel_100_200', v_product_id)
  ON CONFLICT DO NOTHING;

  RAISE NOTICE 'Categoría asignada: 100 a 200 KVA';

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
  RAISE NOTICE 'Precio: USD 28,707 (sin IVA)';
  RAISE NOTICE 'IVA: 10.5 porciento';
  RAISE NOTICE 'Type: Generador Diesel';
  RAISE NOTICE 'Collection: Generadores Cummins - Línea CS';
  RAISE NOTICE 'Category: 100 a 200 KVA';
  RAISE NOTICE 'Tags: 11 (incluye "insonorizado")';
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
  COUNT(DISTINCT ptags.product_tag_id) as tags
FROM product p
LEFT JOIN product_type pt ON p.type_id = pt.id
LEFT JOIN product_collection pc ON p.collection_id = pc.id
LEFT JOIN product_category_product pcp ON p.id = pcp.product_id
LEFT JOIN product_tags ptags ON p.id = ptags.product_id
WHERE p.handle = 'cummins-cs200s'
GROUP BY p.id, p.title, p.handle, pt.value, pc.title;
