-- ============================================================================
-- SCRIPT PARA LIMPIAR DATOS DE VENTAS Y BADGES
-- ============================================================================
-- Este script limpia todos los badges y contadores de ventas
-- Útil para resetear productos o remover badges cuando no hay datos reales
--
-- EJECUTAR: psql postgresql://ivankorzyniewski@localhost:5432/medusa-store -f scripts/clear-sales-metadata.sql
-- ============================================================================

\set ON_ERROR_STOP on

BEGIN;

\echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
\echo '🧹 LIMPIAR DATOS DE VENTAS Y BADGES'
\echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
\echo ''

-- Limpiar metadata de ventas del producto CS200A
UPDATE product
SET metadata = metadata - 'total_ventas' - 'es_mas_vendido' - 'categoria'
WHERE id = 'prod_cs200a_73150acc-b0b6-413b-8f55-2497142ba4f0';

\echo '✅ Metadata de ventas removida del producto CS200A'
\echo ''

-- Verificar estado actual
\echo '📋 Estado actual del producto:'
\echo ''

SELECT
  title,
  metadata->>'total_ventas' as ventas,
  metadata->>'es_mas_vendido' as mas_vendido,
  metadata->>'descuento_porcentaje' as descuento
FROM product
WHERE id = 'prod_cs200a_73150acc-b0b6-413b-8f55-2497142ba4f0';

COMMIT;

\echo ''
\echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
\echo '✅ LIMPIEZA COMPLETADA'
\echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
\echo ''
\echo 'RESULTADO EN EL FRONTEND:'
\echo '  ❌ Badge "MÁS VENDIDO" NO visible'
\echo '  ❌ Contador de ventas NO visible (solo "Nuevo")'
\echo ''
\echo 'Para agregar ventas nuevamente: scripts/update-sales-metadata.sql'
\echo ''
