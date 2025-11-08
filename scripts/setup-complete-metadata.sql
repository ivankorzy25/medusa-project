-- ============================================================================
-- SCRIPT PARA CARGAR METADATA COMPLETA DEL PRODUCTO CS200A
-- ============================================================================
-- Este script carga TODOS los campos de metadata según la estructura
-- definida en docs/METADATA_STRUCTURE.md
--
-- EJECUTAR: psql postgresql://ivankorzyniewski@localhost:5432/medusa-store -f scripts/setup-complete-metadata.sql
-- ============================================================================

\set ON_ERROR_STOP on

BEGIN;

\echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
\echo '📦 CARGAR METADATA COMPLETA - CUMMINS CS200A'
\echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
\echo ''

-- ============================================================================
-- ACTUALIZAR METADATA COMPLETA
-- ============================================================================

UPDATE product
SET metadata = '{
  "sku": "GEN-CS200A-STD",

  "combustible_tipo": "Diesel",
  "tiene_tta": "opcional",
  "tiene_cabina": false,
  "nivel_ruido_db": "68",
  "insonorizacion_tipo": "Estándar",
  "peso_kg": "2850",
  "largo_mm": "3200",
  "ancho_mm": "1400",
  "alto_mm": "1900",

  "motor_marca": "Cummins",
  "motor_modelo": "6CTAA8.3-G2",
  "motor_cilindros": "6",
  "motor_tipo_cilindros": "En línea",
  "motor_ciclo": "4 tiempos",
  "motor_aspiracion": "Turboalimentado con aftercooler",
  "motor_refrigeracion": "Agua",
  "motor_rpm": "1800",
  "motor_consumo_75_carga": "35.5",
  "motor_capacidad_aceite": "28",

  "potencia_standby_kva": "200",
  "potencia_prime_kva": "180",
  "potencia_standby_kw": "160",
  "potencia_prime_kw": "144",
  "factor_potencia": "0.8",

  "alternador_marca": "Stamford",
  "alternador_modelo": "HCI544D",
  "voltaje": "220/380V",
  "frecuencia": "50/60Hz",
  "fases": "Trifásico",

  "combustible_capacidad_tanque": "400",
  "autonomia_horas_75_carga": "11.3",

  "panel_control_marca": "Deep Sea",
  "panel_control_modelo": "DSE7320",
  "panel_control_funciones": [
    "Arranque/paro automático",
    "Protección contra sobrecarga",
    "Monitoreo de parámetros",
    "Display LCD multifunción"
  ],

  "protecciones": [
    "Baja presión de aceite",
    "Alta temperatura de agua",
    "Sobrecarga",
    "Cortocircuito",
    "Bajo/alto voltaje",
    "Sobrevelocidad"
  ],

  "pricing_config": {
    "precio_lista_usd": 26411,
    "currency_type": "usd_bna",
    "iva_percentage": 10.5,
    "bonificacion_percentage": 11,
    "contado_descuento_percentage": 9,
    "familia": "Generadores Cummins - Línea CS",
    "precios_calculados": {
      "publico_usd": 26411,
      "mercadolibre_usd": 25090,
      "mayorista_contado_usd": 21390,
      "mayorista_financiado_usd": 23506
    }
  },

  "descuento_porcentaje": 42,
  "precio_anterior": 75000000,
  "total_ventas": 247,
  "es_mas_vendido": true,
  "categoria": "Generadores Diesel",

  "financiacion_disponible": true,
  "planes_financiacion": [
    {"cuotas": 3, "interes": 0.08, "costoPorCuota": 14740000},
    {"cuotas": 6, "interes": 0.08, "costoPorCuota": 7570000},
    {"cuotas": 12, "interes": 0.12, "costoPorCuota": 4180000}
  ]
}'::jsonb
WHERE id = 'prod_cs200a_73150acc-b0b6-413b-8f55-2497142ba4f0';

\echo '✅ Metadata completa cargada'
\echo ''

-- ============================================================================
-- VERIFICAR CARGA
-- ============================================================================

\echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
\echo '📋 VERIFICACIÓN DE CAMPOS CARGADOS'
\echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
\echo ''

\echo '1. CARACTERÍSTICAS PRINCIPALES (Badges):'
SELECT
  metadata->>'combustible_tipo' as combustible,
  metadata->>'tiene_tta' as tta,
  metadata->>'tiene_cabina' as cabina,
  metadata->>'nivel_ruido_db' as ruido_db,
  metadata->>'peso_kg' as peso
FROM product
WHERE id = 'prod_cs200a_73150acc-b0b6-413b-8f55-2497142ba4f0';

\echo ''
\echo '2. ESPECIFICACIONES MOTOR:'
SELECT
  metadata->>'motor_marca' as marca,
  metadata->>'motor_modelo' as modelo,
  metadata->>'motor_cilindros' as cilindros,
  metadata->>'motor_rpm' as rpm
FROM product
WHERE id = 'prod_cs200a_73150acc-b0b6-413b-8f55-2497142ba4f0';

\echo ''
\echo '3. POTENCIA:'
SELECT
  metadata->>'potencia_standby_kva' as standby_kva,
  metadata->>'potencia_prime_kva' as prime_kva,
  metadata->>'potencia_standby_kw' as standby_kw,
  metadata->>'potencia_prime_kw' as prime_kw
FROM product
WHERE id = 'prod_cs200a_73150acc-b0b6-413b-8f55-2497142ba4f0';

\echo ''
\echo '4. SISTEMA ELÉCTRICO:'
SELECT
  metadata->>'alternador_marca' as alternador,
  metadata->>'alternador_modelo' as modelo,
  metadata->>'voltaje' as voltaje,
  metadata->>'frecuencia' as frecuencia
FROM product
WHERE id = 'prod_cs200a_73150acc-b0b6-413b-8f55-2497142ba4f0';

COMMIT;

\echo ''
\echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
\echo '✅ METADATA COMPLETA CARGADA'
\echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
\echo ''
\echo 'RESUMEN DE CAMPOS CARGADOS:'
\echo ''
\echo '📌 IDENTIFICACIÓN:'
\echo '   • SKU: GEN-CS200A-STD'
\echo ''
\echo '🎨 BADGES VISUALES (6):'
\echo '   ⛽ Combustible: Diesel'
\echo '   ⚡ TTA: Opcional'
\echo '   🏠 Cabina: No'
\echo '   🔊 Ruido: 68 dB (Estándar)'
\echo '   ⚖️ Peso: 2850 kg'
\echo '   📏 Dimensiones: 3200×1400×1900 mm'
\echo ''
\echo '🔧 ESPECIFICACIONES TÉCNICAS:'
\echo '   • Motor: Cummins 6CTAA8.3-G2'
\echo '   • Potencia: 200 KVA Stand-By / 180 KVA Prime'
\echo '   • Alternador: Stamford HCI544D'
\echo '   • Voltaje: 220/380V Trifásico'
\echo '   • Combustible: Diesel, tanque 400L'
\echo '   • Panel: Deep Sea DSE7320'
\echo '   • Protecciones: 6 sistemas'
\echo ''
\echo '💰 COMERCIAL:'
\echo '   • Precio Lista: USD 26,411'
\echo '   • Descuento: 42% OFF'
\echo '   • Financiación: 3, 6, 12 cuotas'
\echo '   • Ventas: 247 unidades'
\echo '   • Badge: MÁS VENDIDO'
\echo ''
\echo 'PRÓXIMOS PASOS:'
\echo '1. Recarga http://localhost:3000/producto/cummins-cs200a'
\echo '2. Verifica que aparezcan TODOS los badges'
\echo '3. Revisa tab "Especificaciones Técnicas"'
\echo '4. Usa esta estructura para TODOS los productos nuevos'
\echo ''
\echo 'DOCUMENTACIÓN:'
\echo '   Ver: docs/METADATA_STRUCTURE.md'
\echo ''
