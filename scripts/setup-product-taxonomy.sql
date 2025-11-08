-- =========================================================================
-- CONFIGURACIÓN DE TAXONOMÍA DE PRODUCTOS
-- =========================================================================
-- Este script crea la estructura completa de organización para productos
-- Tags, Types, Collections y Categories
--
-- Fecha: 2025-11-08
-- =========================================================================

-- =========================================================================
-- 1. PRODUCT TYPES (Tipos de productos)
-- =========================================================================

-- Generadores
INSERT INTO product_type (id, value, created_at, updated_at)
VALUES
  ('ptype_generador_diesel', 'Generador Diesel', NOW(), NOW()),
  ('ptype_generador_nafta', 'Generador Nafta', NOW(), NOW()),
  ('ptype_generador_gas', 'Generador Gas', NOW(), NOW())
ON CONFLICT DO NOTHING;

-- Compresores
INSERT INTO product_type (id, value, created_at, updated_at)
VALUES
  ('ptype_compresor_piston', 'Compresor a Pistón', NOW(), NOW()),
  ('ptype_compresor_tornillo', 'Compresor a Tornillo', NOW(), NOW())
ON CONFLICT DO NOTHING;

-- Hidrolavadoras
INSERT INTO product_type (id, value, created_at, updated_at)
VALUES
  ('ptype_hidrolavadora_domestica', 'Hidrolavadora Doméstica', NOW(), NOW()),
  ('ptype_hidrolavadora_industrial', 'Hidrolavadora Industrial', NOW(), NOW())
ON CONFLICT DO NOTHING;

-- Motores
INSERT INTO product_type (id, value, created_at, updated_at)
VALUES
  ('ptype_motor_diesel', 'Motor Diesel', NOW(), NOW()),
  ('ptype_motor_nafta', 'Motor Nafta', NOW(), NOW())
ON CONFLICT DO NOTHING;

-- Otros equipos
INSERT INTO product_type (id, value, created_at, updated_at)
VALUES
  ('ptype_bomba_agua', 'Bomba de Agua', NOW(), NOW()),
  ('ptype_soldadora', 'Soldadora', NOW(), NOW())
ON CONFLICT DO NOTHING;

-- =========================================================================
-- 2. PRODUCT TAGS (Etiquetas para filtrado)
-- =========================================================================

-- Tags de combustible
INSERT INTO product_tag (id, value, created_at, updated_at)
VALUES
  ('ptag_diesel', 'diesel', NOW(), NOW()),
  ('ptag_nafta', 'nafta', NOW(), NOW()),
  ('ptag_gas', 'gas', NOW(), NOW()),
  ('ptag_electrico', 'eléctrico', NOW(), NOW())
ON CONFLICT DO NOTHING;

-- Tags de aplicación
INSERT INTO product_tag (id, value, created_at, updated_at)
VALUES
  ('ptag_industrial', 'industrial', NOW(), NOW()),
  ('ptag_domestico', 'doméstico', NOW(), NOW()),
  ('ptag_comercial', 'comercial', NOW(), NOW()),
  ('ptag_construccion', 'construcción', NOW(), NOW())
ON CONFLICT DO NOTHING;

-- Tags de características
INSERT INTO product_tag (id, value, created_at, updated_at)
VALUES
  ('ptag_insonorizado', 'insonorizado', NOW(), NOW()),
  ('ptag_cabina', 'cabina', NOW(), NOW()),
  ('ptag_tta', 'tta', NOW(), NOW()),
  ('ptag_automatico', 'automático', NOW(), NOW()),
  ('ptag_manual', 'manual', NOW(), NOW()),
  ('ptag_portatil', 'portátil', NOW(), NOW()),
  ('ptag_estacionario', 'estacionario', NOW(), NOW())
ON CONFLICT DO NOTHING;

-- Tags de configuración eléctrica
INSERT INTO product_tag (id, value, created_at, updated_at)
VALUES
  ('ptag_trifasico', 'trifásico', NOW(), NOW()),
  ('ptag_monofasico', 'monofásico', NOW(), NOW()),
  ('ptag_bifasico', 'bifásico', NOW(), NOW())
ON CONFLICT DO NOTHING;

-- Tags de modo de operación
INSERT INTO product_tag (id, value, created_at, updated_at)
VALUES
  ('ptag_standby', 'standby', NOW(), NOW()),
  ('ptag_prime', 'prime', NOW(), NOW()),
  ('ptag_continuo', 'continuo', NOW(), NOW())
ON CONFLICT DO NOTHING;

-- Tags de marcas motor
INSERT INTO product_tag (id, value, created_at, updated_at)
VALUES
  ('ptag_cummins', 'cummins', NOW(), NOW()),
  ('ptag_perkins', 'perkins', NOW(), NOW()),
  ('ptag_volvo', 'volvo', NOW(), NOW()),
  ('ptag_caterpillar', 'caterpillar', NOW(), NOW()),
  ('ptag_deutz', 'deutz', NOW(), NOW())
ON CONFLICT DO NOTHING;

-- Tags de marcas alternador
INSERT INTO product_tag (id, value, created_at, updated_at)
VALUES
  ('ptag_stamford', 'stamford', NOW(), NOW()),
  ('ptag_leroy_somer', 'leroy-somer', NOW(), NOW()),
  ('ptag_mecc_alte', 'mecc-alte', NOW(), NOW())
ON CONFLICT DO NOTHING;

-- Tags de rangos de potencia (generadores)
INSERT INTO product_tag (id, value, created_at, updated_at)
VALUES
  ('ptag_10kva', '1-10kva', NOW(), NOW()),
  ('ptag_1030kva', '10-30kva', NOW(), NOW()),
  ('ptag_30100kva', '30-100kva', NOW(), NOW()),
  ('ptag_100200kva', '100-200kva', NOW(), NOW()),
  ('ptag_200500kva', '200-500kva', NOW(), NOW()),
  ('ptag_500kva', '+500kva', NOW(), NOW())
ON CONFLICT DO NOTHING;

-- =========================================================================
-- 3. PRODUCT COLLECTIONS (Colecciones/Familias)
-- =========================================================================

-- Colecciones Cummins
INSERT INTO product_collection (id, title, handle, created_at, updated_at)
VALUES
  ('pcoll_cummins_cs', 'Generadores Cummins - Línea CS', 'generadores-cummins-linea-cs', NOW(), NOW()),
  ('pcoll_cummins_ck', 'Generadores Cummins - Línea CK', 'generadores-cummins-linea-ck', NOW(), NOW()),
  ('pcoll_cummins_onan', 'Generadores Cummins - Serie ONAN', 'generadores-cummins-serie-onan', NOW(), NOW())
ON CONFLICT DO NOTHING;

-- Colecciones Perkins
INSERT INTO product_collection (id, title, handle, created_at, updated_at)
VALUES
  ('pcoll_perkins_1000', 'Generadores Perkins - Serie 1000', 'generadores-perkins-serie-1000', NOW(), NOW()),
  ('pcoll_perkins_2000', 'Generadores Perkins - Serie 2000', 'generadores-perkins-serie-2000', NOW(), NOW())
ON CONFLICT DO NOTHING;

-- Colecciones Compresores
INSERT INTO product_collection (id, title, handle, created_at, updated_at)
VALUES
  ('pcoll_atlas_copco_tornillo', 'Compresores Atlas Copco - Tornillo', 'compresores-atlas-copco-tornillo', NOW(), NOW()),
  ('pcoll_atlas_copco_piston', 'Compresores Atlas Copco - Pistón', 'compresores-atlas-copco-piston', NOW(), NOW())
ON CONFLICT DO NOTHING;

-- Colecciones Hidrolavadoras
INSERT INTO product_collection (id, title, handle, created_at, updated_at)
VALUES
  ('pcoll_karcher_k', 'Hidrolavadoras Karcher - Serie K', 'hidrolavadoras-karcher-serie-k', NOW(), NOW()),
  ('pcoll_karcher_hd', 'Hidrolavadoras Karcher - Serie HD Industrial', 'hidrolavadoras-karcher-serie-hd', NOW(), NOW())
ON CONFLICT DO NOTHING;

-- Colecciones comerciales
INSERT INTO product_collection (id, title, handle, created_at, updated_at)
VALUES
  ('pcoll_promocion', 'En Promoción', 'en-promocion', NOW(), NOW()),
  ('pcoll_nuevos', 'Nuevos Ingresos', 'nuevos-ingresos', NOW(), NOW()),
  ('pcoll_outlet', 'Outlet - Equipos Usados', 'outlet-equipos-usados', NOW(), NOW()),
  ('pcoll_mas_vendidos', 'Más Vendidos', 'mas-vendidos', NOW(), NOW())
ON CONFLICT DO NOTHING;

-- =========================================================================
-- 4. PRODUCT CATEGORIES (Árbol de categorías)
-- =========================================================================

-- Nivel 1: Categorías principales
INSERT INTO product_category (id, name, description, handle, mpath, is_active, rank, created_at, updated_at)
VALUES
  ('pcat_equipos_industriales', 'Equipos Industriales', 'Equipos y maquinaria para uso industrial', 'equipos-industriales', 'pcat_equipos_industriales.', true, 0, NOW(), NOW())
ON CONFLICT DO NOTHING;

-- Nivel 2: Generadores Eléctricos
INSERT INTO product_category (id, name, description, handle, mpath, is_active, rank, parent_category_id, created_at, updated_at)
VALUES
  ('pcat_generadores', 'Generadores Eléctricos', 'Generadores y grupos electrógenos de todas las potencias', 'generadores-electricos', 'pcat_equipos_industriales.pcat_generadores.', true, 0, 'pcat_equipos_industriales', NOW(), NOW())
ON CONFLICT DO NOTHING;

-- Nivel 3: Generadores por combustible
INSERT INTO product_category (id, name, description, handle, mpath, is_active, rank, parent_category_id, created_at, updated_at)
VALUES
  ('pcat_gen_diesel', 'Generadores Diesel', 'Generadores diesel de 10 a 2000+ KVA', 'generadores-diesel', 'pcat_equipos_industriales.pcat_generadores.pcat_gen_diesel.', true, 0, 'pcat_generadores', NOW(), NOW()),
  ('pcat_gen_nafta', 'Generadores Nafta', 'Generadores a nafta de 1 a 30 KVA', 'generadores-nafta', 'pcat_equipos_industriales.pcat_generadores.pcat_gen_nafta.', true, 1, 'pcat_generadores', NOW(), NOW()),
  ('pcat_gen_gas', 'Generadores Gas', 'Generadores a gas natural/envasado', 'generadores-gas', 'pcat_equipos_industriales.pcat_generadores.pcat_gen_gas.', true, 2, 'pcat_generadores', NOW(), NOW())
ON CONFLICT DO NOTHING;

-- Nivel 4: Generadores diesel por potencia
INSERT INTO product_category (id, name, description, handle, mpath, is_active, rank, parent_category_id, created_at, updated_at)
VALUES
  ('pcat_gen_diesel_10_100', '10 a 100 KVA', 'Generadores diesel de 10 a 100 KVA', 'generadores-diesel-10-100kva', 'pcat_equipos_industriales.pcat_generadores.pcat_gen_diesel.pcat_gen_diesel_10_100.', true, 0, 'pcat_gen_diesel', NOW(), NOW()),
  ('pcat_gen_diesel_100_200', '100 a 200 KVA', 'Generadores diesel de 100 a 200 KVA', 'generadores-diesel-100-200kva', 'pcat_equipos_industriales.pcat_generadores.pcat_gen_diesel.pcat_gen_diesel_100_200.', true, 1, 'pcat_gen_diesel', NOW(), NOW()),
  ('pcat_gen_diesel_200_500', '200 a 500 KVA', 'Generadores diesel de 200 a 500 KVA', 'generadores-diesel-200-500kva', 'pcat_equipos_industriales.pcat_generadores.pcat_gen_diesel.pcat_gen_diesel_200_500.', true, 2, 'pcat_gen_diesel', NOW(), NOW()),
  ('pcat_gen_diesel_500', 'Más de 500 KVA', 'Generadores diesel de más de 500 KVA', 'generadores-diesel-mas-500kva', 'pcat_equipos_industriales.pcat_generadores.pcat_gen_diesel.pcat_gen_diesel_500.', true, 3, 'pcat_gen_diesel', NOW(), NOW())
ON CONFLICT DO NOTHING;

-- Nivel 2: Compresores
INSERT INTO product_category (id, name, description, handle, mpath, is_active, rank, parent_category_id, created_at, updated_at)
VALUES
  ('pcat_compresores', 'Compresores de Aire', 'Compresores de aire industriales y profesionales', 'compresores-de-aire', 'pcat_equipos_industriales.pcat_compresores.', true, 1, 'pcat_equipos_industriales', NOW(), NOW())
ON CONFLICT DO NOTHING;

-- Nivel 3: Compresores por tipo
INSERT INTO product_category (id, name, description, handle, mpath, is_active, rank, parent_category_id, created_at, updated_at)
VALUES
  ('pcat_comp_piston', 'Compresores a Pistón', 'Compresores de pistón para uso intermitente', 'compresores-piston', 'pcat_equipos_industriales.pcat_compresores.pcat_comp_piston.', true, 0, 'pcat_compresores', NOW(), NOW()),
  ('pcat_comp_tornillo', 'Compresores a Tornillo', 'Compresores de tornillo para uso continuo', 'compresores-tornillo', 'pcat_equipos_industriales.pcat_compresores.pcat_comp_tornillo.', true, 1, 'pcat_compresores', NOW(), NOW())
ON CONFLICT DO NOTHING;

-- Nivel 2: Hidrolavadoras
INSERT INTO product_category (id, name, description, handle, mpath, is_active, rank, parent_category_id, created_at, updated_at)
VALUES
  ('pcat_hidrolavadoras', 'Hidrolavadoras', 'Hidrolavadoras de agua fría y caliente', 'hidrolavadoras', 'pcat_equipos_industriales.pcat_hidrolavadoras.', true, 2, 'pcat_equipos_industriales', NOW(), NOW())
ON CONFLICT DO NOTHING;

-- Nivel 3: Hidrolavadoras por uso
INSERT INTO product_category (id, name, description, handle, mpath, is_active, rank, parent_category_id, created_at, updated_at)
VALUES
  ('pcat_hidro_domestica', 'Uso Doméstico', 'Hidrolavadoras para uso doméstico y ocasional', 'hidrolavadoras-domesticas', 'pcat_equipos_industriales.pcat_hidrolavadoras.pcat_hidro_domestica.', true, 0, 'pcat_hidrolavadoras', NOW(), NOW()),
  ('pcat_hidro_industrial', 'Uso Industrial', 'Hidrolavadoras profesionales e industriales', 'hidrolavadoras-industriales', 'pcat_equipos_industriales.pcat_hidrolavadoras.pcat_hidro_industrial.', true, 1, 'pcat_hidrolavadoras', NOW(), NOW())
ON CONFLICT DO NOTHING;

-- Nivel 2: Motores
INSERT INTO product_category (id, name, description, handle, mpath, is_active, rank, parent_category_id, created_at, updated_at)
VALUES
  ('pcat_motores', 'Motores Diesel y Nafta', 'Motores estacionarios para equipos industriales', 'motores', 'pcat_equipos_industriales.pcat_motores.', true, 3, 'pcat_equipos_industriales', NOW(), NOW())
ON CONFLICT DO NOTHING;

-- =========================================================================
-- VERIFICACIÓN
-- =========================================================================

SELECT '=== PRODUCT TYPES ===' as seccion;
SELECT id, value FROM product_type WHERE deleted_at IS NULL ORDER BY value;

SELECT '=== PRODUCT COLLECTIONS ===' as seccion;
SELECT id, title, handle FROM product_collection WHERE deleted_at IS NULL ORDER BY title;

SELECT '=== PRODUCT CATEGORIES (Tree) ===' as seccion;
SELECT
  REPEAT('  ', (LENGTH(mpath) - LENGTH(REPLACE(mpath, '.', '')) - 2)) || name as category_tree,
  handle,
  is_active
FROM product_category
WHERE deleted_at IS NULL
ORDER BY mpath;

SELECT '=== PRODUCT TAGS ===' as seccion;
SELECT id, value FROM product_tag WHERE deleted_at IS NULL ORDER BY value LIMIT 20;

-- =========================================================================
-- FIN DEL SCRIPT
-- =========================================================================
