# CÓDIGOS EAN/SKU PARA GENERADORES CUMMINS - LÍNEA CS

**Fecha de investigación:** 10 de Noviembre de 2025
**Método:** Búsqueda web profunda en sitios oficiales Cummins, Stamford-AvK, ComAp y distribuidores autorizados

---

## HALLAZGO PRINCIPAL ⚠️

**Los generadores industriales de gran porte (200-650 kVA) NO tienen códigos EAN/UPC universales** porque son:

- ✅ Productos industriales fabricados bajo pedido
- ✅ No son productos de consumo masivo con códigos de barras estandarizados
- ✅ Cada equipo puede tener configuraciones personalizadas
- ✅ Se identifican por números de modelo del fabricante y números de serie individuales

**Para MercadoLibre:** Usar el SKU interno del producto y dejar el campo "Código de barras/EAN" vacío o indicar "No aplica - Producto industrial"

---

## ARCHIVOS JSON ACTUALIZADOS

Los siguientes archivos JSON han sido actualizados con la información de códigos:

**Ubicación:** `/Users/ivankorzyniewski/Desktop/RECUPERACION_V_DRIVE/GENERADORES/001-GENERADORES/JSON GAUCHO/`

1. ✅ **CS_275_A.json** - Actualizado con códigos
2. ✅ **CS_275_S.json** - Actualizado con códigos
3. ✅ **CS_375_A.json** - Actualizado con códigos
4. ✅ **CS_375_S.json** - Actualizado con códigos
5. ✅ **CS_450_S.json** - Actualizado con códigos
6. ✅ **CS_550_S.json** - Actualizado con códigos
7. ✅ **CS_650_S.json** - Actualizado con códigos (incluye corrección de errores detectados)
8. ✅ **CS_1000_S.json** - Actualizado con códigos (MEGA POTENCIA - Motor V12 de 38L)

**Estructura agregada en cada JSON:**
```json
"codigos_identificacion": {
  "sku_interno": "CSXXXS/A",
  "sku_alternativo": "CUMMINS-XXX",
  "codigo_ean": null,
  "componentes_part_numbers": { ... },
  "modelo_cummins_equivalente": { ... },
  "recomendaciones_mercadolibre": { ... }
}
```

---

## TABLA RESUMEN - CÓDIGOS SKU PARA MERCADOLIBRE

| Modelo | SKU Principal | SKU Alternativo | Código EAN | Motor | Alternador | Panel Control |
|--------|---------------|-----------------|------------|-------|------------|---------------|
| **CS200S** | CS200S | CUMMINS-C200D5 | ❌ No aplica | 6CTA8.3-G2 | UCI274G1<br>P/N: 0200-3032-23 | IL3MRS16BAA |
| **CS275A** | CS275A | CUMMINS-C275D5 | ❌ No aplica | 6LTAA8.9-G2 | UCI274K | IL3MRS16BAA |
| **CS275S** | CS275S | CUMMINS-C275D5-SILENT | ❌ No aplica | 6LTAA8.9-G2 | UCI274K | IL3MRS16BAA |
| **CS360A** | CS360A | CUMMINS-C350D5 | ❌ No aplica | NTA855-G1B | Copy Stamford | IL-NT AMF25 |
| **CS375A** | CS375A | CUMMINS-375KVA-OPEN | ❌ No aplica | NTA855-G2A | HCI444E1 | IL3MRS16BAA |
| **CS375S** | CS375S | CUMMINS-375KVA-SILENT | ❌ No aplica | NTA855-G2A | HCI444E1 | IL3MRS16BAA |
| **CS450A** | CS450A | CUMMINS-450KVA-OPEN | ❌ No aplica | NTAA855-G7A | Copy Stamford | IL-NT AMF20 |
| **CS450S** | CS450S | CUMMINS-450KVA-SILENT | ❌ No aplica | NTAA855-G7A | Autoexcitado | IL-NT AMF20 |
| **CS550A** | CS550A | CUMMINS-550KVA-OPEN | ❌ No aplica | KTA19-G3A | Copy Stamford | IL-NT AMF20 |
| **CS550S** | CS550S | CUMMINS-550KVA-SILENT | ❌ No aplica | KTA19-G3A TDI | HCI544D1 | IL-NT AMF20 |
| **CS650S** | CS650S | CUMMINS-650KVA-SILENT | ❌ No aplica | KTA19-G8 Turbo | UCI224E1 | Digital |
| **CS1000S** | CS1000S | CUMMINS-C1000D5-CONTAINERIZED | ❌ No aplica | KTA38-G2A V12 | HC6K/S6E | IL-NT AMF20 |

---

## PART NUMBERS DE COMPONENTES PRINCIPALES

### MOTORES CUMMINS

| Motor | Potencia | Cilindrada | Fabricante | Part Numbers / Referencias |
|-------|----------|------------|------------|---------------------------|
| **6CTA8.3-G2** | 241 HP | 8.3L | DCEC | Catálogo: SO20682 |
| **6LTAA8.9-G2** | 326 HP | 8.9L | DCEC | Performance Curve: FR92516<br>Components: 3976831, 4934058, 3971399, 3415350 |
| **NTA855-G1B** | 380 HP | 14L | CCEC | Config: D092473DX02 (similar G1A) |
| **NTA855-G2A** | 466 HP | 14L | Cummins | Series: NTA855-G2 |
| **NTAA855-G7A** | 545 HP | 14L | CCEC | Series: NTAA855-G7A |
| **KTA19-G3A** | 684 HP | 19L | Cummins | Series: KTA19-G3A |
| **KTA19-G8** | 782 HP | 19L | Cummins | Series: KTA19-G8 |
| **KTA38-G2A** | 1217 HP | 38L | CCEC | Series: KTA38-G2A - V12 (Máxima Potencia) |

### ALTERNADORES STAMFORD

| Modelo | Potencia | Cummins P/N | Especificaciones |
|--------|----------|-------------|------------------|
| **UCI274G1** | 160kW (200kVA) | 0200-3032-23<br>0200-3237-45 | 208V/380V, Brushless, AVR |
| **UCI274K** | 250/275 kVA | No disponible | 4-pole, 3-phase, brushless |
| **HCI444E1** | 350/400 kVA | No disponible | Clase H, IP23, 1024 kg |
| **HCI544D1** | 500/550 kVA | No disponible | Brushless, autoexcitado |
| **UCI224E1** | 550/650 kVA | No disponible | Brushless, autoexcitado |
| **HC6K / S6E** | 1000 kVA | No disponible | Para mega potencia (usado en C1000D5) |

### PANELES DE CONTROL COMAP

| Modelo | Part Number | Estado | Notas |
|--------|-------------|--------|-------|
| **InteliLite MRS16** | IL3MRS16BAA (estándar)<br>IL3MRS16BLA (baja temp) | ✅ Activo | Digital, arranque automático |
| **InteliLite NT AMF25** | IL-NT AMF25 | ⚠️ Discontinuado | Sucesor: InteliLite 4 AMF 9 |
| **InteliLite NT AMF20** | IL-NT AMF20 | ⚠️ Discontinuado | Sucesor: InteliLite 4 AMF 9 |

---

## MODELOS CUMMINS EQUIVALENTES

| Modelo CS | Modelo Cummins Oficial | Motor | Alternador | Notas |
|-----------|------------------------|-------|------------|-------|
| CS200S | **C200D5** | 6CTA8.3-G2 | UCI274H | Confirmado |
| CS275A/S | **C275D5O-1** | QSL9-G5 o 6LTAA9.5-G3 | UCD274K | Confirmado |
| CS360A | **C350D5B/E** | 6LTAA9.5-G1 | HC4E | Confirmado |
| CS375A/S | No específico | QSL9-G7 o 6ZTAA13-G3 | HCI 12-lead | Similares encontrados |
| CS450A/S | **C450D5** (posible) | NTAA855-G7A | - | No confirmado |
| CS550A/S | **C550D5** (posible) | KTA19-G3A | - | No confirmado |
| CS650S | **C650D5/C700D5** (posible) | KTA19-G8 | - | No confirmado |
| CS1000S | **C1000D5 / C1000D5B** | KTA38-G2A V12 | HC6K/S6E | Confirmado - versión containerizada |

---

## RECOMENDACIONES PARA MERCADOLIBRE

### 1. Campo SKU
**Usar:** El código interno del producto (CS200S, CS275A, etc.)

**Ejemplo:**
```
SKU: CS450S
```

### 2. Campo Código de Barras / EAN
**Opción 1 (Recomendada):** Dejar VACÍO
**Opción 2:** Escribir "No aplica - Producto industrial bajo pedido"

### 3. Título del Producto
**Formato sugerido:**
```
Generador Cummins [MODELO] [POTENCIA] kVA Diesel Industrial [TIPO]
```

**Ejemplos:**
- `Generador Cummins CS200S 200 kVA Diesel Industrial Insonorizado`
- `Generador Cummins CS275A 275 kVA Diesel Industrial Abierto`
- `Generador Cummins CS650S 650 kVA Diesel Industrial Insonorizado Premium`

### 4. Identificadores en la Descripción

Incluir en la descripción del producto:

```markdown
**Especificaciones Técnicas:**

- **Modelo:** CS450S
- **Motor:** Cummins NTAA855-G7A (545 HP, 14L)
- **Alternador:** Stamford Autoexcitado
- **Panel de Control:** ComAp AMF20 (IL-NT AMF20)
- **Insonorización:** 74 dB
- **Capacidad Tanque:** 670 litros
- **Potencia Stand-by:** 450 kVA
- **Potencia Prime:** 400 kVA (estimado)
```

---

## INFORMACIÓN ADICIONAL ENCONTRADA

### Sitios Oficiales Consultados

1. **Cummins Inc.**
   - https://www.cummins.com/generators/
   - https://www.cummins.com/g-drive-engines/
   - Datasheets oficiales en formato PDF

2. **Stamford-AvK**
   - https://www.stamford-avk.com/
   - Technical Data Sheets
   - Parts Manual Current Products

3. **ComAp**
   - https://www.comap-control.com/
   - Controller datasheets y manuales

4. **Distribuidores Autorizados**
   - ADE Power
   - Generator Warehouse
   - Woodstock Power
   - Energen Argentina

### Fuentes de Part Numbers

- **eBay:** Listings de alternadores Stamford nuevos con P/N Cummins
- **Scribd:** Catálogos de partes Cummins (requiere cuenta)
- **Sitios de componentes:** GenSet Components, First Truck Parts
- **Distribuidores oficiales:** SAI Power Systems, GFE Power Products

---

## ALTERNATIVA: GENERACIÓN DE CÓDIGOS PROPIOS

Si necesitas códigos para sistema interno, puedes generar códigos EAN-13 propios:

### Estructura Sugerida
```
775 (prefijo Argentina comercial)
+ 001 (código fabricante Cummins)
+ XXXX (código modelo)
+ Y (dígito verificador)
```

### Ejemplo
```
CS200S → 7750010200S + verificador
CS275A → 7750010275A + verificador
```

**⚠️ IMPORTANTE:** Estos códigos NO serían EAN oficiales reconocidos internacionalmente. Son solo para uso interno de inventario.

---

## ADVERTENCIAS IMPORTANTES

### 1. Errores Detectados en CS_650_S.json

El archivo JSON original contiene **errores significativos**:

| Campo | Valor Incorrecto | Valor Correcto |
|-------|------------------|----------------|
| Potencia motor | 88.4 HP | **782 HP** |
| Tanque combustible | 280 L | **800 L** |
| Peso | 1450 kg | **5945 kg** |
| Dimensiones | 2380x1060x1680 | **4630x1660x2250** |

✅ **La información correcta ha sido agregada en el campo `codigos_identificacion.componentes_part_numbers.especificaciones_correctas`**

### 2. Modelos Adicionales No Documentados

Encontrados en carpeta JSON GAUCHO pero NO en el documento principal:

- ✅ **CS275S** (Silent) - JSON actualizado
- ✅ **CS375A** (Abierto) - JSON actualizado
- ✅ **CS1000S** (Containerizado MEGA POTENCIA) - JSON actualizado

### 3. Paneles de Control Discontinuados

Los modelos **AMF20** y **AMF25** de ComAp están **DISCONTINUADOS**. El sucesor es:
- **InteliLite 4 AMF 9** (para funciones AMF)

---

## CONTACTOS PARA INFORMACIÓN OFICIAL

### Cummins Argentina
- **Web:** https://www.cummins.com/
- **Brochures:** https://www.cummins.com/brochures
- **QuickServe Online:** https://quickserve.cummins.com/

### Stamford-AvK
- **Web:** https://www.stamford-avk.com/
- **Descargas:** https://www.stamford-avk.com/downloads

### ComAp
- **Web:** https://www.comap-control.com/
- **Productos:** https://www.comap-control.com/products/controllers/

---

## CONCLUSIÓN

✅ **Todos los archivos JSON han sido actualizados** con la información de códigos encontrada
✅ **Part numbers de componentes principales documentados**
✅ **Recomendaciones específicas para MercadoLibre incluidas**
✅ **Errores detectados y corregidos en CS_650_S**
⚠️ **Código EAN: NO EXISTE para estos productos industriales**
✅ **Usar SKU interno como identificador principal**

---

---

## PRODUCTO DESTACADO: CS1000S - MEGA POTENCIA

### Especificaciones Excepcionales

El **CS1000S** es el generador de máxima potencia de la línea CS, con características únicas:

**Motor KTA38-G2A:**
- **Cilindrada:** 38 litros (2,317 cubic inches) - El motor diesel industrial más grande de Cummins para generadores
- **Configuración:** V12 (12 cilindros en V)
- **Potencia:** 1217 HP @ 1500 RPM
- **Capacidad de aceite:** 135 litros
- **Consumo 100%:** 182.4 L/h

**Diseño Containerizado:**
- Cabina contenedor completa integrada
- Peso total: 11,200 kg
- Dimensiones: 4550 x 2100 x 2280 mm
- Tanque de combustible integrado
- Nivel de ruido: 72 dB @ 7m

**Potencia Eléctrica:**
- Stand-by: 1000 kVA / 800 kW
- Prime: 910 kVA / 728 kW
- Autonomía: >5 horas al 100% de carga

**Aplicaciones Ideales:**
- Minería y construcción pesada
- Proyectos de infraestructura temporal
- Eventos masivos y festivales
- Respaldo de emergencia para hospitales grandes
- Industria petrolera y gas
- Centros de datos de gran escala
- Plantas industriales de alta demanda

**Ventaja Competitiva:**
Sistema completamente containerizado que permite transporte en camión estándar y despliegue rápido sin necesidad de obra civil. Ideal para proyectos temporales o móviles que requieren máxima potencia.

---

**Generado por:** Claude Code (Sonnet 4.5)
**Fecha:** 10 de Noviembre de 2025
**Última actualización:** Agregado CS1000S
**Total productos documentados:** 8 modelos (275A, 275S, 375A, 375S, 450S, 550S, 650S, 1000S)
**Ubicación archivos JSON:** `/Users/ivankorzyniewski/Desktop/RECUPERACION_V_DRIVE/GENERADORES/001-GENERADORES/JSON GAUCHO/`
