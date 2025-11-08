-- ============================================
-- SCRIPT: Completar Metadata Cummins CS200A
-- ============================================
-- Este script completa TODOS los campos de metadata necesarios
-- para que "Lo que tenés que saber" muestre información completa
--
-- IMPORTANTE: Ya tenés muchos campos cargados, este script
-- solo agrega/actualiza los que faltan o necesitan ajustes
-- ============================================

-- Obtener el product_id
DO $$
DECLARE
    v_product_id TEXT;
BEGIN
    -- Buscar el producto por handle
    SELECT id INTO v_product_id
    FROM product
    WHERE handle = 'cummins-cs200a';

    IF v_product_id IS NULL THEN
        RAISE EXCEPTION 'Producto no encontrado con handle: cummins-cs200a';
    END IF;

    RAISE NOTICE 'Producto encontrado: %', v_product_id;

    -- ACTUALIZAR METADATA COMPLETO
    -- Tomamos lo que ya existe y agregamos los campos faltantes
    UPDATE product
    SET metadata = jsonb_set(
        jsonb_set(
            jsonb_set(
                jsonb_set(
                    jsonb_set(
                        jsonb_set(
                            jsonb_set(
                                jsonb_set(
                                    jsonb_set(
                                        jsonb_set(
                                            COALESCE(metadata, '{}'::jsonb),
                                            '{potencia_standby_kw}', '"160"'
                                        ),
                                        '{combustible_capacidad_tanque}', '"400"'
                                    ),
                                    '{autonomia_horas_75_carga}', '"11.3"'
                                ),
                                '{motor_tipo_cilindros}', '"En línea"'
                            ),
                            '{tipo_refrigeracion}', '"Agua"'
                        ),
                        '{panel_control_marca}', '"Deep Sea"'
                    ),
                    '{panel_control_modelo}', '"DSE7320"'
                ),
                '{tipo_arranque}', '"Eléctrico"'
            ),
            '{voltaje_salida}', '"220/380V"'
        ),
        '{motor_refrigeracion}', '"Agua"'
    )
    WHERE id = v_product_id;

    RAISE NOTICE 'Metadata actualizado correctamente para: %', v_product_id;

    -- Mostrar el metadata actualizado
    RAISE NOTICE '============================================';
    RAISE NOTICE 'CAMPOS QUE SE MOSTRARÁN EN "LO QUE TENÉS QUE SABER":';
    RAISE NOTICE '============================================';
    RAISE NOTICE '• Motor: % %',
        (SELECT metadata->>'motor_marca' FROM product WHERE id = v_product_id),
        (SELECT metadata->>'motor_modelo' FROM product WHERE id = v_product_id);
    RAISE NOTICE '• Potencia Stand-By: % KVA (% KW)',
        (SELECT metadata->>'potencia_standby_kva' FROM product WHERE id = v_product_id),
        (SELECT metadata->>'potencia_standby_kw' FROM product WHERE id = v_product_id);
    RAISE NOTICE '• Potencia Prime: % KVA (% KW)',
        (SELECT metadata->>'potencia_prime_kva' FROM product WHERE id = v_product_id),
        (SELECT metadata->>'potencia_prime_kw' FROM product WHERE id = v_product_id);
    RAISE NOTICE '• Alternador: % %',
        (SELECT metadata->>'alternador_marca' FROM product WHERE id = v_product_id),
        (SELECT metadata->>'alternador_modelo' FROM product WHERE id = v_product_id);
    RAISE NOTICE '• Voltaje: % - %',
        (SELECT metadata->>'voltaje_salida' FROM product WHERE id = v_product_id),
        (SELECT metadata->>'fases' FROM product WHERE id = v_product_id);
    RAISE NOTICE '• Frecuencia: %',
        (SELECT metadata->>'frecuencia' FROM product WHERE id = v_product_id);
    RAISE NOTICE '• Capacidad de tanque: % litros',
        (SELECT metadata->>'combustible_capacidad_tanque' FROM product WHERE id = v_product_id);
    RAISE NOTICE '• Autonomía al 75%% de carga: % horas',
        (SELECT metadata->>'autonomia_horas_75_carga' FROM product WHERE id = v_product_id);
    RAISE NOTICE '• Motor de % cilindros %',
        (SELECT metadata->>'motor_cilindros' FROM product WHERE id = v_product_id),
        (SELECT metadata->>'motor_tipo_cilindros' FROM product WHERE id = v_product_id);
    RAISE NOTICE '• %',
        (SELECT metadata->>'motor_aspiracion' FROM product WHERE id = v_product_id);
    RAISE NOTICE '• Refrigeración: %',
        (SELECT metadata->>'tipo_refrigeracion' FROM product WHERE id = v_product_id);
    RAISE NOTICE '• Panel de control: % %',
        (SELECT metadata->>'panel_control_marca' FROM product WHERE id = v_product_id),
        (SELECT metadata->>'panel_control_modelo' FROM product WHERE id = v_product_id);
    RAISE NOTICE '• Sistema de arranque: %',
        (SELECT metadata->>'tipo_arranque' FROM product WHERE id = v_product_id);
    RAISE NOTICE '============================================';

END $$;

-- VERIFICACIÓN FINAL
SELECT
    'Cummins CS200A' as producto,
    CASE
        WHEN metadata ? 'motor_marca'
         AND metadata ? 'potencia_standby_kva'
         AND metadata ? 'potencia_standby_kw'
         AND metadata ? 'alternador_marca'
         AND metadata ? 'voltaje_salida'
         AND metadata ? 'frecuencia'
         AND metadata ? 'combustible_capacidad_tanque'
         AND metadata ? 'autonomia_horas_75_carga'
         AND metadata ? 'motor_cilindros'
         AND metadata ? 'motor_aspiracion'
         AND metadata ? 'tipo_refrigeracion'
         AND metadata ? 'panel_control_marca'
         AND metadata ? 'tipo_arranque'
        THEN '✅ COMPLETO - Se mostrarán 13+ características'
        ELSE '⚠️  INCOMPLETO - Faltan campos'
    END as estado
FROM product
WHERE handle = 'cummins-cs200a';
