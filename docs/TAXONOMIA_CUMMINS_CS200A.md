# 🏷️ TAXONOMÍA COMPLETA: CUMMINS CS200A

**Producto:** Generador Diesel Cummins CS200A - 200 KVA Stand-By / 180 KVA Prime
**Handle:** `cummins-cs200a`
**Fecha:** 2025-11-08

---

## 📊 CONFIGURACIÓN DE ORGANIZACIÓN

### 1️⃣ TYPE (Tipo de Producto)

**Value:** `Generador Diesel`
**ID:** `ptype_generador_diesel`

**¿Para qué sirve?**
- Clasificación principal del producto
- Filtro en listados
- Breadcrumbs
- SEO

**Uso en Frontend:**
```typescript
// Filtrar productos por tipo
productos.filter(p => p.type === 'Generador Diesel')

// Mostrar en breadcrumb
<Breadcrumb>
  Equipos > Generadores > Generador Diesel
</Breadcrumb>
```

---

### 2️⃣ COLLECTION (Colección/Familia)

**Title:** `Generadores Cummins - Línea CS`
**Handle:** `generadores-cummins-linea-cs`
**ID:** `pcoll_cummins_cs`

**Productos de esta colección:**
- Cummins CS100A (100 KVA)
- **Cummins CS200A (200 KVA)** ← Este producto
- Cummins CS250A (250 KVA)
- Cummins CS300A (300 KVA)
- Cummins CS400A (400 KVA)

**¿Para qué sirve?**
- Agrupar productos de la misma línea/familia
- Landing pages por colección
- "Productos relacionados" (misma colección)
- Cross-selling
- Promociones por familia

**Uso en Frontend:**
```typescript
// Productos relacionados de la misma colección
const relacionados = await getProductsByCollection('generadores-cummins-linea-cs')

// Landing page
/collections/generadores-cummins-linea-cs
```

---

### 3️⃣ CATEGORIES (Categorías Jerárquicas)

**Categoría Principal:**
```
Equipos Industriales
  └── Generadores Eléctricos
      └── Generadores Diesel
          └── 100 a 200 KVA ← CS200A va aquí
```

**IDs:**
```
pcat_equipos_industriales     (Nivel 1)
  → pcat_generadores          (Nivel 2)
      → pcat_gen_diesel       (Nivel 3)
          → pcat_gen_diesel_100_200  (Nivel 4) ← CS200A
```

**¿Para qué sirve?**
- Navegación jerárquica en el sitio
- Menú de categorías
- Filtros en cascada
- SEO (URLs estructuradas)
- Breadcrumbs completos

**Uso en Frontend:**
```typescript
// URL de la categoría
/categorias/generadores-diesel/100-200kva

// Breadcrumb automático
Equipos Industriales > Generadores Eléctricos > Generadores Diesel > 100 a 200 KVA > Cummins CS200A

// Navegación
<Menu>
  Equipos Industriales
    > Generadores Eléctricos
      > Generadores Diesel
        > 10 a 100 KVA
        > 100 a 200 KVA (38 productos)
        > 200 a 500 KVA
        > +500 KVA
</Menu>
```

---

### 4️⃣ TAGS (Etiquetas)

**Tags asignados al CS200A:**

#### Combustible y Motor
```
- diesel             (ptag_diesel)
- cummins            (ptag_cummins)
```

#### Aplicación
```
- industrial         (ptag_industrial)
- estacionario       (ptag_estacionario)
```

#### Características
```
- automatico         (ptag_automatico)
- insonorizado       (ptag_insonorizado)
```

#### Configuración Eléctrica
```
- trifasico          (ptag_trifasico)
```

#### Modo de Operación
```
- standby            (ptag_standby)
- prime              (ptag_prime)
```

#### Marca Alternador
```
- stamford           (ptag_stamford)
```

#### Rango de Potencia
```
- 100-200kva         (ptag_100200kva)
```

**¿Para qué sirven?**
- Filtros múltiples
- Búsqueda avanzada
- Productos relacionados por características
- SEO (keywords)
- Facetas de búsqueda

**Uso en Frontend:**
```typescript
// Filtros combinados
productos
  .filter(p => p.tags.includes('diesel'))
  .filter(p => p.tags.includes('100-200kva'))
  .filter(p => p.tags.includes('trifasico'))

// Sidebar de filtros
<Filtros>
  Combustible:
    ☑ Diesel (127)
    ☐ Nafta (43)
    ☐ Gas (12)

  Potencia:
    ☐ 10-100 KVA (89)
    ☑ 100-200 KVA (38) ← CS200A
    ☐ 200-500 KVA (24)

  Aplicación:
    ☑ Industrial (156)
    ☐ Doméstico (34)
</Filtros>

// Productos similares (por tags en común)
const similares = productos.filter(p =>
  p.tags.includes('diesel') &&
  p.tags.includes('100-200kva') &&
  p.id !== currentProduct.id
)
```

---

## 🎯 RESUMEN DE CONFIGURACIÓN

| Campo | Valor | ID en DB |
|-------|-------|----------|
| **Type** | Generador Diesel | `ptype_generador_diesel` |
| **Collection** | Generadores Cummins - Línea CS | `pcoll_cummins_cs` |
| **Category (L4)** | 100 a 200 KVA | `pcat_gen_diesel_100_200` |
| **Category (L3)** | Generadores Diesel | `pcat_gen_diesel` |
| **Category (L2)** | Generadores Eléctricos | `pcat_generadores` |
| **Category (L1)** | Equipos Industriales | `pcat_equipos_industriales` |

**Tags (11 total):**
- `diesel`, `cummins`, `industrial`, `estacionario`
- `automatico`, `insonorizado`, `trifasico`
- `standby`, `prime`, `stamford`, `100-200kva`

---

## 🔄 USO EN PRODUCTOS RELACIONADOS

### Algoritmo para "Productos Relacionados"

**Criterio 1: Misma Colección (Mayor prioridad)**
```sql
-- Productos de la misma familia
SELECT * FROM product
WHERE collection_id = 'pcoll_cummins_cs'
  AND id != 'prod_cs200a'
LIMIT 4;
```

**Criterio 2: Misma Categoría de Potencia**
```sql
-- Otros generadores 100-200 KVA
SELECT * FROM product p
JOIN product_category_product pcp ON p.id = pcp.product_id
WHERE pcp.product_category_id = 'pcat_gen_diesel_100_200'
  AND p.id != 'prod_cs200a'
LIMIT 4;
```

**Criterio 3: Tags en Común**
```sql
-- Productos con tags similares
SELECT p.*, COUNT(pt.product_tag_id) as tags_en_comun
FROM product p
JOIN product_tags pt ON p.id = pt.product_id
WHERE pt.product_tag_id IN (
  'ptag_diesel', 'ptag_cummins', 'ptag_industrial',
  'ptag_trifasico', 'ptag_standby', 'ptag_100200kva'
)
  AND p.id != 'prod_cs200a'
GROUP BY p.id
ORDER BY tags_en_comun DESC
LIMIT 4;
```

---

## 🚀 EJEMPLO EN FRONTEND

```tsx
// Componente ProductosRelacionados.tsx
export function ProductosRelacionados({ producto }) {
  // 1. Intentar por colección (misma familia)
  let relacionados = await getProductsByCollection(producto.collection_id)

  // 2. Si no hay suficientes, agregar por categoría
  if (relacionados.length < 4) {
    const porCategoria = await getProductsByCategory(producto.category_id)
    relacionados = [...relacionados, ...porCategoria]
  }

  // 3. Si aún no hay suficientes, agregar por tags
  if (relacionados.length < 4) {
    const porTags = await getProductsByTags(producto.tags)
    relacionados = [...relacionados, ...porTags]
  }

  // 4. Eliminar duplicados y el producto actual
  relacionados = relacionados
    .filter(p => p.id !== producto.id)
    .slice(0, 4)

  return (
    <div className="grid grid-cols-4 gap-4">
      {relacionados.map(prod => (
        <ProductCard key={prod.id} product={prod} />
      ))}
    </div>
  )
}
```

---

## 📝 PARA MEDUSA ADMIN

Al editar el producto en Medusa Admin, configurar:

### Organize → Type
- Seleccionar: **Generador Diesel**

### Organize → Collection
- Seleccionar: **Generadores Cummins - Línea CS**

### Organize → Categories
- Marcar: **100 a 200 KVA** (automáticamente marca padres)

### Organize → Tags
Agregar (separados por coma o Enter):
```
diesel, cummins, industrial, estacionario, automatico,
insonorizado, trifasico, standby, prime, stamford, 100-200kva
```

---

## ✅ VERIFICACIÓN

```sql
-- Ver configuración completa del producto
SELECT
  p.id,
  p.title,
  p.handle,
  pt.value as tipo,
  pc.title as coleccion,
  string_agg(DISTINCT pcat.name, ' > ' ORDER BY pcat.name) as categorias,
  string_agg(DISTINCT ptag.value, ', ' ORDER BY ptag.value) as tags
FROM product p
LEFT JOIN product_type pt ON p.type_id = pt.id
LEFT JOIN product_collection pc ON p.collection_id = pc.id
LEFT JOIN product_category_product pcp ON p.id = pcp.product_id
LEFT JOIN product_category pcat ON pcp.product_category_id = pcat.id
LEFT JOIN product_tags ptags ON p.id = ptags.product_id
LEFT JOIN product_tag ptag ON ptags.product_tag_id = ptag.id
WHERE p.handle = 'cummins-cs200a'
GROUP BY p.id, p.title, p.handle, pt.value, pc.title;
```

---

**Creado:** 2025-11-08
**Última actualización:** 2025-11-08
**Estado:** ✅ DOCUMENTADO
