-- =========================================================================
-- CONFIGURACIÓN REGIÓN ARGENTINA EN MEDUSA
-- =========================================================================
-- Este script configura la región Argentina con:
-- - Moneda: ARS (Peso Argentino)
-- - Impuestos automáticos: Sí
-- - IVA 10.5% (Bienes de Capital) - Default
-- - IVA 21% (General)
--
-- Ejecutado: 2025-11-08
-- Estado: ✅ COMPLETADO
-- =========================================================================

-- 1. Crear región Argentina con ARS
INSERT INTO region (id, name, currency_code, automatic_taxes, created_at, updated_at)
VALUES (
  'reg_01JCARGENTINA2025',
  'Argentina',
  'ars',
  true,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO NOTHING;

-- 2. Asignar país Argentina a la nueva región
UPDATE region_country
SET region_id = 'reg_01JCARGENTINA2025'
WHERE iso_2 = 'ar';

-- 3. Crear tax_region para Argentina
INSERT INTO tax_region (id, provider_id, country_code, created_at, updated_at)
VALUES (
  'txreg_01JCARGENTINA2025',
  'tp_system',
  'ar',
  NOW(),
  NOW()
)
ON CONFLICT (id) DO NOTHING;

-- 4. Crear tax_rate para IVA 10.5% (Bienes de Capital) - Default
INSERT INTO tax_rate (
  id,
  rate,
  code,
  name,
  is_default,
  is_combinable,
  tax_region_id,
  created_at,
  updated_at
)
VALUES (
  'txrate_01JCAR_IVA_10_5',
  10.5,
  'IVA_AR_10_5',
  'IVA Argentina 10.5% - Bienes de Capital',
  true,
  false,
  'txreg_01JCARGENTINA2025',
  NOW(),
  NOW()
)
ON CONFLICT (id) DO NOTHING;

-- 5. Crear tax_rate para IVA 21% (General)
INSERT INTO tax_rate (
  id,
  rate,
  code,
  name,
  is_default,
  is_combinable,
  tax_region_id,
  created_at,
  updated_at
)
VALUES (
  'txrate_01JCAR_IVA_21',
  21.0,
  'IVA_AR_21',
  'IVA Argentina 21% - General',
  false,
  false,
  'txreg_01JCARGENTINA2025',
  NOW(),
  NOW()
)
ON CONFLICT (id) DO NOTHING;

-- =========================================================================
-- VERIFICACIÓN
-- =========================================================================

-- Ver configuración completa
SELECT
  '=== REGIÓN ARGENTINA ===' as seccion,
  r.id,
  r.name as nombre,
  r.currency_code as moneda,
  r.automatic_taxes as impuestos_automaticos,
  COUNT(rc.iso_2) as paises_asignados
FROM region r
LEFT JOIN region_country rc ON r.id = rc.region_id
WHERE r.name = 'Argentina'
GROUP BY r.id, r.name, r.currency_code, r.automatic_taxes

UNION ALL

SELECT
  '=== PAÍS ARGENTINA ===' as seccion,
  rc.iso_2 as id,
  rc.display_name as nombre,
  r.name as moneda,
  NULL as impuestos_automaticos,
  NULL as paises_asignados
FROM region_country rc
JOIN region r ON rc.region_id = r.id
WHERE rc.iso_2 = 'ar'

UNION ALL

SELECT
  '=== TAX REGION ===' as seccion,
  tr.id,
  tr.country_code as nombre,
  tr.provider_id as moneda,
  NULL as impuestos_automaticos,
  NULL as paises_asignados
FROM tax_region tr
WHERE tr.country_code = 'ar'

UNION ALL

SELECT
  '=== TAX RATES IVA ===' as seccion,
  t.code as id,
  t.name as nombre,
  CONCAT(t.rate::text, '%') as moneda,
  t.is_default as impuestos_automaticos,
  NULL as paises_asignados
FROM tax_rate t
JOIN tax_region tr ON t.tax_region_id = tr.id
WHERE tr.country_code = 'ar'
ORDER BY seccion, nombre;

-- =========================================================================
-- RESULTADO ESPERADO:
-- =========================================================================
-- ✅ Región Argentina creada con moneda ARS
-- ✅ País Argentina asignado a región
-- ✅ Tax region Argentina configurada
-- ✅ IVA 10.5% (Bienes de Capital) - DEFAULT
-- ✅ IVA 21% (General)
-- =========================================================================
