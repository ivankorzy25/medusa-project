-- ============================================================================
-- SCRIPT PARA AGREGAR ATRIBUTOS VISUALES AL PRODUCTO
-- ============================================================================
-- Este script agrega campos para badges de características (combustible,
-- TTA, cabina, nivel de ruido, peso, dimensiones)
--
-- EJECUTAR: psql postgresql://ivankorzyniewski@localhost:5432/medusa-store -f scripts/add-product-attributes.sql
-- ============================================================================

\set ON_ERROR_STOP on

BEGIN;

\echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
\echo '🎨 AGREGAR ATRIBUTOS VISUALES AL PRODUCTO CS200A'
\echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
\echo ''

-- ============================================================================
-- PASO 1: AGREGAR ATRIBUTOS PRINCIPALES
-- ============================================================================

\echo '📊 Agregando atributos visuales (combustible, ruido, peso, dimensiones)...'
\echo ''

UPDATE product
SET metadata = metadata
  || '{"nivel_ruido_db": "68"}'::jsonb
  || '{"peso_kg": "2850"}'::jsonb
  || '{"largo_mm": "3200"}'::jsonb
  || '{"ancho_mm": "1400"}'::jsonb
  || '{"alto_mm": "1900"}'::jsonb
WHERE id = 'prod_cs200a_73150acc-b0b6-413b-8f55-2497142ba4f0';

\echo '✅ Atributos agregados correctamente'
\echo ''

-- ============================================================================
-- PASO 2: VERIFICAR METADATA ACTUAL
-- ============================================================================

\echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
\echo '📋 ATRIBUTOS CONFIGURADOS'
\echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
\echo ''

SELECT
  title,
  metadata->>'combustible_tipo' as combustible,
  metadata->>'nivel_ruido_db' as ruido_db,
  metadata->>'peso_kg' as peso,
  CONCAT(metadata->>'largo_mm', 'x', metadata->>'ancho_mm', 'x', metadata->>'alto_mm') as dimensiones_mm
FROM product
WHERE id = 'prod_cs200a_73150acc-b0b6-413b-8f55-2497142ba4f0';

COMMIT;

\echo ''
\echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
\echo '✅ ATRIBUTOS AGREGADOS'
\echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
\echo ''
\echo 'BADGES QUE SE MOSTRARÁN:'
\echo '  ⛽ Diesel (amarillo)'
\echo '  ⚡ TTA Incluido (verde) - si está en descripción'
\echo '  🏠 Con Cabina (azul) - si está en descripción/título'
\echo '  🔊 68 dB (verde/amarillo/rojo según nivel) + barra'
\echo '  ⚖️ 2850 kg (gris)'
\echo '  📏 320×140×190 cm (gris)'
\echo ''
\echo 'COLORES POR TIPO DE COMBUSTIBLE:'
\echo '  • Diesel: Amarillo (#FEF3C7 / #92400E)'
\echo '  • Nafta: Azul (#DBEAFE / #1E40AF)'
\echo '  • Gas: Verde (#D1FAE5 / #065F46)'
\echo ''
\echo 'NIVEL DE RUIDO (dB):'
\echo '  • ≤65 dB: Verde (Excelente)'
\echo '  • 66-75 dB: Amarillo (Bueno)'
\echo '  • >75 dB: Rojo (Alto)'
\echo ''
\echo 'PRÓXIMOS PASOS:'
\echo '1. Recarga http://localhost:3000/producto/cummins-cs200a'
\echo '2. Verifica badges debajo del rating'
\echo '3. Ajusta nivel_ruido_db según especificaciones reales'
\echo ''
