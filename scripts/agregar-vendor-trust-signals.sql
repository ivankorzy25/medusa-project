-- Agregar información del vendedor y trust signals al metadata del producto Cummins CS200A
-- Este script agrega campos que permiten que el frontend sea 100% dinámico

UPDATE product
SET metadata = metadata || '{
  "vendor_nombre": "KOR",
  "vendor_nombre_completo": "KOR - Soluciones Energéticas Profesionales",
  "vendor_rating": "5.0",
  "vendor_total_ventas": 0,
  "vendor_anos_experiencia": "15",
  "vendor_tiempo_respuesta": "Dentro de 24hs",
  "vendor_descripcion": "Especialistas en generación de energía eléctrica y grupos electrógenos industriales. Venta, alquiler y servicio técnico multimarca.",
  "trust_garantia_incluida": true,
  "trust_garantia_texto": "Garantía oficial",
  "trust_garantia_descripcion": "Respaldado por el fabricante",
  "trust_envio_gratis": true,
  "trust_envio_texto": "Envío gratis",
  "trust_envio_descripcion": "En el ámbito de Buenos Aires",
  "trust_acepta_devoluciones": false,
  "ubicacion_ciudad": "Florida",
  "ubicacion_provincia": "Buenos Aires",
  "ubicacion_pais": "Argentina"
}'::jsonb
WHERE handle = 'cummins-cs200a';

-- Verificar que se actualizó correctamente
SELECT
  handle,
  metadata->>'vendor_nombre' as vendor,
  metadata->>'vendor_rating' as rating,
  metadata->>'trust_garantia_texto' as garantia,
  metadata->>'trust_envio_texto' as envio,
  metadata->>'ubicacion_ciudad' as ciudad
FROM product
WHERE handle = 'cummins-cs200a';
