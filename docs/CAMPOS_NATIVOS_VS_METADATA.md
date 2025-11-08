# Campos Nativos de Medusa vs Metadata Custom

## ⚠️ IMPORTANTE: Usar campos nativos de Medusa cuando existan

Medusa ya tiene campos estándar para información común de productos. **SIEMPRE usar estos campos nativos** antes de crear campos custom en metadata.

---

## CAMPOS NATIVOS DE MEDUSA (Usar ESTOS primero)

### 1. Información Básica del Producto

| Campo Nativo | Tipo | Uso | Ejemplo |
|--------------|------|-----|---------|
| `id` | text | ID único (auto-generado) | `prod_cs200a_...` |
| `title` | text | Nombre del producto | `"Generador Diesel Cummins CS200A"` |
| `handle` | text | URL slug (auto-generado) | `"cummins-cs200a"` |
| `subtitle` | text | Subtítulo/descripción corta | `"200 KVA Stand-By / 180 KVA Prime"` |
| `description` | text | Descripción completa (HTML/Markdown) | `"Generador diesel..."` |
| `thumbnail` | text | URL imagen principal | `"https://..."` |
| `status` | text | Estado | `"published"`, `"draft"` |

### 2. Dimensiones y Peso ✅ USAR ESTOS

| Campo Nativo | Tipo | Uso | Unidad | Ejemplo |
|--------------|------|-----|--------|---------|
| `weight` | text | Peso total | kg | `"2850"` |
| `length` | text | Largo | mm | `"3200"` |
| `width` | text | Ancho | mm | `"1400"` |
| `height` | text | Alto | mm | `"1900"` |

**Frontend lee**:
- `product.weight` → Badge "2850 kg"
- `product.length`, `product.width`, `product.height` → Badge "320×140×190 cm"

### 3. Información Comercial

| Campo Nativo | Tipo | Uso | Ejemplo |
|--------------|------|-----|---------|
| `discountable` | boolean | Permite descuentos | `true` |
| `external_id` | text | ID en sistema externo | `"ERP-12345"` |
| `origin_country` | text | País de origen | `"China"`, `"USA"` |
| `hs_code` | text | Código arancelario | `"850211"` |
| `material` | text | Material principal | `"Acero"` |

### 4. Categorización

| Campo Nativo | Tipo | Uso | Cómo se usa |
|--------------|------|-----|-------------|
| `collection_id` | text | Colección | FK a `product_collection` |
| `type_id` | text | Tipo de producto | FK a `product_type` |
| `categories` | relation | Categorías | FK a `product_category` |
| `tags` | relation | Etiquetas | FK a `product_tags` |

---

## CAMPOS CUSTOM EN METADATA (Solo para info específica del negocio)

Use metadata **SOLO** para características específicas de generadores que NO tienen campo nativo en Medusa.

### ✅ USAR METADATA PARA:

```json
{
  "combustible_tipo": "Diesel",
  "tiene_tta": "opcional",
  "tiene_cabina": false,
  "nivel_ruido_db": "68",

  "motor_marca": "Cummins",
  "motor_modelo": "6CTAA8.3-G2",
  "motor_cilindros": "6",
  "motor_rpm": "1800",

  "potencia_standby_kva": "200",
  "potencia_prime_kva": "180",

  "alternador_marca": "Stamford",
  "voltaje": "220/380V",
  "frecuencia": "50/60Hz",

  "pricing_config": { ... },
  "financiacion_disponible": true
}
```

### ❌ NO USAR METADATA PARA:

```json
{
  // ❌ MAL - Usar campos nativos en su lugar
  "peso_kg": "2850",        // → Usar product.weight
  "largo_mm": "3200",       // → Usar product.length
  "ancho_mm": "1400",       // → Usar product.width
  "alto_mm": "1900",        // → Usar product.height
  "pais_origen": "China",   // → Usar product.origin_country
  "codigo_hs": "850211"     // → Usar product.hs_code
}
```

---

## MAPEO COMPLETO: FRONTEND ← BACKEND

### Badges Visuales

| Badge Frontend | Campo Backend | Tipo | Valor |
|----------------|---------------|------|-------|
| ⛽ Combustible | `metadata.combustible_tipo` | metadata | "Diesel" |
| ⚡ TTA | `metadata.tiene_tta` | metadata | "incluido"/"opcional"/"no" |
| 🏠 Cabina | `metadata.tiene_cabina` | metadata | true/false |
| 🔊 Ruido | `metadata.nivel_ruido_db` | metadata | "68" |
| ⚖️ Peso | `product.weight` | **NATIVO** | "2850" |
| 📏 Dimensiones | `product.length/width/height` | **NATIVO** | "3200"/"1400"/"1900" |

### Especificaciones Técnicas

| Sección | Campo Backend | Tipo |
|---------|---------------|------|
| SKU | `product.id` o `product.external_id` | **NATIVO** |
| Título | `product.title` | **NATIVO** |
| Descripción | `product.description` | **NATIVO** |
| Peso | `product.weight` | **NATIVO** |
| Dimensiones | `product.length/width/height` | **NATIVO** |
| País origen | `product.origin_country` | **NATIVO** |
| Motor | `metadata.motor_*` | metadata |
| Potencia | `metadata.potencia_*` | metadata |
| Eléctrico | `metadata.alternador_*`, `metadata.voltaje` | metadata |
| Combustible | `metadata.combustible_*` | metadata |

---

## CÓMO CARGAR DATOS EN MEDUSA

### 1. Script SQL para Campos Nativos

```sql
UPDATE product
SET
  title = 'Generador Diesel Cummins CS200A - 200 KVA Stand-By / 180 KVA Prime',
  subtitle = 'Motor Cummins 6CTAA8.3-G2 - Alternador Stamford',
  description = 'Generador diesel de alta potencia...',
  weight = '2850',
  length = '3200',
  width = '1400',
  height = '1900',
  origin_country = 'China',
  hs_code = '850211',
  status = 'published'
WHERE id = 'prod_cs200a_...';
```

### 2. Script SQL para Metadata Custom

```sql
UPDATE product
SET metadata = '{
  "combustible_tipo": "Diesel",
  "tiene_tta": "opcional",
  "nivel_ruido_db": "68",
  "motor_marca": "Cummins",
  "potencia_standby_kva": "200",
  ...
}'::jsonb
WHERE id = 'prod_cs200a_...';
```

### 3. Via Medusa Admin

1. **Campos Nativos**: Se editan en la UI estándar de Medusa Admin
   - General tab → Title, Subtitle, Description
   - Dimensions tab → Weight, Length, Width, Height
   - Attributes tab → Origin Country, HS Code

2. **Metadata Custom**: Se edita en "Custom Attributes" o via Raw Editor
   - Metadata tab → Add/Edit custom fields

---

## ACTUALIZAR FRONTEND PARA LEER CAMPOS NATIVOS

### Antes (❌ MAL):

```typescript
// page.tsx
peso_kg: product.metadata?.peso_kg
largo_mm: product.metadata?.largo_mm
```

### Ahora (✅ BIEN):

```typescript
// page.tsx
weight: product.weight
length: product.length
width: product.width
height: product.height
```

---

## ESTRUCTURA RECOMENDADA FINAL

### Tabla `product` (Campos Nativos)

```
├── id: "prod_cs200a_..."
├── title: "Generador Diesel Cummins CS200A..."
├── subtitle: "200 KVA Stand-By / 180 KVA Prime"
├── description: "..." (texto largo con HTML)
├── weight: "2850"
├── length: "3200"
├── width: "1400"
├── height: "1900"
├── origin_country: "China"
├── hs_code: "850211"
├── status: "published"
└── metadata: { ... } (ver abajo)
```

### Campo `metadata` (JSON)

```json
{
  "combustible_tipo": "Diesel",
  "tiene_tta": "opcional",
  "tiene_cabina": false,
  "nivel_ruido_db": "68",
  "insonorizacion_tipo": "Estándar",

  "motor_marca": "Cummins",
  "motor_modelo": "6CTAA8.3-G2",
  "motor_cilindros": "6",
  "motor_rpm": "1800",

  "potencia_standby_kva": "200",
  "potencia_prime_kva": "180",

  "alternador_marca": "Stamford",
  "voltaje": "220/380V",
  "frecuencia": "50/60Hz",

  "pricing_config": { ... },
  "financiacion_disponible": true,
  "planes_financiacion": [ ... ]
}
```

---

## BENEFICIOS DE USAR CAMPOS NATIVOS

1. ✅ **Compatibilidad con Medusa Admin** - Se editan en la UI estándar
2. ✅ **Validación automática** - Medusa valida tipos de datos
3. ✅ **Indexación** - Campos nativos están indexados para búsquedas rápidas
4. ✅ **APIs estándar** - Funciona con todas las APIs de Medusa sin custom code
5. ✅ **Integraciones** - Compatible con plugins y extensiones de Medusa
6. ✅ **Migraciones** - Más fácil migrar datos entre ambientes

---

## PRÓXIMOS PASOS

1. ✅ Actualizar campos nativos del CS200A (ya hecho)
2. ⏳ Actualizar frontend para leer `product.weight/length/width/height`
3. ⏳ Limpiar metadata removiendo campos duplicados
4. ⏳ Crear script unificado `setup-complete-product.sql`
5. ⏳ Actualizar METADATA_STRUCTURE.md con esta info
