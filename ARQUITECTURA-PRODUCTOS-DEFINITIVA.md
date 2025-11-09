# 🏗️ Arquitectura Definitiva: Productos, Variantes y Accesorios

**Análisis basado en:** Lista de Precios Mayorista E-Gaucho #1083

---

## 📊 ANÁLISIS DEL CATÁLOGO REAL

### Productos Identificados

#### 1. **Generadores (Producto Principal)**
Ejemplos:
- CS200A → USD 26,411
- CS200S → USD 28,707 (mismo modelo, CON CABINA)
- CS450A → USD 56,550
- CS450S → USD 63,588 (mismo modelo, CON CABINA)

**¿Son variantes o productos separados?**
- Mismo motor (CUMMINS 6CTAA8.3-G / NTAA855-G7A)
- Misma potencia (200/450 KVA)
- **Diferencia:** Versión "A" (abierto) vs "S" (silent con cabina)
- Diferencia de precio: ~8-15%

#### 2. **TTA (Transferencia Automática) - ACCESORIO/OPCIONAL**

**Página 21-22 del PDF:**
```
TTA-PSY200-IC → USD 3,322 (para CUMMINS YNS 200 KVA con ICSA)
TTA-PSY200-AB → USD 9,523 (para CUMMINS YNS 200 KVA con ABB)
TTA-KD6.5-M-IC → USD 1,104 (para KDE 6500 MONOFASICO)
```

**Observación clave:** Los TTA son productos **SEPARADOS** con códigos propios, NO son variantes del generador.

#### 3. **Puesta en Marcha - SERVICIO**

**Página 23 del PDF:**
```
PMCS200 - Cummins 200 → USD 156
PMCS275 - Cummins 275 → USD 184
PMCS375 - Cummins 375 → USD 322
```

**Conclusión:** Son servicios con precio definido, **NO variantes**.

---

## 🎯 DECISIÓN ARQUITECTÓNICA

### ✅ PROPUESTA FINAL: Sistema Híbrido

**Combina 3 conceptos de Medusa:**
1. **Product Variants** (para configuraciones del mismo equipo)
2. **Related Products** (para mostrar versiones alternativas)
3. **Bundles/Kits** (para combos con accesorios)

---

## 🏗️ ESTRUCTURA IMPLEMENTADA

### Nivel 1: PRODUCTO BASE (con Variantes Reales)

**Ejemplo: Cummins CS200**

```javascript
{
  title: "Cummins CS200 - 200 KVA",
  handle: "cummins-cs200",
  
  // OPCIONES DEL PRODUCTO
  options: [
    {
      title: "Configuración",
      values: ["Abierto", "Silent (Insonorizado)"]
    }
  ],
  
  // VARIANTES (configuraciones del mismo equipo base)
  variants: [
    {
      id: "var_cs200a",
      title: "CS200 Abierto",
      sku: "GEN-CS200A",
      options: { "Configuración": "Abierto" },
      prices: [{ amount: 2641100, currency_code: "usd" }],
      weight: 1900000, // 1900 kg en gramos
      length: 3800, width: 1500, height: 2100,
      metadata: {
        tiene_cabina: false,
        nivel_ruido_db: 85,
        tipo_producto: "abierto"
      }
    },
    {
      id: "var_cs200s",
      title: "CS200 Silent (con cabina insonorizada)",
      sku: "GEN-CS200S",
      options: { "Configuración": "Silent (Insonorizado)" },
      prices: [{ amount: 2870700, currency_code: "usd" }],
      weight: 2500000, // 2500 kg
      length: 3800, width: 1500, height: 2400,
      metadata: {
        tiene_cabina: true,
        nivel_ruido_db: 55,
        tipo_producto: "silent",
        peso_cabina_kg: 600
      }
    }
  ],
  
  metadata: {
    // Datos comunes del producto base
    motor_marca: "Cummins",
    motor_modelo: "6CTAA8.3-G",
    potencia_standby_kva: 200,
    potencia_prime_kva: 180,
    
    // PRODUCTOS RELACIONADOS
    productos_relacionados: [
      {
        type: "version_alternativa",
        handle: "cummins-cs275",
        descripcion: "Versión más potente - 275 KVA"
      },
      {
        type: "version_menor",
        handle: "cummins-cs170",
        descripcion: "Versión más económica - 170 KVA"
      }
    ],
    
    // ACCESORIOS COMPATIBLES (productos independientes)
    accesorios_compatibles: [
      {
        type: "tta",
        handle: "tta-psy200-icsa",
        nombre: "TTA 200 KVA - ICSA",
        precio_usd: 3322,
        descripcion: "Transferencia Automática ICSA"
      },
      {
        type: "tta",
        handle: "tta-psy200-abb",
        nombre: "TTA 200 KVA - ABB",
        precio_usd: 9523,
        descripcion: "Transferencia Automática ABB (Premium)"
      }
    ],
    
    // SERVICIOS DISPONIBLES
    servicios_disponibles: [
      {
        type: "puesta_marcha",
        codigo: "PMCS200",
        nombre: "Puesta en marcha con fluidos",
        precio_usd: 156,
        descripcion: "Aceite, refrigerante y prueba con carga 1hr"
      }
    ]
  }
}
```

---

## 📱 UX/UI - CÓMO SE MUESTRA AL USUARIO

### Página del Producto: Cummins CS200

```
┌─────────────────────────────────────────────────────────────┐
│ CUMMINS CS200 - 200 KVA Stand-By / 180 KVA Prime          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│ [Imagen del generador]                                     │
│                                                             │
│ Configuración:                                              │
│ ┌────────────────┐  ┌─────────────────────────────┐       │
│ │ ○ Abierto      │  │ ● Silent (Insonorizado) ✓   │       │
│ │ USD 26,411     │  │ USD 28,707                  │       │
│ │ 85 dB          │  │ 55 dB                       │       │
│ │ 1,900 kg       │  │ 2,500 kg (+600 kg cabina)   │       │
│ └────────────────┘  └─────────────────────────────┘       │
│                                                             │
│ Precio: USD 28,707 (sin IVA)                               │
│ SKU: GEN-CS200S                                            │
│                                                             │
│ [Agregar al Carrito]                                       │
│                                                             │
├─────────────────────────────────────────────────────────────┤
│ 🔌 ACCESORIOS RECOMENDADOS                                  │
├─────────────────────────────────────────────────────────────┤
│ ┌──────────────────────────┐  ┌────────────────────────┐  │
│ │ TTA 200 KVA - ICSA       │  │ TTA 200 KVA - ABB      │  │
│ │ Transferencia Automática │  │ Premium (Recomendado)  │  │
│ │ + USD 3,322              │  │ + USD 9,523            │  │
│ │ [Agregar]                │  │ [Agregar]              │  │
│ └──────────────────────────┘  └────────────────────────┘  │
│                                                             │
├─────────────────────────────────────────────────────────────┤
│ 🛠️ SERVICIOS ADICIONALES                                    │
├─────────────────────────────────────────────────────────────┤
│ ☑ Puesta en marcha con fluidos (+ USD 156)                │
│   Incluye: Aceite, refrigerante y prueba con carga 1hr    │
│                                                             │
├─────────────────────────────────────────────────────────────┤
│ 📋 VERSIONES RELACIONADAS                                   │
├─────────────────────────────────────────────────────────────┤
│ • Cummins CS170 - 170 KVA → USD 22,842 (más económico)    │
│ • Cummins CS275 - 275 KVA → USD 32,720 (más potente)      │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 🛒 FUNCIONALIDAD DEL CARRITO

### Caso 1: Usuario agrega CS200S + TTA + Puesta en marcha

```
┌─────────────────────────────────────────────────────────┐
│ CARRITO DE COMPRAS                                      │
├─────────────────────────────────────────────────────────┤
│                                                         │
│ 1. Cummins CS200S - 200 KVA Silent                     │
│    SKU: GEN-CS200S                                     │
│    Configuración: Silent (Insonorizado)                │
│    USD 28,707                                          │
│                                                         │
│ 2. TTA 200 KVA - ABB                                   │
│    SKU: TTA-PSY200-AB                                  │
│    Compatible con: CS200S                              │
│    USD 9,523                                           │
│                                                         │
│ 3. Puesta en marcha con fluidos                        │
│    Código: PMCS200                                     │
│    USD 156                                             │
│                                                         │
├─────────────────────────────────────────────────────────┤
│ Subtotal:                             USD 38,386       │
│ IVA 10.5%:                            USD 4,031        │
│ TOTAL:                                USD 42,417       │
│                                                         │
│ Bonificación disponible: 11% (contado: 9% adicional)  │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## 💾 ESTRUCTURA EN MEDUSA BACKEND

### Productos a Crear

#### 1. PRODUCTO: Cummins CS200
```bash
medusa products create --title "Cummins CS200 - 200 KVA" --handle "cummins-cs200"
medusa products add-option --product "cummins-cs200" --option "Configuración"
medusa products add-variant --product "cummins-cs200" \
  --sku "GEN-CS200A" \
  --title "CS200 Abierto" \
  --price 26411 \
  --weight 1900 \
  --metadata '{"tiene_cabina": false, "nivel_ruido_db": 85}'
medusa products add-variant --product "cummins-cs200" \
  --sku "GEN-CS200S" \
  --title "CS200 Silent" \
  --price 28707 \
  --weight 2500 \
  --metadata '{"tiene_cabina": true, "nivel_ruido_db": 55}'
```

#### 2. PRODUCTO ACCESORIO: TTA 200 KVA - ICSA
```bash
medusa products create \
  --title "TTA 200 KVA - ICSA" \
  --handle "tta-psy200-icsa" \
  --sku "TTA-PSY200-IC" \
  --price 3322 \
  --metadata '{
    "tipo_producto": "accesorio",
    "categoria_accesorio": "transferencia_automatica",
    "potencia_compatible_kva": 200,
    "marca_tta": "ICSA",
    "productos_compatibles": ["cummins-cs200", "cummins-yns200"]
  }'
```

#### 3. PRODUCTO SERVICIO: Puesta en Marcha CS200
```bash
medusa products create \
  --title "Puesta en marcha - Cummins 200 KVA" \
  --handle "puesta-marcha-cs200" \
  --sku "PMCS200" \
  --price 156 \
  --metadata '{
    "tipo_producto": "servicio",
    "categoria_servicio": "puesta_en_marcha",
    "incluye": "Aceite, refrigerante y prueba con carga 1hr",
    "productos_compatibles": ["cummins-cs200", "cummins-yns200"]
  }'
```

---

## 🎨 COMPONENTES FRONTEND A CREAR

### 1. VariantSelector.tsx
Selector de variantes tipo MercadoLibre (Abierto vs Silent)

### 2. RelatedProducts.tsx
Muestra versiones alternativas (CS170, CS275, etc.)

### 3. CompatibleAccessories.tsx
Muestra accesorios compatibles (TTAs, servicios, etc.)

### 4. ProductBundle.tsx
Permite armar combos con descuentos

---

## 📋 CASOS DE USO REALES

### Caso 1: Generador con opciones de cabina
**Solución:** Product Variants
- CS200A (Abierto)
- CS200S (Silent)

### Caso 2: Mismo generador, con/sin TTA
**Solución:** Compatible Accessories en metadata
- Producto base: Cummins CS200
- Accesorios: TTA-PSY200-ICSA, TTA-PSY200-ABB

### Caso 3: Cliente quiere ver generadores similares
**Solución:** Related Products en metadata
- CS200 muestra: CS170 (menor), CS275 (mayor)

### Caso 4: Cliente quiere combo "llave en mano"
**Solución:** Bundle Product
- CS200S + TTA-ABB + Puesta en marcha
- Precio especial con descuento

---

## ✅ RESUMEN FINAL

| Concepto | Implementación en Medusa | Ejemplo |
|----------|-------------------------|---------|
| **Versiones del mismo producto** | Product Variants | CS200A vs CS200S |
| **Accesorios/Opcionales** | Productos independientes + metadata `accesorios_compatibles` | TTA-PSY200-ICSA |
| **Servicios** | Productos independientes con `tipo_producto: "servicio"` | PMCS200 (Puesta en marcha) |
| **Productos relacionados** | Metadata `productos_relacionados` | CS170, CS200, CS275 |
| **Combos/Kits** | Bundles con descuento | CS200S + TTA + Servicio |

---

## 🚀 PRÓXIMOS PASOS

1. ✅ Crear productos en Medusa Admin con estructura definida
2. ✅ Implementar selector de variantes en frontend
3. ✅ Crear sección "Accesorios Compatibles"
4. ✅ Crear sección "Productos Relacionados"
5. ✅ Implementar lógica de bundles con descuentos
6. ✅ Agregar al carrito con validación de compatibilidad

---

**¿Estás de acuerdo con esta arquitectura?** 

Combina lo mejor de:
- ✅ Variantes nativas de Medusa (para Abierto vs Silent)
- ✅ Productos relacionados (para mostrar alternativas)
- ✅ Accesorios como productos independientes
- ✅ Servicios integrados en el flujo de compra

Es **escalable, profesional y fácil de mantener**.
