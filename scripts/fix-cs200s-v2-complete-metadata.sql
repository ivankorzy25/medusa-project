-- =========================================================================
-- ACTUALIZAR CS200S-V2 CON METADATA COMPLETA (COPIADA DE CS200A)
-- =========================================================================
-- Este script copia TODA la estructura de metadata de CS200A a CS200S-V2
-- y ajusta solo los valores específicos del modelo CS200S
-- =========================================================================

UPDATE product
SET metadata = '{
  "fases": "Trifásico",
  "voltaje": "220/380V",
  "categoria": "Generadores Diesel",
  "motor_rpm": 1500,
  "tiene_tta": "opcional",
  "documentos": [],
  "frecuencia": "50Hz",
  "motor_ciclo": "4 tiempos",
  "motor_marca": "Cummins",
  "motor_modelo": "6CTA83G2 TDI",
  "tiene_cabina": true,
  "total_ventas": 0,
  "tipo_arranque": "Eléctrico",
  "total_reviews": 0,
  "vendor_nombre": "KOR",
  "vendor_rating": 5,
  "es_mas_vendido": false,
  "nivel_ruido_db": 71,
  "pricing_config": {
    "familia": "Generadores Cummins - Línea CS",
    "currency_type": "usd_blue",
    "iva_percentage": 10.5,
    "precio_lista_usd": 28707,
    "bonificacion_percentage": 11,
    "contado_descuento_percentage": 9
  },
  "stock_cantidad": 1,
  "ubicacion_pais": "Argentina",
  "voltaje_salida": "220/380V",
  "estado_producto": "Nuevo",
  "factor_potencia": 0.8,
  "motor_cilindros": 6,
  "precio_anterior": null,
  "rating_promedio": 0,
  "ubicacion_envio": {
    "ciudad": "Florida",
    "provincia": "Buenos Aires",
    "texto_completo": "Florida, Buenos Aires"
  },
  "alternador_marca": "Stamford",
  "combustible_tipo": "Diesel",
  "motor_aspiracion": "Turbo Diesel Intercooled",
  "stock_disponible": true,
  "ubicacion_ciudad": "Florida",
  "alternador_modelo": "UCI274G1",
  "potencia_prime_kw": 144,
  "trust_envio_texto": "Envío gratis",
  "potencia_prime_kva": 180,
  "tipo_refrigeracion": "Agua",
  "trust_envio_gratis": true,
  "vendor_descripcion": "Especialistas en generación de energía eléctrica y grupos electrógenos industriales. Venta, alquiler y servicio técnico multimarca.",
  "insonorizacion_tipo": "Silent Premium",
  "motor_refrigeracion": "Agua",
  "panel_control_marca": "ComAp",
  "planes_financiacion": [
    {
      "cuotas": 3,
      "interes": 0.08,
      "costoPorCuota": 16010000
    },
    {
      "cuotas": 6,
      "interes": 0.08,
      "costoPorCuota": 8220000
    },
    {
      "cuotas": 12,
      "interes": 0.12,
      "costoPorCuota": 4540000
    }
  ],
  "potencia_standby_kw": 160,
  "ubicacion_provincia": "Buenos Aires",
  "vendor_total_ventas": 0,
  "descuento_porcentaje": 0,
  "motor_tipo_cilindros": "En línea",
  "panel_control_modelo": "InteliLite MRS16",
  "potencia_standby_kva": 200,
  "trust_garantia_texto": "Garantía oficial",
  "motor_capacidad_aceite": 24,
  "motor_consumo_75_carga": 35,
  "vendor_nombre_completo": "KOR - Soluciones Energéticas Profesionales",
  "financiacion_disponible": true,
  "trust_envio_descripcion": "En el ámbito de Buenos Aires",
  "trust_garantia_incluida": true,
  "vendor_anos_experiencia": 15,
  "vendor_tiempo_respuesta": "Dentro de 24hs",
  "autonomia_horas_75_carga": 12.3,
  "aplicaciones_industriales": [
    {
      "icon": "🏥",
      "title": "Hospitales y Clínicas",
      "description": "Respaldo crítico para equipos médicos y quirófanos"
    },
    {
      "icon": "💻",
      "title": "Centros de Datos",
      "description": "Energía ininterrumpida para infraestructura TI crítica"
    },
    {
      "icon": "🏭",
      "title": "Industria Manufacturera",
      "description": "Continuidad operacional para líneas de producción"
    },
    {
      "icon": "🏢",
      "title": "Edificios Comerciales",
      "description": "Respaldo para sistemas críticos y elevadores"
    },
    {
      "icon": "🌾",
      "title": "Instalaciones Agrícolas",
      "description": "Energía confiable para sistemas de riego y refrigeración"
    },
    {
      "icon": "📡",
      "title": "Telecomunicaciones",
      "description": "Respaldo para antenas y centros de switching"
    }
  ],
  "trust_acepta_devoluciones": false,
  "trust_garantia_descripcion": "Respaldado por el fabricante",
  "combustible_capacidad_tanque": 430,
  "badge_insonorizado": true
}'::jsonb,
updated_at = NOW()
WHERE handle = 'cummins-cs200s-v2';

-- Verificación
SELECT
  handle,
  length(metadata::text) as metadata_bytes,
  metadata->>'nivel_ruido_db' as ruido_db,
  metadata->>'tiene_cabina' as cabina,
  metadata->>'motor_modelo' as motor,
  metadata->>'panel_control_modelo' as panel,
  metadata->'pricing_config'->>'precio_lista_usd' as precio_usd
FROM product
WHERE handle = 'cummins-cs200s-v2';
