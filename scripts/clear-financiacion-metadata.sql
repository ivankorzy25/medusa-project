-- ============================================================================
-- SCRIPT PARA QUITAR DATOS DE FINANCIACIÓN
-- ============================================================================
-- Este script elimina los planes de financiación del producto CS200A
--
-- EJECUTAR: psql postgresql://ivankorzyniewski@localhost:5432/medusa-store -f scripts/clear-financiacion-metadata.sql
-- ============================================================================

\set ON_ERROR_STOP on

BEGIN;

\echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
\echo '🧹 QUITAR FINANCIACIÓN DEL PRODUCTO CS200A'
\echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
\echo ''

-- Limpiar metadata de financiación
UPDATE product
SET metadata = metadata - 'financiacion_disponible' - 'planes_financiacion'
WHERE id = 'prod_cs200a_73150acc-b0b6-413b-8f55-2497142ba4f0';

\echo '✅ Metadata de financiación removida del producto CS200A'
\echo ''

-- Verificar estado actual
\echo '📋 Estado actual del producto:'
\echo ''

SELECT
  title,
  metadata->>'financiacion_disponible' as financiacion,
  metadata->>'descuento_porcentaje' as descuento,
  metadata->>'total_ventas' as ventas
FROM product
WHERE id = 'prod_cs200a_73150acc-b0b6-413b-8f55-2497142ba4f0';

COMMIT;

\echo ''
\echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
\echo '✅ FINANCIACIÓN REMOVIDA'
\echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
\echo ''
\echo 'RESULTADO EN EL FRONTEND:'
\echo '  ❌ NO se muestra línea de financiación'
\echo '  ✅ Resto de datos intactos (descuento, ventas, etc.)'
\echo ''
\echo 'Para agregar financiación nuevamente: scripts/add-financiacion-metadata.sql'
\echo ''
