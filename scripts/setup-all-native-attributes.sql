-- ============================================================================
-- SCRIPT PARA CARGAR TODOS LOS ATRIBUTOS NATIVOS DE MEDUSA
-- ============================================================================
-- Este script carga TODOS los campos nativos disponibles en Medusa Admin
-- para aprovechar al máximo la estructura estándar del sistema
--
-- EJECUTAR: psql postgresql://ivankorzyniewski@localhost:5432/medusa-store -f scripts/setup-all-native-attributes.sql
-- ============================================================================

\set ON_ERROR_STOP on

BEGIN;

\echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
\echo '📦 CARGAR TODOS LOS ATRIBUTOS NATIVOS - CUMMINS CS200A'
\echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
\echo ''

-- ============================================================================
-- ACTUALIZAR TODOS LOS CAMPOS NATIVOS
-- ============================================================================

UPDATE product
SET
  -- 1. INFORMACIÓN BÁSICA
  title = 'Generador Diesel Cummins CS200A - 200 KVA Stand-By / 180 KVA Prime',
  subtitle = 'Motor Cummins 6BTAA5.9-G2 + Alternador Stamford HCI434F - Uso Industrial',
  handle = 'cummins-cs200a',  -- URL slug

  -- 2. DIMENSIONES Y PESO (Attributes en Admin)
  weight = '2850',      -- kg
  length = '3200',      -- mm (largo)
  width = '1400',       -- mm (ancho)
  height = '1900',      -- mm (alto)

  -- 3. INFORMACIÓN COMERCIAL (Attributes en Admin)
  origin_country = 'China',           -- País de origen
  hs_code = '850211',                 -- Código arancelario (generadores diesel)
  mid_code = 'GEN-CS200A',            -- MID code (código interno)
  material = 'Acero industrial',      -- Material principal

  -- 4. CONFIGURACIÓN DE PRODUCTO
  status = 'published',               -- Estado: published/draft/proposed/rejected
  discountable = true,                -- Permite aplicar descuentos
  is_giftcard = false,                -- No es gift card

  -- 5. THUMBNAIL (Imagen principal - se carga aparte)
  thumbnail = NULL  -- Se carga via Media en Admin

WHERE id = 'prod_cs200a_73150acc-b0b6-413b-8f55-2497142ba4f0';

\echo '✅ Todos los atributos nativos cargados'
\echo ''

-- ============================================================================
-- VERIFICAR CARGA COMPLETA
-- ============================================================================

\echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
\echo '📋 VERIFICACIÓN DE ATRIBUTOS NATIVOS'
\echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
\echo ''

\echo '1. INFORMACIÓN BÁSICA:'
SELECT
  title,
  subtitle,
  handle,
  status
FROM product
WHERE id = 'prod_cs200a_73150acc-b0b6-413b-8f55-2497142ba4f0';

\echo ''
\echo '2. ATRIBUTOS (Dimensions):'
SELECT
  weight || ' kg' as peso,
  length || ' mm' as largo,
  width || ' mm' as ancho,
  height || ' mm' as alto
FROM product
WHERE id = 'prod_cs200a_73150acc-b0b6-413b-8f55-2497142ba4f0';

\echo ''
\echo '3. ATRIBUTOS (Commercial):'
SELECT
  origin_country as pais_origen,
  hs_code as codigo_arancelario,
  mid_code as codigo_interno,
  material
FROM product
WHERE id = 'prod_cs200a_73150acc-b0b6-413b-8f55-2497142ba4f0';

\echo ''
\echo '4. CONFIGURACIÓN:'
SELECT
  discountable as permite_descuentos,
  is_giftcard as es_gift_card
FROM product
WHERE id = 'prod_cs200a_73150acc-b0b6-413b-8f55-2497142ba4f0';

COMMIT;

\echo ''
\echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
\echo '✅ TODOS LOS ATRIBUTOS NATIVOS CARGADOS'
\echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
\echo ''
\echo 'CAMPOS NATIVOS CONFIGURADOS EN MEDUSA ADMIN:'
\echo ''
\echo '┌─────────────────────────────────────────────────────────────┐'
\echo '│ TAB "GENERAL"                                               │'
\echo '├─────────────────────────────────────────────────────────────┤'
\echo '│ • Title: Generador Diesel Cummins CS200A...                │'
\echo '│ • Subtitle: Motor Cummins 6BTAA5.9-G2...                   │'
\echo '│ • Handle: cummins-cs200a                                   │'
\echo '│ • Description: (texto largo con características)            │'
\echo '└─────────────────────────────────────────────────────────────┘'
\echo ''
\echo '┌─────────────────────────────────────────────────────────────┐'
\echo '│ TAB "ATTRIBUTES"                                            │'
\echo '├─────────────────────────────────────────────────────────────┤'
\echo '│ Dimensions:                                                 │'
\echo '│   • Height: 1900 mm                                         │'
\echo '│   • Width: 1400 mm                                          │'
\echo '│   • Length: 3200 mm                                         │'
\echo '│   • Weight: 2850 kg                                         │'
\echo '│                                                             │'
\echo '│ Customs:                                                    │'
\echo '│   • MID code: GEN-CS200A                                   │'
\echo '│   • HS code: 850211                                        │'
\echo '│   • Country of origin: China                               │'
\echo '│   • Material: Acero industrial                             │'
\echo '└─────────────────────────────────────────────────────────────┘'
\echo ''
\echo '┌─────────────────────────────────────────────────────────────┐'
\echo '│ TAB "MEDIA"                                                 │'
\echo '├─────────────────────────────────────────────────────────────┤'
\echo '│ • Thumbnail: Imagen principal del producto                 │'
\echo '│ • Images: Galería de imágenes (ya cargadas)                │'
\echo '└─────────────────────────────────────────────────────────────┘'
\echo ''
\echo 'METADATA CUSTOM (características técnicas específicas):'
\echo '  • combustible_tipo, tiene_tta, tiene_cabina'
\echo '  • nivel_ruido_db, motor_*, potencia_*, alternador_*'
\echo '  • pricing_config, financiacion_disponible'
\echo ''
\echo 'FRONTEND - BADGES QUE SE MOSTRARÁN:'
\echo '  ⛽ Diesel (de metadata)'
\echo '  ⚡ TTA Opcional (de metadata)'
\echo '  🔊 68 dB (de metadata)'
\echo '  ⚖️ 2850 kg (de CAMPO NATIVO weight)'
\echo '  📏 320×140×190 cm (de CAMPOS NATIVOS length/width/height)'
\echo ''
\echo 'PRÓXIMOS PASOS:'
\echo '1. Recarga Medusa Admin y verifica tab "Attributes"'
\echo '2. Todos los campos deben aparecer correctamente'
\echo '3. Para futuros productos: cargar PRIMERO campos nativos'
\echo '4. Usar metadata SOLO para características únicas'
\echo ''
\echo 'DOCUMENTACIÓN:'
\echo '  📚 docs/CAMPOS_NATIVOS_VS_METADATA.md'
\echo ''
