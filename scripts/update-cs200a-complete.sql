-- =========================================================================
-- COMPLETAR PRODUCTO CS200A CON METADATA Y ATRIBUTOS
-- =========================================================================
-- Basado en la estructura de CS275A (producto más completo actualmente)
-- Agregar metadata completa + dimensiones + códigos
-- =========================================================================

DO $$
DECLARE
  v_variant_id text;
BEGIN
  -- Obtener variant ID de CS200A
  SELECT id INTO v_variant_id
  FROM product_variant
  WHERE product_id = 'prod_cs200a_73150acc-b0b6-413b-8f55-2497142ba4f0';

  RAISE NOTICE 'Actualizando variant: %', v_variant_id;

  -- =========================================================================
  -- ACTUALIZAR VARIANT CON DIMENSIONES Y METADATA
  -- =========================================================================

  UPDATE product_variant
  SET
    weight = 2850000,  -- 2850 kg en gramos (según screenshot del usuario)
    length = 3200,     -- 3200 mm (según screenshot)
    height = 1900,     -- 1900 mm (según screenshot)
    width = 1400,      -- 1400 mm (según screenshot)
    hs_code = '850211', -- Código HS (según screenshot)
    mid_code = 'GEN-CS200A', -- Código MID (según screenshot)
    origin_country = 'China', -- País de origen (según screenshot)
    metadata = '{
      "pricing_config": {
        "precio_lista_usd": 28707,
        "currency_type": "usd_blue",
        "iva_percentage": 10.5,
        "bonificacion_percentage": 11,
        "descuento_contado_percentage": 9,
        "familia": "Generadores Cummins - Línea CS"
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
          "modelo": "6CTA8.3-G2",
          "tipo": "6 cilindros en línea, 4 tiempos",
          "cilindros": 6,
          "cilindrada_litros": 8.3,
          "potencia_hp": 247,
          "velocidad_rpm": 1500,
          "consumo_75_lh": 35.5,
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
          "marca": "COMAP",
          "modelo": "InteliLite MRS16",
          "tipo": "Electronico LCD",
          "arranque_automatico": true,
          "caracteristicas": [
            "Tablero digital",
            "Auto-start",
            "Parada de emergencia"
          ]
        },
        "combustible": {
          "tipo": "Diesel",
          "capacidad_tanque_litros": 400,
          "autonomia_75_horas": 11.3
        },
        "dimensiones": {
          "largo_mm": 3200,
          "ancho_mm": 1400,
          "alto_mm": 1900,
          "peso_kg": 2850
        },
        "caracteristicas_principales": [
          "Motor Cummins turboalimentado",
          "Alternador Stamford brushless",
          "Refrigeración por agua",
          "Panel de control digital COMAP",
          "Arranque automático",
          "Tanque de combustible integrado",
          "Apto para uso continuo"
        ]
      }
    }'::jsonb,
    updated_at = NOW()
  WHERE id = v_variant_id;

  RAISE NOTICE '';
  RAISE NOTICE '=== CS200A ACTUALIZADO EXITOSAMENTE ===';
  RAISE NOTICE 'Dimensions: 3200x1400x1900 mm';
  RAISE NOTICE 'Weight: 2850 kg';
  RAISE NOTICE 'HS Code: 850211';
  RAISE NOTICE 'MID Code: GEN-CS200A';
  RAISE NOTICE 'Origin: China';
  RAISE NOTICE 'Metadata: COMPLETA';
  RAISE NOTICE '';

END $$;

-- Verificar actualización
SELECT
  p.handle,
  pv.weight,
  pv.length,
  pv.height,
  pv.width,
  pv.hs_code,
  pv.mid_code,
  pv.origin_country,
  length(pv.metadata::text) as metadata_size
FROM product p
JOIN product_variant pv ON p.id = pv.product_id
WHERE p.handle = 'cummins-cs200a';
