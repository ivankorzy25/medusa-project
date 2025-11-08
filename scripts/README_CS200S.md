# Importación CS200S - Guía Rápida

## Ejecución en 1 Comando

```bash
# Desde la raíz del proyecto
./scripts/setup-cs200s-COMPLETE.sh
```

Este script ejecuta **TODO** automáticamente:
1. Copia las 13 imágenes
2. Importa el producto a la BD
3. Verifica la importación

---

## Ejecución Manual (Paso a Paso)

### Paso 1: Copiar Imágenes
```bash
./scripts/copy-cs200s-images.sh
```

### Paso 2: Importar a Base de Datos
```bash
psql postgresql://[USER]:[PASS]@localhost:5432/medusa-store \
  -f scripts/import-cs200s-COMPLETE.sql
```

### Paso 3: Verificar
```bash
psql postgresql://[USER]:[PASS]@localhost:5432/medusa-store \
  -c "SELECT * FROM product WHERE handle = 'cummins-cs200s';"
```

---

## Archivos Creados

### Scripts SQL
- `import-cs200s-COMPLETE.sql` - Script principal (importación completa)

### Scripts Bash
- `copy-cs200s-images.sh` - Copia las 13 imágenes
- `setup-cs200s-COMPLETE.sh` - Script maestro (ejecuta todo)

### Documentación
- `../docs/CS200S_IMPORTACION_COMPLETA.md` - Guía completa
- `../docs/COMPARATIVA_CS200A_VS_CS200S.md` - Comparativa detallada

---

## Verificación Post-Importación

### En Admin Panel
```
http://localhost:9000/a/products/prod_cummins_cs200s
```

Verificar:
- [x] Título y descripción
- [x] 13 imágenes cargadas
- [x] Precio: USD 28,707
- [x] Stock: 5 unidades
- [x] Tags: 11 (incluye "insonorizado")
- [x] Metadata: 60+ campos

### En Storefront
```
http://localhost:8000/products/cummins-cs200s
```

Verificar:
- [x] Página del producto se carga
- [x] Imágenes se muestran
- [x] Precio visible
- [x] "Lo que tenés que saber" muestra specs

---

## Queries SQL Útiles

### Ver producto completo
```sql
SELECT * FROM product WHERE handle = 'cummins-cs200s';
```

### Ver metadata
```sql
SELECT metadata FROM product WHERE id = 'prod_cummins_cs200s';
```

### Ver variant y precio
```sql
SELECT
  pv.sku,
  pv.inventory_quantity,
  psma.amount / 100.0 as precio_usd
FROM product_variant pv
JOIN product_variant_price_set pvps ON pv.price_set_id = pvps.id
JOIN price_set_money_amount psma ON pvps.id = psma.price_set_id
WHERE pv.product_id = 'prod_cummins_cs200s';
```

### Ver imágenes
```sql
SELECT i.url FROM product_images pi
JOIN image i ON pi.image_id = i.id
WHERE pi.product_id = 'prod_cummins_cs200s'
ORDER BY (i.metadata->>'order')::int;
```

### Ver tags
```sql
SELECT string_agg(ptag.value, ', ') as tags
FROM product_tags ptags
JOIN product_tag ptag ON ptags.product_tag_id = ptag.id
WHERE ptags.product_id = 'prod_cummins_cs200s';
```

---

## Troubleshooting

### Error: "relation product does not exist"
**Causa:** Las tablas de Medusa no están creadas
**Solución:** Ejecutar migraciones de Medusa primero
```bash
cd medusa-backend
npx medusa migrations run
```

### Error: "invalid input syntax for type uuid"
**Causa:** IDs personalizados no permitidos
**Solución:** El script usa IDs con prefijo (prod_, variant_) que son válidos

### Error: "insert or update on table violates foreign key"
**Causa:** Faltan Type, Collection, Category o Tags
**Solución:** Crear taxonomía primero (ver docs de taxonomía)

### Imágenes no se ven en el storefront
**Causa:** Archivos no copiados al public
**Solución:** Ejecutar `./scripts/copy-cs200s-images.sh`

### Tag "insonorizado" no aparece
**Causa:** El tag no existe en la BD
**Solución:** Crear tag primero
```sql
INSERT INTO product_tag (id, value, created_at, updated_at)
VALUES ('ptag_insonorizado', 'insonorizado', NOW(), NOW())
ON CONFLICT (id) DO NOTHING;
```

---

## Comparación con CS200A

| Aspecto | CS200A | CS200S |
|---------|---------|---------|
| Ruido | ~95 dB | **71 dB** ✅ |
| Cabina | ❌ NO | ✅ SÍ |
| Peso | 1,900 kg | 2,500 kg |
| Precio | USD 26,411 | USD 28,707 |
| Uso urbano | ⚠️ Limitado | ✅ Permitido |
| Tag "insonorizado" | ❌ NO | ✅ SÍ |

**Diferencia clave:** CS200S = CS200A + Cabina Silent (+USD 2,296)

---

## Contacto

Si necesitas ayuda o encuentras problemas:

1. Revisar documentación completa en `docs/CS200S_IMPORTACION_COMPLETA.md`
2. Comparar con CS200A (que ya funciona)
3. Verificar logs del script SQL
4. Consultar la comparativa en `docs/COMPARATIVA_CS200A_VS_CS200S.md`

---

**Última actualización:** 2025-11-08
**Versión:** 1.0
**Estado:** ✅ Listo para usar
