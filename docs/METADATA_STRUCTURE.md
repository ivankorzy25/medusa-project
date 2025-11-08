# Estructura de Metadata para Productos - Generadores

Este documento define **TODOS** los campos de metadata que deben cargarse en Medusa para que el frontend pueda mostrar correctamente las características de cada producto.

## ⚠️ IMPORTANTE: Campos Obligatorios vs Opcionales

### Campos OBLIGATORIOS (todos los productos deben tenerlos):
- `sku` - Código único del producto
- `motor_marca` - Marca del motor (Cummins, Perkins, etc.)
- `motor_modelo` - Modelo del motor
- `potencia_standby_kva` - Potencia Stand-By en KVA
- `potencia_prime_kva` - Potencia Prime en KVA
- `combustible_tipo` - Tipo de combustible (Diesel, Nafta, Gas)
- `nivel_ruido_db` - Nivel de ruido en dB
- `peso_kg` - Peso total en kg
- `largo_mm`, `ancho_mm`, `alto_mm` - Dimensiones en milímetros

### Campos OPCIONALES (solo si aplica):
- `tiene_cabina` - Boolean (true/false)
- `tiene_tta` - Boolean o "incluido"/"opcional"/"no"
- `insonorizacion_tipo` - Tipo de insonorización si tiene
- Resto de campos técnicos según disponibilidad

---

## 1. IDENTIFICACIÓN Y SKU

```json
{
  "sku": "GEN-CS200A-STD"
}
```

**Campo**: `sku` (String)
**Descripción**: Código único del producto
**Frontend usa**: Para identificación única
**Ejemplo**: "GEN-CS200A-STD", "GEN-CS300-CAB"

---

## 2. CARACTERÍSTICAS PRINCIPALES (Badges Visuales)

### 2.1 Combustible ⛽

```json
{
  "combustible_tipo": "Diesel"
}
```

**Campo**: `combustible_tipo` (String)
**Valores permitidos**: "Diesel", "Nafta", "Gas", "Dual (Diesel/Gas)"
**Frontend usa**: Badge con color según tipo
**Colores**:
- Diesel → Amarillo (#FEF3C7)
- Nafta → Azul (#DBEAFE)
- Gas → Verde (#D1FAE5)

### 2.2 Transferencia Automática ⚡

```json
{
  "tiene_tta": "incluido"
}
```

**Campo**: `tiene_tta` (String)
**Valores permitidos**: "incluido", "opcional", "no"
**Frontend usa**: Badge verde (incluido) o amarillo (opcional)
**Nota**: Si es "no", no muestra badge

### 2.3 Cabina 🏠

```json
{
  "tiene_cabina": true
}
```

**Campo**: `tiene_cabina` (Boolean)
**Valores permitidos**: `true`, `false`
**Frontend usa**: Badge azul "Con Cabina" si es true

### 2.4 Insonorización 🔊

```json
{
  "nivel_ruido_db": "68",
  "insonorizacion_tipo": "Estándar"
}
```

**Campos**:
- `nivel_ruido_db` (String/Number): Nivel de ruido en decibeles
- `insonorizacion_tipo` (String, opcional): "Estándar", "Súper Silencioso", "Ultra Silencioso"

**Frontend usa**:
- Badge con color según nivel:
  - ≤65 dB → Verde (Excelente)
  - 66-75 dB → Amarillo (Bueno)
  - >75 dB → Rojo (Alto)
- Barra visual de 5 segmentos
- Texto: "68 dB"

### 2.5 Dimensiones y Peso 📏⚖️

```json
{
  "peso_kg": "2850",
  "largo_mm": "3200",
  "ancho_mm": "1400",
  "alto_mm": "1900"
}
```

**Campos**:
- `peso_kg` (String/Number): Peso total en kilogramos
- `largo_mm`, `ancho_mm`, `alto_mm` (String/Number): Dimensiones en milímetros

**Frontend usa**:
- Badge gris: "2850 kg"
- Badge gris: "320×140×190 cm" (convierte mm → cm automáticamente)

---

## 3. ESPECIFICACIONES TÉCNICAS DEL MOTOR

```json
{
  "motor_marca": "Cummins",
  "motor_modelo": "6CTAA8.3-G2",
  "motor_cilindros": "6",
  "motor_tipo_cilindros": "En línea",
  "motor_ciclo": "4 tiempos",
  "motor_aspiracion": "Turboalimentado con aftercooler",
  "motor_refrigeracion": "Agua",
  "motor_rpm": "1800",
  "motor_consumo_75_carga": "35.5",
  "motor_capacidad_aceite": "28"
}
```

**Campos**:
- `motor_marca` (String): Marca del motor
- `motor_modelo` (String): Modelo específico
- `motor_cilindros` (String): Número de cilindros
- `motor_tipo_cilindros` (String): "En línea", "En V"
- `motor_ciclo` (String): "4 tiempos", "2 tiempos"
- `motor_aspiracion` (String): Tipo de aspiración
- `motor_refrigeracion` (String): Tipo de refrigeración
- `motor_rpm` (String/Number): Revoluciones por minuto
- `motor_consumo_75_carga` (String/Number): Consumo al 75% de carga (litros/hora)
- `motor_capacidad_aceite` (String/Number): Capacidad de aceite (litros)

**Frontend usa**: Tab "Especificaciones Técnicas" → Sección "Motor"

---

## 4. POTENCIA Y RENDIMIENTO

```json
{
  "potencia_standby_kva": "200",
  "potencia_prime_kva": "180",
  "potencia_standby_kw": "160",
  "potencia_prime_kw": "144",
  "factor_potencia": "0.8"
}
```

**Campos**:
- `potencia_standby_kva` (String/Number): Potencia Stand-By en KVA
- `potencia_prime_kva` (String/Number): Potencia Prime en KVA
- `potencia_standby_kw` (String/Number): Potencia Stand-By en KW
- `potencia_prime_kw` (String/Number): Potencia Prime en KW
- `factor_potencia` (String/Number): Factor de potencia (típicamente 0.8)

**Frontend usa**:
- Título del producto (si incluye KVA)
- Tab "Especificaciones Técnicas" → Sección "Potencia"

---

## 5. SISTEMA ELÉCTRICO

```json
{
  "alternador_marca": "Stamford",
  "alternador_modelo": "HCI544D",
  "voltaje": "220/380V",
  "frecuencia": "50/60Hz",
  "fases": "Trifásico"
}
```

**Campos**:
- `alternador_marca` (String): Marca del alternador
- `alternador_modelo` (String): Modelo del alternador
- `voltaje` (String): Voltaje de salida
- `frecuencia` (String): Frecuencia
- `fases` (String): "Monofásico", "Trifásico", "Ambos"

**Frontend usa**: Tab "Especificaciones Técnicas" → Sección "Sistema Eléctrico"

---

## 6. COMBUSTIBLE Y AUTONOMÍA

```json
{
  "combustible_tipo": "Diesel",
  "combustible_capacidad_tanque": "400",
  "autonomia_horas_75_carga": "11.3"
}
```

**Campos**:
- `combustible_tipo` (String): Ver sección 2.1
- `combustible_capacidad_tanque` (String/Number): Capacidad del tanque (litros)
- `autonomia_horas_75_carga` (String/Number): Autonomía al 75% de carga (horas)

**Frontend usa**:
- Badge de combustible (ver sección 2.1)
- Tab "Especificaciones Técnicas" → Sección "Combustible"

---

## 7. SISTEMA DE CONTROL

```json
{
  "panel_control_marca": "Deep Sea",
  "panel_control_modelo": "DSE7320",
  "panel_control_funciones": [
    "Arranque/paro automático",
    "Protección contra sobrecarga",
    "Monitoreo de parámetros",
    "Transferencia automática (si tiene TTA)"
  ]
}
```

**Campos**:
- `panel_control_marca` (String): Marca del panel de control
- `panel_control_modelo` (String): Modelo del panel
- `panel_control_funciones` (Array de Strings): Lista de funciones

**Frontend usa**: Tab "Especificaciones Técnicas" → Sección "Panel de Control"

---

## 8. PROTECCIONES Y SEGURIDAD

```json
{
  "protecciones": [
    "Baja presión de aceite",
    "Alta temperatura de agua",
    "Sobrecarga",
    "Cortocircuito",
    "Bajo/alto voltaje"
  ]
}
```

**Campo**: `protecciones` (Array de Strings)
**Frontend usa**: Tab "Especificaciones Técnicas" → Sección "Protecciones"

---

## 9. PRECIOS Y DESCUENTOS

```json
{
  "pricing_config": {
    "precio_lista_usd": 26411,
    "currency_type": "usd_bna",
    "iva_percentage": 10.5,
    "bonificacion_percentage": 11,
    "contado_descuento_percentage": 9,
    "familia": "Generadores Cummins - Línea CS"
  },
  "descuento_porcentaje": 42,
  "precio_anterior": 75000000
}
```

**Ver**: [PRICING_METADATA.md](./PRICING_METADATA.md) para detalles completos

---

## 10. VENTAS Y RANKINGS

```json
{
  "total_ventas": 247,
  "es_mas_vendido": true,
  "categoria": "Generadores Diesel"
}
```

**Ver**: [PRICING_METADATA.md](./PRICING_METADATA.md) para detalles completos

---

## 11. FINANCIACIÓN

```json
{
  "financiacion_disponible": true,
  "planes_financiacion": [
    {"cuotas": 3, "interes": 0.08, "costoPorCuota": 14740000},
    {"cuotas": 6, "interes": 0.08, "costoPorCuota": 7570000}
  ]
}
```

**Ver**: [PRICING_METADATA.md](./PRICING_METADATA.md) para detalles completos

---

## EJEMPLO COMPLETO DE METADATA

```json
{
  "sku": "GEN-CS200A-STD",

  "combustible_tipo": "Diesel",
  "tiene_tta": "incluido",
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
    "Monitoreo de parámetros"
  ],

  "protecciones": [
    "Baja presión de aceite",
    "Alta temperatura de agua",
    "Sobrecarga",
    "Cortocircuito"
  ],

  "pricing_config": { ... },
  "descuento_porcentaje": 42,
  "total_ventas": 247,
  "es_mas_vendido": true,
  "categoria": "Generadores Diesel",
  "financiacion_disponible": true,
  "planes_financiacion": [ ... ]
}
```

---

## MAPEO FRONTEND → BACKEND

| Sección Frontend | Campo(s) Metadata |
|------------------|-------------------|
| **Badges Visuales** | |
| Badge Combustible ⛽ | `combustible_tipo` |
| Badge TTA ⚡ | `tiene_tta` |
| Badge Cabina 🏠 | `tiene_cabina` |
| Badge Ruido 🔊 | `nivel_ruido_db`, `insonorizacion_tipo` |
| Badge Peso ⚖️ | `peso_kg` |
| Badge Dimensiones 📏 | `largo_mm`, `ancho_mm`, `alto_mm` |
| **Tab Especificaciones** | |
| Sección Motor | `motor_*` (todos los campos) |
| Sección Potencia | `potencia_*`, `factor_potencia` |
| Sección Eléctrico | `alternador_*`, `voltaje`, `frecuencia`, `fases` |
| Sección Combustible | `combustible_*`, `autonomia_*` |
| Sección Control | `panel_control_*` |
| Sección Protecciones | `protecciones` |
| **Precio y Compra** | |
| Precio dinámico | `pricing_config` |
| Descuentos | `descuento_porcentaje`, `precio_anterior` |
| Financiación | `financiacion_disponible`, `planes_financiacion` |
| Badges promocionales | `total_ventas`, `es_mas_vendido` |

---

## SCRIPTS SQL DISPONIBLES

1. **Estructura completa**: `scripts/setup-complete-metadata.sql` (crear)
2. **Badges visuales**: `scripts/add-product-attributes.sql` (existente)
3. **Precios**: `scripts/add-financiacion-metadata.sql` (existente)
4. **Descuentos**: `scripts/add-discount-metadata.sql` (existente)
5. **Ventas**: `scripts/update-sales-metadata.sql` (existente)

---

## PRÓXIMO PASO

Crear script `setup-complete-metadata.sql` que agregue TODOS los campos técnicos al CS200A según la estructura definida arriba.
