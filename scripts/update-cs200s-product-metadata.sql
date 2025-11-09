-- =========================================================================
-- ACTUALIZAR CS200S - PRODUCT METADATA (CRÍTICO PARA PRICING)
-- =========================================================================
-- El frontend lee pricing_config desde product.metadata (NO variant.metadata)
-- CS200A tiene pricing_config DUPLICADO en ambos lugares
-- =========================================================================

UPDATE product
SET metadata = '{
  "pricing_config": {
    "familia": "Generadores Cummins - Línea CS",
    "currency_type": "usd_blue",
    "iva_percentage": 10.5,
    "precio_lista_usd": 28707,
    "bonificacion_percentage": 11,
    "descuento_contado_percentage": 9
  },
  "fases": "Trifásico",
  "voltaje": "220/380V",
  "motor_rpm": 1500,
  "motor_marca": "Cummins",
  "motor_modelo": "6CTA83G2 TDI",
  "vendor": "Cummins Power Generation",
  "trust": "Oficial",
  "ubicacion": "Disponible",
  "garantia": "12 meses",
  "aplicacion": "Industrial, Comercial, Residencial Premium",
  "tipo_uso": "Standby / Prime Power",
  "insonorizado": "Sí - 71 dB @ 7m",
  "cabina": "Silent Premium"
}'::jsonb,
updated_at = NOW()
WHERE handle = 'cummins-cs200s';

-- Verificar actualización
SELECT 
  handle,
  jsonb_pretty(metadata->'pricing_config') as pricing_config
FROM product
WHERE handle = 'cummins-cs200s';
