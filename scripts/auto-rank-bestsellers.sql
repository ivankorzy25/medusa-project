-- ============================================================================
-- SCRIPT AUTOMÁTICO PARA RANKING DE "MÁS VENDIDO" POR CATEGORÍA
-- ============================================================================
-- Este script automáticamente marca el producto con más ventas de cada
-- categoría como "MÁS VENDIDO"
--
-- LÓGICA:
-- 1. Lee todos los productos con total_ventas > 0
-- 2. Agrupa por categoría
-- 3. Marca el top 1 de cada categoría como es_mas_vendido = true
--
-- EJECUTAR: psql postgresql://ivankorzyniewski@localhost:5432/medusa-store -f scripts/auto-rank-bestsellers.sql
-- ============================================================================

\set ON_ERROR_STOP on

BEGIN;

\echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
\echo '🏆 RANKING AUTOMÁTICO DE MÁS VENDIDOS POR CATEGORÍA'
\echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
\echo ''

-- ============================================================================
-- PASO 1: LIMPIAR BADGES ANTERIORES
-- ============================================================================

\echo '🧹 Limpiando badges anteriores...'

UPDATE product
SET metadata = metadata - 'es_mas_vendido'
WHERE metadata ? 'es_mas_vendido';

\echo '✅ Badges anteriores limpiados'
\echo ''

-- ============================================================================
-- PASO 2: CALCULAR Y MARCAR MÁS VENDIDO POR CATEGORÍA
-- ============================================================================

\echo '🔢 Calculando productos más vendidos por categoría...'
\echo ''

-- Crear tabla temporal con ranking de productos por categoría
CREATE TEMP TABLE ranking_ventas AS
WITH productos_con_ventas AS (
  SELECT
    id,
    title,
    metadata->>'categoria' as categoria,
    (metadata->>'total_ventas')::int as ventas,
    ROW_NUMBER() OVER (
      PARTITION BY metadata->>'categoria'
      ORDER BY (metadata->>'total_ventas')::int DESC
    ) as ranking
  FROM product
  WHERE metadata->>'total_ventas' IS NOT NULL
    AND metadata->>'categoria' IS NOT NULL
    AND (metadata->>'total_ventas')::int > 0
)
SELECT * FROM productos_con_ventas
WHERE ranking = 1;

-- Mostrar productos que serán marcados como "MÁS VENDIDO"
\echo 'Productos que serán marcados como MÁS VENDIDO:'
\echo ''
SELECT
  categoria,
  title,
  ventas
FROM ranking_ventas
ORDER BY categoria, ventas DESC;

\echo ''

-- Marcar productos como "más vendido"
UPDATE product p
SET metadata = jsonb_set(
  metadata,
  '{es_mas_vendido}',
  'true'
)
FROM ranking_ventas r
WHERE p.id = r.id;

\echo '✅ Badges "MÁS VENDIDO" asignados'
\echo ''

-- ============================================================================
-- PASO 3: REPORTE FINAL
-- ============================================================================

\echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
\echo '📊 REPORTE FINAL - PRODUCTOS POR CATEGORÍA'
\echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
\echo ''

SELECT
  metadata->>'categoria' as categoria,
  title,
  metadata->>'total_ventas' as ventas,
  CASE
    WHEN metadata->>'es_mas_vendido' = 'true' THEN '🏆 MÁS VENDIDO'
    ELSE ''
  END as badge
FROM product
WHERE metadata->>'categoria' IS NOT NULL
  AND metadata->>'total_ventas' IS NOT NULL
ORDER BY
  metadata->>'categoria',
  (metadata->>'total_ventas')::int DESC;

COMMIT;

\echo ''
\echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
\echo '✅ RANKING COMPLETADO'
\echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
\echo ''
\echo 'IMPORTANTE:'
\echo '  • Este script debe ejecutarse periódicamente (ej: nightly job)'
\echo '  • Solo marca productos con total_ventas > 0'
\echo '  • Solo 1 producto por categoría recibe el badge'
\echo '  • Si hay empate, se marca el primero en orden alfabético'
\echo ''
\echo 'PRÓXIMOS PASOS:'
\echo '1. Reiniciar Medusa backend'
\echo '2. Verificar badges en el frontend'
\echo '3. Configurar cron job para ejecución automática (opcional)'
\echo ''
