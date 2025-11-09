-- =========================================================================
-- COMPLETAR PRODUCTO CS200S CON METADATA COMPLETA
-- =========================================================================
-- Basado en la estructura de CS275A
-- CS200S ya tiene dimensiones, solo falta agregar metadata completa
-- =========================================================================

DO $$
DECLARE
  v_variant_id text;
BEGIN
  -- Obtener variant ID de CS200S
  SELECT pv.id INTO v_variant_id
  FROM product_variant pv
  JOIN product p ON pv.product_id = p.id
  WHERE p.handle = 'cummins-cs200s';

  RAISE NOTICE 'Actualizando variant: %', v_variant_id;

  -- =========================================================================
  -- ACTUALIZAR METADATA COMPLETA
  -- =========================================================================

  UPDATE product_variant
  SET
    hs_code = '850211',
    mid_code = 'GEN-CS200S',
    origin_country = 'China',
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
    }'::jsonb,
    updated_at = NOW()
  WHERE id = v_variant_id;

  RAISE NOTICE '';
  RAISE NOTICE '=== CS200S ACTUALIZADO EXITOSAMENTE ===';
  RAISE NOTICE 'HS Code: 850211';
  RAISE NOTICE 'MID Code: GEN-CS200S';
  RAISE NOTICE 'Origin: China';
  RAISE NOTICE 'Metadata: COMPLETA';
  RAISE NOTICE '';

END $$;

-- Verificar actualización
SELECT
  p.handle,
  pv.weight,
  pv.hs_code,
  pv.mid_code,
  pv.origin_country,
  length(pv.metadata::text) as metadata_size
FROM product p
JOIN product_variant pv ON p.id = pv.product_id
WHERE p.handle = 'cummins-cs200s';
