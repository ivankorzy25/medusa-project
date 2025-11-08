-- ============================================================================
-- SCRIPT PARA GESTIONAR VENTAS Y BADGE "MÁS VENDIDO"
-- ============================================================================
-- Este script permite actualizar las ventas de productos y marcar el más vendido
-- de cada categoría
--
-- EJECUTAR: psql postgresql://ivankorzyniewski@localhost:5432/medusa-store -f scripts/update-sales-metadata.sql
-- ============================================================================

\set ON_ERROR_STOP on

BEGIN;

\echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
\echo '📊 ACTUALIZAR DATOS DE VENTAS Y BADGE MÁS VENDIDO'
\echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
\echo ''

-- ============================================================================
-- PASO 1: ACTUALIZAR VENTAS DEL PRODUCTO CS200A (EJEMPLO)
-- ============================================================================

\echo '📦 Actualizando ventas del producto CS200A...'
\echo ''

-- Opción A: Agregar ventas al CS200A
UPDATE product
SET metadata = jsonb_set(
  jsonb_set(
    metadata,
    '{total_ventas}',
    '247'  -- Número de ventas (coincide con reviews)
  ),
  '{categoria}',
  '"Generadores Diesel"'  -- Categoría para comparación
)
WHERE id = 'prod_cs200a_73150acc-b0b6-413b-8f55-2497142ba4f0';

\echo '✅ Ventas actualizadas: 247 unidades vendidas'
\echo ''

-- ============================================================================
-- PASO 2: MARCAR COMO "MÁS VENDIDO" DE SU CATEGORÍA
-- ============================================================================

\echo '🏆 Marcando producto como MÁS VENDIDO de su categoría...'
\echo ''

-- Primero, quitar el badge "más vendido" de todos los productos de la categoría
UPDATE product
SET metadata = metadata - 'es_mas_vendido'
WHERE metadata->>'categoria' = 'Generadores Diesel';

-- Luego, marcar el producto con más ventas como "más vendido"
-- (En este caso, manualmente marcamos CS200A como el más vendido)
UPDATE product
SET metadata = jsonb_set(
  metadata,
  '{es_mas_vendido}',
  'true'
)
WHERE id = 'prod_cs200a_73150acc-b0b6-413b-8f55-2497142ba4f0';

\echo '✅ CS200A marcado como MÁS VENDIDO de "Generadores Diesel"'
\echo ''

-- ============================================================================
-- PASO 3: VERIFICAR METADATA ACTUAL
-- ============================================================================

\echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
\echo '📋 ESTADO ACTUAL DE PRODUCTOS'
\echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
\echo ''

SELECT
  title,
  metadata->>'categoria' as categoria,
  metadata->>'total_ventas' as ventas,
  metadata->>'es_mas_vendido' as mas_vendido,
  metadata->>'descuento_porcentaje' as descuento
FROM product
WHERE metadata->>'categoria' = 'Generadores Diesel'
ORDER BY (metadata->>'total_ventas')::int DESC NULLS LAST;

COMMIT;

\echo ''
\echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
\echo '✅ ACTUALIZACIÓN COMPLETADA'
\echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
\echo ''
\echo 'CAMPOS METADATA CONFIGURADOS:'
\echo '  • total_ventas: 247'
\echo '  • es_mas_vendido: true'
\echo '  • categoria: Generadores Diesel'
\echo ''
\echo 'RESULTADO EN EL FRONTEND:'
\echo '  ✅ Badge "MÁS VENDIDO" visible'
\echo '  ✅ Subtítulo: "Nuevo | +247 vendidos"'
\echo ''
\echo 'PRÓXIMOS PASOS:'
\echo '1. Reinicia Medusa backend para aplicar cambios'
\echo '2. Recarga http://localhost:3000/producto/cummins-cs200a'
\echo '3. Para QUITAR badges: ejecuta scripts/clear-sales-metadata.sql'
\echo '4. Para script automático de ranking: pendiente implementar'
\echo ''
