-- Agregar aplicaciones industriales al metadata del producto Cummins CS200A
-- Este script hace que el frontend sea 100% dinámico y adaptable a cualquier categoría de producto

UPDATE product
SET metadata = metadata || '{
  "aplicaciones_industriales": [
    {
      "title": "Hospitales y Clínicas",
      "description": "Respaldo crítico para equipos médicos y quirófanos",
      "icon": "🏥"
    },
    {
      "title": "Centros de Datos",
      "description": "Energía ininterrumpida para infraestructura TI crítica",
      "icon": "💻"
    },
    {
      "title": "Industria Manufacturera",
      "description": "Continuidad operacional para líneas de producción",
      "icon": "🏭"
    },
    {
      "title": "Edificios Comerciales",
      "description": "Respaldo para sistemas críticos y elevadores",
      "icon": "🏢"
    },
    {
      "title": "Instalaciones Agrícolas",
      "description": "Energía confiable para sistemas de riego y refrigeración",
      "icon": "🌾"
    },
    {
      "title": "Telecomunicaciones",
      "description": "Respaldo para antenas y centros de switching",
      "icon": "📡"
    }
  ],
  "documentos": []
}'::jsonb
WHERE handle = 'cummins-cs200a';

-- Verificar que se actualizó correctamente
SELECT
  handle,
  jsonb_array_length(metadata->'aplicaciones_industriales') as cant_aplicaciones,
  metadata->'aplicaciones_industriales'->0->>'title' as primera_aplicacion
FROM product
WHERE handle = 'cummins-cs200a';
