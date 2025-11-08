-- ============================================================================
-- SCRIPT PARA AGREGAR DATOS DE FINANCIACIÓN
-- ============================================================================
-- Este script agrega planes de financiación al producto CS200A
-- Permite mostrar "Mismo precio en X cuotas de $ Y"
--
-- EJECUTAR: psql postgresql://ivankorzyniewski@localhost:5432/medusa-store -f scripts/add-financiacion-metadata.sql
-- ============================================================================

\set ON_ERROR_STOP on

BEGIN;

\echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
\echo '💳 AGREGAR FINANCIACIÓN AL PRODUCTO CS200A'
\echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
\echo ''

-- ============================================================================
-- PASO 1: AGREGAR DATOS DE FINANCIACIÓN
-- ============================================================================

\echo '📊 Agregando planes de financiación...'
\echo ''

-- Actualizar metadata con financiación disponible
UPDATE product
SET metadata = jsonb_set(
  jsonb_set(
    metadata,
    '{financiacion_disponible}',
    'true'
  ),
  '{planes_financiacion}',
  '[
    {"cuotas": 3, "interes": 0.08, "costoPorCuota": 14740000},
    {"cuotas": 6, "interes": 0.08, "costoPorCuota": 7570000},
    {"cuotas": 12, "interes": 0.12, "costoPorCuota": 4180000}
  ]'::jsonb
)
WHERE id = 'prod_cs200a_73150acc-b0b6-413b-8f55-2497142ba4f0';

\echo '✅ Planes de financiación agregados'
\echo ''

-- ============================================================================
-- PASO 2: VERIFICAR METADATA ACTUAL
-- ============================================================================

\echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
\echo '📋 ESTADO ACTUAL DE FINANCIACIÓN'
\echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
\echo ''

SELECT
  title,
  metadata->>'financiacion_disponible' as financiacion,
  jsonb_pretty(metadata->'planes_financiacion') as planes
FROM product
WHERE id = 'prod_cs200a_73150acc-b0b6-413b-8f55-2497142ba4f0';

COMMIT;

\echo ''
\echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
\echo '✅ FINANCIACIÓN AGREGADA'
\echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
\echo ''
\echo 'CAMPOS METADATA CONFIGURADOS:'
\echo '  • financiacion_disponible: true'
\echo '  • planes_financiacion: [3, 6, 12 cuotas]'
\echo ''
\echo 'PLANES DE FINANCIACIÓN:'
\echo '  ✅ 3 cuotas de $ 14.740.000 (interés 8%)'
\echo '  ✅ 6 cuotas de $ 7.570.000 (interés 8%)'
\echo '  ✅ 12 cuotas de $ 4.180.000 (interés 12%)'
\echo ''
\echo 'RESULTADO EN EL FRONTEND:'
\echo '  ✅ "Mismo precio en 3 cuotas de $ 14.740.000"'
\echo ''
\echo 'VALIDACIONES APLICADAS:'
\echo '  • Solo muestra planes con interés ≤ 15%'
\echo '  • Muestra el primer plan disponible por defecto'
\echo '  • Si no hay financiación, no muestra nada'
\echo ''
\echo 'PRÓXIMOS PASOS:'
\echo '1. Reinicia Medusa backend'
\echo '2. Recarga http://localhost:3000/producto/cummins-cs200a'
\echo '3. Verifica que aparezca la línea de financiación'
\echo '4. Para QUITAR financiación: ejecuta scripts/clear-financiacion-metadata.sql'
\echo ''
