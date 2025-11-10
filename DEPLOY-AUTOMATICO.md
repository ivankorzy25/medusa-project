# 🚀 Guía de Deploy Automático - Noviembre 2025

## Stack Seleccionado (100% Gratis)

### 1. **Neon** - PostgreSQL Serverless (Gratis)
- ✅ 3 GB de almacenamiento
- ✅ 0.5 GB de RAM compartida
- ✅ Escalado automático
- ✅ Sin tarjeta de crédito requerida
- ✅ **Mejor opción** en noviembre 2025

### 2. **Vercel** - Hosting Frontend (Gratis)
- ✅ 100 GB de bandwidth/mes
- ✅ Deploy ilimitados
- ✅ HTTPS automático
- ✅ Edge Network global
- ✅ Analytics básico incluido

### 3. **Railway** - Backend Medusa (opcional, gratis con créditos)
- ✅ $5 de crédito gratis/mes
- ✅ Deploy automático desde GitHub
- ✅ PostgreSQL incluido

---

## Paso 1: Crear Base de Datos en Neon (2 minutos)

### A. Crear cuenta en Neon

1. Ve a: https://neon.tech
2. Click en "Sign Up"
3. Usa tu cuenta de GitHub para login rápido
4. Verifica tu email

### B. Crear proyecto

```
1. Click "New Project"
2. Nombre: medusa-store
3. Región: US East (Ohio) - aws-us-east-2
4. PostgreSQL version: 16 (default)
5. Click "Create Project"
```

### C. Obtener Connection String

Una vez creado, verás el dashboard. Copia la **Connection String**:

```
Formato:
postgresql://[user]:[password]@[host]/[database]?sslmode=require

Ejemplo:
postgresql://neondb_owner:abc123xyz@ep-cool-sound-123456.us-east-2.aws.neon.tech/neondb?sslmode=require
```

**⚠️ GUARDA ESTA URL - La necesitarás en el siguiente paso**

---

## Paso 2: Configurar Variables de Entorno

### Opción A: Usando Vercel Dashboard (Recomendado)

1. Ve a https://vercel.com/dashboard
2. Click "Add New..." > "Project"
3. Importa: `ivankorzy25/medusa-project`
4. **ANTES de hacer deploy**, click en "Environment Variables"
5. Agrega estas variables:

```env
# Variable 1
NEXT_PUBLIC_MEDUSA_BACKEND_URL
Value: http://localhost:9000
(Actualizaremos después cuando despliegues el backend)

# Variable 2
NEXT_PUBLIC_MEDUSA_PUBLISHABLE_KEY
Value: pk_f1e1f52b9d9a06b31c0a0d75e188818220ea0bc3aaae1df27e2e8720ec56cc9b

# Variable 3
NEXT_PUBLIC_BASE_URL
Value: (dejar vacío por ahora - Vercel lo autocompletará)

# Variable 4
DATABASE_URL
Value: [PEGA AQUÍ LA CONNECTION STRING DE NEON]
```

6. **Importante**: Marca las 3 casillas (Production, Preview, Development)
7. Click "Add" para cada variable
8. Ahora sí, click "Deploy"

### Opción B: Usando CLI (Automático)

Si prefieres CLI, ejecuta esto en tu terminal:

```bash
# Desde el directorio del proyecto
npx vercel

# Sigue las instrucciones:
# - Setup and deploy? Y
# - Which scope? Tu usuario
# - Link to existing project? N
# - Project name? medusa-project
# - Directory? ./ (Enter)
# - Override settings? N

# Agregar variables de entorno
npx vercel env add NEXT_PUBLIC_MEDUSA_BACKEND_URL
# Pega: http://localhost:9000

npx vercel env add NEXT_PUBLIC_MEDUSA_PUBLISHABLE_KEY
# Pega: pk_f1e1f52b9d9a06b31c0a0d75e188818220ea0bc3aaae1df27e2e8720ec56cc9b

npx vercel env add DATABASE_URL
# Pega: [Tu Connection String de Neon]

# Deploy a producción
npx vercel --prod
```

---

## Paso 3: Verificar Deploy

Una vez completado el deploy (2-3 minutos), verás:

```
✅ Production: https://medusa-project-xxxxx.vercel.app
```

Prueba estas URLs:

1. **Homepage**: https://medusa-project-xxxxx.vercel.app
2. **Health check**: https://medusa-project-xxxxx.vercel.app/api/health
3. **Producto**: https://medusa-project-xxxxx.vercel.app/producto/[handle]

---

## Paso 4: Actualizar NEXT_PUBLIC_BASE_URL

1. Ve a Vercel Dashboard > tu proyecto > Settings > Environment Variables
2. Busca `NEXT_PUBLIC_BASE_URL`
3. Si está vacío, agrégalo con el valor:
   ```
   https://medusa-project-xxxxx.vercel.app
   ```
   (Usa tu URL real de Vercel)
4. Redeploy: Deployments > ... > Redeploy

---

## Paso 5 (Opcional): Deploy del Backend en Railway

Si necesitas desplegar el backend de Medusa también:

### A. Crear cuenta en Railway

1. Ve a: https://railway.app
2. Login con GitHub
3. Recibes $5 gratis/mes (suficiente para backend pequeño)

### B. Deploy del Backend

```bash
# Desde el directorio del backend de Medusa
railway login
railway init
railway add postgresql
railway up

# Configurar variables de entorno
railway variables set DATABASE_URL=$RAILWAY_DATABASE_URL
railway variables set JWT_SECRET=[genera uno random]
railway variables set COOKIE_SECRET=[genera uno random]

# Obtener URL del backend
railway domain
# Output: your-backend.railway.app
```

### C. Actualizar Frontend

Regresa a Vercel y actualiza:

```
NEXT_PUBLIC_MEDUSA_BACKEND_URL=https://your-backend.railway.app
```

Redeploy el frontend.

---

## Monitoreo y Logs

### Vercel

```bash
# Ver logs en tiempo real
npx vercel logs

# Ver información del proyecto
npx vercel inspect

# Ver deployments
npx vercel ls
```

### Neon

1. Dashboard: https://console.neon.tech
2. Ve a tu proyecto
3. Click en "Monitoring" para ver:
   - Conexiones activas
   - Uso de storage
   - Queries ejecutadas

---

## Costos Proyectados (Gratis hasta...)

### Neon Free Tier
- ✅ 3 GB storage (suficiente para ~10K productos)
- ✅ Ilimitadas conexiones
- ⚠️ Si superas, upgrade a $19/mes

### Vercel Free Tier
- ✅ 100 GB bandwidth/mes (~1000 visitas/día)
- ✅ Deploy ilimitados
- ⚠️ Si superas, upgrade a $20/mes

### Railway Free Tier
- ✅ $5 créditos/mes (backend pequeño corre con ~$4-5/mes)
- ⚠️ Si superas, necesitas agregar método de pago

**Total para empezar: $0/mes** 🎉

---

## Troubleshooting Común

### Error: "Cannot connect to database"

```bash
# Verificar que la Connection String de Neon es correcta
# Debe incluir ?sslmode=require al final
```

### Error: "Backend not responding"

```bash
# Si estás usando localhost:9000, el frontend en Vercel no puede alcanzarlo
# Necesitas desplegar el backend en Railway o similar
```

### Deploy falla en Vercel

```bash
# Verificar que el build funciona localmente
npm run build

# Ver logs específicos en Vercel Dashboard
# Deployments > tu deploy > View Function Logs
```

---

## Próximos Pasos

Una vez que todo esté desplegado:

1. ✅ Configura dominio personalizado (opcional)
2. ✅ Activa Analytics en Vercel
3. ✅ Configura backups automáticos de Neon
4. ✅ Agrega monitoreo con Vercel Speed Insights

---

## Comandos Rápidos de Referencia

```bash
# Deploy a producción
npx vercel --prod

# Ver logs
npx vercel logs --follow

# Ver variables de entorno
npx vercel env ls

# Promover un preview a producción
npx vercel promote [deployment-url]

# Ver dominios configurados
npx vercel domains ls

# Agregar dominio personalizado
npx vercel domains add tudominio.com
```

---

**Tiempo total estimado: 10-15 minutos** ⏱️

**Todo configurado y funcionando en producción!** 🚀
