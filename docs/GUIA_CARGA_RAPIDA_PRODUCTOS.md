# 🚀 GUÍA DE CARGA RÁPIDA DE PRODUCTOS

**Versión:** 2.0 - Optimizada para "Lo que tenés que saber"
**Última actualización:** 08 Noviembre 2025

---

## 📋 RESUMEN

Esta guía te muestra cómo cargar nuevos productos RÁPIDAMENTE usando la plantilla JSON y ver todas las características automáticamente en el frontend.

---

## 🎯 LO QUE VAS A LOGRAR

Después de seguir esta guía, tu producto mostrará:

✅ **Hasta 13+ características** en "Lo que tenés que saber"
✅ **Badges de colores** (Diesel, TTA, Ruido, etc.)
✅ **Información completa** en tabs de Especificaciones
✅ **Precio dinámico** con tipo de cambio en tiempo real
✅ **TODO 100% automático** desde el backend

---

## 📂 ARCHIVOS QUE VAS A USAR

1. **`plantillas/PLANTILLA_PRODUCTO_GENERADOR.json`** ← Plantilla base
2. **`scripts/completar-metadata-cummins-cs200a.sql`** ← Ejemplo de script SQL

---

## 🔧 OPCIÓN 1: Carga Rápida con SQL (RECOMENDADO)

### Paso 1: Preparar tu información

Tené a mano la ficha técnica del producto con:
- Marca y modelo del motor
- Potencias (KVA y KW)
- Alternador
- Voltaje y frecuencia
- Capacidad de tanque
- Panel de control
- Etc.

### Paso 2: Crear el producto base en Medusa Admin

1. Ir a Medusa Admin → Products → Create Product
2. Completar SOLO los campos básicos:
   - **Title**: "Generador Diesel Perkins XYZ - 150 KVA"
   - **Handle**: "perkins-xyz-150kva" (se genera automático)
   - **Description**: Descripción breve del producto
   - **Images**: Subir fotos del producto
   - **Pricing**: Precio en USD

3. Guardar el producto

### Paso 3: Copiar la plantilla JSON

```bash
cat plantillas/PLANTILLA_PRODUCTO_GENERADOR.json
```

Copiar TODO el contenido del JSON.

### Paso 4: Reemplazar valores con tu información

Ejemplo para un Perkins 150 KVA:

```json
{
  "motor_marca": "Perkins",                    ← Cambiar
  "motor_modelo": "1106A-70TAG4",              ← Cambiar
  "potencia_standby_kva": "150",               ← Cambiar
  "potencia_standby_kw": "120",                ← Cambiar
  "potencia_prime_kva": "135",                 ← Cambiar
  "potencia_prime_kw": "108",                  ← Cambiar
  "alternador_marca": "Stamford",              ← Cambiar
  "alternador_modelo": "UCI274G",              ← Cambiar
  "voltaje_salida": "220/380V",                ← Verificar
  "fases": "Trifásico",                        ← Verificar
  "frecuencia": "50/60Hz",                     ← Verificar
  "combustible_capacidad_tanque": "300",       ← Cambiar
  "autonomia_horas_75_carga": "9.5",           ← Calcular
  "motor_cilindros": "6",                      ← Cambiar
  "motor_tipo_cilindros": "En línea",          ← Verificar
  "motor_aspiracion": "Turboalimentado",       ← Verificar
  "tipo_refrigeracion": "Agua",                ← Verificar
  "panel_control_marca": "ComAp",              ← Cambiar
  "panel_control_modelo": "InteliLite NT",     ← Cambiar
  "tipo_arranque": "Eléctrico"                 ← Verificar
}
```

### Paso 5: Crear el script SQL

Crea un archivo `scripts/cargar-perkins-xyz.sql`:

```sql
-- Actualizar metadata del producto Perkins XYZ
UPDATE product
SET metadata = '{
  "motor_marca": "Perkins",
  "motor_modelo": "1106A-70TAG4",
  "potencia_standby_kva": "150",
  "potencia_standby_kw": "120",
  "potencia_prime_kva": "135",
  "potencia_prime_kw": "108",
  "alternador_marca": "Stamford",
  "alternador_modelo": "UCI274G",
  "voltaje_salida": "220/380V",
  "fases": "Trifásico",
  "frecuencia": "50/60Hz",
  "combustible_capacidad_tanque": "300",
  "autonomia_horas_75_carga": "9.5",
  "motor_cilindros": "6",
  "motor_tipo_cilindros": "En línea",
  "motor_aspiracion": "Turboalimentado",
  "tipo_refrigeracion": "Agua",
  "panel_control_marca": "ComAp",
  "panel_control_modelo": "InteliLite NT",
  "tipo_arranque": "Eléctrico",
  "combustible_tipo": "Diesel",
  "tiene_tta": "opcional",
  "tiene_cabina": true,
  "nivel_ruido_db": "65",
  "estado_producto": "Nuevo",
  "total_ventas": 0,
  "stock_disponible": true,
  "stock_cantidad": 2,
  "financiacion_disponible": true,
  "categoria": "Generadores Diesel"
}'::jsonb
WHERE handle = 'perkins-xyz-150kva';
```

### Paso 6: Ejecutar el script

```bash
psql postgresql://ivankorzyniewski@localhost:5432/medusa-store < scripts/cargar-perkins-xyz.sql
```

### Paso 7: Verificar en el frontend

```bash
# Abrir en el navegador
http://localhost:3000/producto/perkins-xyz-150kva
```

✅ Deberías ver **TODAS las características** en "Lo que tenés que saber"

---

## 🎨 OPCIÓN 2: Carga Manual desde Medusa Admin

Si preferís cargar manualmente:

1. Ir a Medusa Admin → Products → [Tu Producto]
2. Scroll hasta la sección **"Metadata"**
3. Click en **"Edit Metadata"**
4. Agregar cada campo manualmente:

| Key | Value | Descripción |
|-----|-------|-------------|
| `motor_marca` | "Perkins" | Marca del motor |
| `motor_modelo` | "1106A-70TAG4" | Modelo del motor |
| `potencia_standby_kva` | "150" | Potencia Stand-By |
| etc... | | |

**⚠️ IMPORTANTE:** Escribir EXACTAMENTE los nombres de los campos como aparecen en la plantilla JSON.

---

## 📊 CHECKLIST DE VERIFICACIÓN

Después de cargar el producto, verifica:

### En "Lo que tenés que saber":
- [ ] ✅ Motor marca y modelo
- [ ] ✅ Potencia Stand-By (KVA y KW si existe)
- [ ] ✅ Potencia Prime (KVA y KW si existe)
- [ ] ✅ Alternador marca (y modelo si existe)
- [ ] ✅ Voltaje (y fases si existe)
- [ ] ✅ Frecuencia
- [ ] ✅ Capacidad de tanque
- [ ] ✅ Autonomía
- [ ] ✅ Cilindros y tipo
- [ ] ✅ Aspiración
- [ ] ✅ Refrigeración
- [ ] ✅ Panel de control
- [ ] ✅ Sistema de arranque

### Badges superiores:
- [ ] ✅ Combustible (color correcto según tipo)
- [ ] ✅ TTA (si tiene)
- [ ] ✅ Cabina (si tiene)
- [ ] ✅ Nivel de ruido con barritas
- [ ] ✅ Peso
- [ ] ✅ Dimensiones

### Otros:
- [ ] ✅ Precio se muestra correctamente
- [ ] ✅ Stock disponible
- [ ] ✅ Ubicación detectada
- [ ] ✅ Badge "RECIÉN LLEGADO" (si es nuevo)

---

## 🚨 ERRORES COMUNES Y SOLUCIONES

### Error: "Campo no se muestra en el frontend"

**Causa:** Nombre del campo escrito mal en el metadata.

**Solución:** Verificar que el nombre del campo sea EXACTAMENTE como en la plantilla:
- ✅ Correcto: `motor_marca`
- ❌ Incorrecto: `motorMarca`, `Motor_Marca`, `motor marca`

### Error: "No aparece ninguna característica"

**Causa:** El metadata no se cargó correctamente.

**Solución:** Verificar en Medusa Admin que el metadata tiene datos. Si está vacío, ejecutar nuevamente el script SQL.

### Error: "Aparecen solo 2-3 características"

**Causa:** Solo se cargaron los campos mínimos.

**Solución:** Cargar MÁS campos del metadata siguiendo la plantilla completa.

---

## 💡 TIPS Y MEJORES PRÁCTICAS

### 1. Calcular Autonomía
```
Autonomía = (Capacidad Tanque / Consumo por Hora)

Ejemplo:
Tanque: 400 litros
Consumo al 75%: 35.5 L/h
Autonomía = 400 / 35.5 = 11.3 horas
```

### 2. Potencia KW desde KVA
```
KW = KVA × Factor de Potencia (normalmente 0.8)

Ejemplo:
200 KVA × 0.8 = 160 KW
```

### 3. Nombres consistentes
- Usar siempre "Stamford", no "stamford" ni "STAMFORD"
- Usar "Trifásico", no "3 fases" ni "trifasico"
- Usar "En línea", no "en linea" ni "inline"

### 4. Valores numéricos
- Usar strings: `"200"` no `200`
- Sin unidades: `"400"` no `"400 litros"`
- Usar punto decimal: `"11.3"` no `"11,3"`

---

## 📚 ARCHIVOS DE REFERENCIA

- **Plantilla JSON:** `plantillas/PLANTILLA_PRODUCTO_GENERADOR.json`
- **Script ejemplo:** `scripts/completar-metadata-cummins-cs200a.sql`
- **Estructura metadata:** `docs/METADATA_STRUCTURE.md`
- **Guía completa:** `docs/GUIA_CARGA_PRODUCTOS_MEDUSA.md`

---

## 🎯 RESUMEN RÁPIDO

```bash
# 1. Copiar plantilla
cp plantillas/PLANTILLA_PRODUCTO_GENERADOR.json scripts/nuevo-producto.json

# 2. Editar con tus datos
nano scripts/nuevo-producto.json

# 3. Crear script SQL
cat > scripts/cargar-nuevo-producto.sql << 'EOF'
UPDATE product
SET metadata = '{ ... tu JSON ... }'::jsonb
WHERE handle = 'handle-del-producto';
EOF

# 4. Ejecutar
psql postgresql://ivankorzyniewski@localhost:5432/medusa-store < scripts/cargar-nuevo-producto.sql

# 5. Verificar
open http://localhost:3000/producto/handle-del-producto
```

---

## ✅ LISTO!

Ahora podés cargar productos nuevos en minutos y ver automáticamente todas las características en el frontend. El código ya está listo, solo necesitás los datos.

**¿Dudas?** Consulta la documentación completa en `docs/`
