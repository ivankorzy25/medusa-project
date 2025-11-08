# Guía de Carga de Productos en Medusa Admin

## 📋 Checklist: Cargar un Nuevo Generador

### 1️⃣ TAB "GENERAL" (Información Básica)

```
┌──────────────────────────────────────────────────────┐
│ Title *                                               │
│ ┌──────────────────────────────────────────────────┐ │
│ │ Generador Diesel Cummins CS200A - 200 KVA...    │ │
│ └──────────────────────────────────────────────────┘ │
│                                                       │
│ Subtitle                                              │
│ ┌──────────────────────────────────────────────────┐ │
│ │ Motor Cummins 6BTAA5.9-G2 + Alternador Stamf... │ │
│ └──────────────────────────────────────────────────┘ │
│                                                       │
│ Handle (slug URL) *                                   │
│ ┌──────────────────────────────────────────────────┐ │
│ │ cummins-cs200a                                   │ │
│ └──────────────────────────────────────────────────┘ │
│                                                       │
│ Description                                           │
│ ┌──────────────────────────────────────────────────┐ │
│ │ Generador industrial diesel Cummins CS200A...   │ │
│ │ (HTML/Markdown con todas las características)   │ │
│ └──────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────┘
```

**Qué poner**:
- **Title**: Nombre completo con marca, modelo y potencias
- **Subtitle**: Motor + Alternador + Uso
- **Handle**: URL amigable (auto-genera de title, revisar)
- **Description**: Descripción larga con características, aplicaciones, etc.

---

### 2️⃣ TAB "ORGANIZE" (Categorización)

```
┌──────────────────────────────────────────────────────┐
│ Type                                                  │
│ ┌──────────────────────────────────────────────────┐ │
│ │ Generadores                                      │ │
│ └──────────────────────────────────────────────────┘ │
│                                                       │
│ Collection                                            │
│ ┌──────────────────────────────────────────────────┐ │
│ │ Cummins                                          │ │
│ └──────────────────────────────────────────────────┘ │
│                                                       │
│ Categories                                            │
│ ☑ Generadores Diesel                                 │
│ ☐ Generadores Gas                                    │
│ ☐ Generadores Nafta                                  │
│                                                       │
│ Tags                                                  │
│ [diesel] [cummins] [200kva] [industrial]             │
└──────────────────────────────────────────────────────┘
```

**Qué poner**:
- **Type**: Tipo de producto (crear "Generadores" si no existe)
- **Collection**: Marca o línea (Cummins, Perkins, etc.)
- **Categories**: Categorías múltiples (Diesel, Industrial, etc.)
- **Tags**: Etiquetas para búsqueda (combustible, marca, potencia)

---

### 3️⃣ TAB "ATTRIBUTES" ⭐ **IMPORTANTE**

#### Sección: Dimensions

```
┌──────────────────────────────────────────────────────┐
│ DIMENSIONS                                            │
├──────────────────────────────────────────────────────┤
│ Height (mm)          Width (mm)                      │
│ ┌────────────┐      ┌────────────┐                  │
│ │ 1900       │      │ 1400       │                  │
│ └────────────┘      └────────────┘                  │
│                                                       │
│ Length (mm)          Weight (kg)                     │
│ ┌────────────┐      ┌────────────┐                  │
│ │ 3200       │      │ 2850       │                  │
│ └────────────┘      └────────────┘                  │
└──────────────────────────────────────────────────────┘
```

**⚠️ CRÍTICO**:
- **Height**: Alto en milímetros (ej: 1900)
- **Width**: Ancho en milímetros (ej: 1400)
- **Length**: Largo en milímetros (ej: 3200)
- **Weight**: Peso en kilogramos (ej: 2850)

**Frontend usa**: Badges "⚖️ 2850 kg" y "📏 320×140×190 cm"

#### Sección: Customs

```
┌──────────────────────────────────────────────────────┐
│ CUSTOMS                                               │
├──────────────────────────────────────────────────────┤
│ MID code                                              │
│ ┌──────────────────────────────────────────────────┐ │
│ │ GEN-CS200A                                       │ │
│ └──────────────────────────────────────────────────┘ │
│                                                       │
│ HS code (Código arancelario)                          │
│ ┌──────────────────────────────────────────────────┐ │
│ │ 850211                                           │ │
│ └──────────────────────────────────────────────────┘ │
│                                                       │
│ Country of origin                                     │
│ ┌──────────────────────────────────────────────────┐ │
│ │ China                                            │ │
│ └──────────────────────────────────────────────────┘ │
│                                                       │
│ Material                                              │
│ ┌──────────────────────────────────────────────────┐ │
│ │ Acero industrial                                 │ │
│ └──────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────┘
```

**Qué poner**:
- **MID code**: Código interno de tu empresa (ej: GEN-CS200A)
- **HS code**: Código arancelario (850211 para generadores diesel)
- **Country of origin**: País de fabricación
- **Material**: Material principal de construcción

---

### 4️⃣ TAB "VARIANTS" (Variantes de Producto)

```
┌──────────────────────────────────────────────────────┐
│ VARIANT #1 (Principal)                                │
├──────────────────────────────────────────────────────┤
│ Title: Standard                                       │
│                                                       │
│ SKU *                                                 │
│ ┌──────────────────────────────────────────────────┐ │
│ │ GEN-CS200A-STD                                   │ │
│ └──────────────────────────────────────────────────┘ │
│                                                       │
│ EAN/UPC/Barcode                                       │
│ ┌──────────────────────────────────────────────────┐ │
│ │ (opcional)                                       │ │
│ └──────────────────────────────────────────────────┘ │
│                                                       │
│ Inventory Quantity: 1                                 │
│ Manage Inventory: ☑                                  │
│ Allow backorders: ☐                                  │
└──────────────────────────────────────────────────────┘
```

**Qué poner**:
- **SKU**: Código único de variante (ej: GEN-CS200A-STD, GEN-CS200A-CAB)
- **Inventory**: Cantidad disponible

---

### 5️⃣ TAB "MEDIA" (Imágenes)

```
┌──────────────────────────────────────────────────────┐
│ THUMBNAIL (Imagen principal) *                        │
│ ┌──────────────────────────────────────────────────┐ │
│ │  [Upload Image]                                  │ │
│ │  Arrastra imagen o click para seleccionar       │ │
│ └──────────────────────────────────────────────────┘ │
│                                                       │
│ IMAGES (Galería)                                      │
│ ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐        │
│ │ Img 1  │ │ Img 2  │ │ Img 3  │ │ Img 4  │ [+]   │
│ └────────┘ └────────┘ └────────┘ └────────┘        │
└──────────────────────────────────────────────────────┘
```

**Qué poner**:
- **Thumbnail**: Imagen principal (se usa en listados)
- **Images**: Galería completa (orden = orden en carrusel)

---

### 6️⃣ TAB "METADATA" (Características Técnicas Específicas)

⚠️ **IMPORTANTE**: Solo usar metadata para características que NO tienen campo nativo.

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
  "motor_refrigeracion": "Agua",

  "potencia_standby_kva": "200",
  "potencia_prime_kva": "180",

  "alternador_marca": "Stamford",
  "alternador_modelo": "HCI544D",
  "voltaje": "220/380V",
  "frecuencia": "50/60Hz",

  "combustible_capacidad_tanque": "400",

  "pricing_config": {
    "precio_lista_usd": 26411,
    "currency_type": "usd_bna",
    "iva_percentage": 10.5
  }
}
```

**Campos metadata para Generadores**:

| Campo | Tipo | Ejemplo | Frontend Badge |
|-------|------|---------|----------------|
| `combustible_tipo` | String | "Diesel" | ⛽ Diesel |
| `tiene_tta` | String | "incluido"/"opcional"/"no" | ⚡ TTA Incluido |
| `tiene_cabina` | Boolean | true/false | 🏠 Con Cabina |
| `nivel_ruido_db` | String | "68" | 🔊 68 dB |
| `motor_marca` | String | "Cummins" | Specs tab |
| `motor_modelo` | String | "6CTAA8.3-G2" | Specs tab |
| `potencia_standby_kva` | String | "200" | Specs tab |
| `alternador_marca` | String | "Stamford" | Specs tab |
| `voltaje` | String | "220/380V" | Specs tab |

---

## 📊 Resumen: ¿Dónde Cargar Cada Dato?

### ✅ CAMPOS NATIVOS (Usar TAB "Attributes")

| Dato | Campo Nativo | Tab | Valor Ejemplo |
|------|--------------|-----|---------------|
| Peso | `weight` | Attributes → Dimensions | 2850 |
| Alto | `height` | Attributes → Dimensions | 1900 |
| Ancho | `width` | Attributes → Dimensions | 1400 |
| Largo | `length` | Attributes → Dimensions | 3200 |
| Código interno | `mid_code` | Attributes → Customs | GEN-CS200A |
| Código arancelario | `hs_code` | Attributes → Customs | 850211 |
| País origen | `origin_country` | Attributes → Customs | China |
| Material | `material` | Attributes → Customs | Acero |

### 🎨 METADATA CUSTOM (Usar TAB "Metadata")

| Dato | Campo Metadata | Valor Ejemplo |
|------|----------------|---------------|
| Tipo combustible | `combustible_tipo` | "Diesel" |
| Transferencia automática | `tiene_tta` | "opcional" |
| Cabina | `tiene_cabina` | false |
| Nivel ruido | `nivel_ruido_db` | "68" |
| Motor | `motor_marca`, `motor_modelo` | "Cummins", "6CTAA..." |
| Potencia | `potencia_standby_kva` | "200" |
| Alternador | `alternador_marca` | "Stamford" |

---

## 🚀 Workflow Recomendado

1. **General** → Título, subtítulo, handle, descripción
2. **Organize** → Tipo, colección, categorías, tags
3. **Attributes** → Peso, dimensiones, país, códigos ⭐
4. **Variants** → SKU, inventario
5. **Media** → Thumbnail + galería
6. **Metadata** → Solo características técnicas específicas
7. **Publish** → Cambiar status a "Published"

---

## ⚠️ ERRORES COMUNES A EVITAR

❌ **MAL**: Poner peso/dimensiones en metadata
```json
{
  "peso_kg": "2850",  // ❌ Ya existe weight nativo
  "largo_mm": "3200"  // ❌ Ya existe length nativo
}
```

✅ **BIEN**: Usar campos nativos en Attributes tab
```
Height: 1900
Width: 1400
Length: 3200
Weight: 2850
```

---

## 📚 Scripts SQL Disponibles

Si prefieres cargar via SQL en lugar de Admin UI:

- `scripts/setup-all-native-attributes.sql` - Todos los campos nativos
- `scripts/setup-complete-metadata.sql` - Metadata técnica completa
- `scripts/add-financiacion-metadata.sql` - Planes de financiación
- `scripts/add-discount-metadata.sql` - Descuentos y ofertas
- `scripts/update-sales-metadata.sql` - Datos de ventas

---

## 🔍 Verificar Carga Correcta

### En Medusa Admin:
1. Products → CS200A → Attributes tab
2. Verificar que aparezcan Height, Width, Length, Weight
3. Verificar MID code, HS code, Country of origin

### En Frontend:
1. http://localhost:3000/producto/cummins-cs200a
2. Verificar badges: ⚖️ 2850 kg, 📏 320×140×190 cm
3. Verificar que aparezcan todos los badges de características

---

## 📞 Referencia Rápida

**Documentación completa**:
- `docs/CAMPOS_NATIVOS_VS_METADATA.md` - Qué usar y dónde
- `docs/METADATA_STRUCTURE.md` - Estructura completa metadata
- `docs/PRICING_METADATA.md` - Precios y financiación

**Para más ayuda**: Ver capturas de Medusa Admin arriba ⬆️
