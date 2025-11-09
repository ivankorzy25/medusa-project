# Guía de Despliegue en Vercel

Esta guía te llevará paso a paso para desplegar tu proyecto Medusa Storefront en Vercel.

## Prerequisitos

Antes de comenzar, asegúrate de tener:

1. ✅ Cuenta en Vercel (https://vercel.com)
2. ✅ Cuenta en GitHub con el repositorio medusa-project
3. ✅ Base de datos PostgreSQL en producción (Railway, Supabase, Neon, etc.)
4. ✅ Backend de Medusa desplegado y accesible
5. ✅ Publishable Key de Medusa para producción

## Paso 1: Preparar Base de Datos en Producción

### Opción A: Railway (Recomendado)

1. Accede a https://railway.app
2. Crea un nuevo proyecto
3. Agrega PostgreSQL desde el catálogo
4. Copia la `DATABASE_URL` que Railway te proporciona
5. Formato: `postgresql://usuario:password@containers-us-west-xxx.railway.app:5432/railway`

### Opción B: Supabase

1. Accede a https://supabase.com
2. Crea un nuevo proyecto
3. Ve a Settings > Database
4. Copia la Connection String (URI format)
5. Formato: `postgresql://postgres:password@db.xxx.supabase.co:5432/postgres`

### Opción C: Neon

1. Accede a https://neon.tech
2. Crea un nuevo proyecto
3. Copia la Connection String
4. Formato: `postgresql://usuario:password@xxx.neon.tech:5432/database`

## Paso 2: Instalar Vercel CLI (Opcional)

```bash
npm i -g vercel
```

## Paso 3: Importar Proyecto en Vercel

### Método A: Desde el Dashboard de Vercel (Recomendado)

1. Accede a https://vercel.com/dashboard
2. Click en "Add New..." > "Project"
3. Importa tu repositorio de GitHub: `ivankorzy25/medusa-project`
4. Vercel detectará automáticamente que es un proyecto Next.js
5. **NO hagas deploy todavía** - primero configura las variables de entorno

### Método B: Desde CLI

```bash
vercel login
vercel
```

Sigue las instrucciones en pantalla y selecciona tu repositorio.

## Paso 4: Configurar Variables de Entorno

En el dashboard de Vercel, antes de hacer el deploy:

1. Ve a tu proyecto > Settings > Environment Variables
2. Agrega las siguientes variables:

### Variables Requeridas

```bash
# Backend de Medusa en producción
NEXT_PUBLIC_MEDUSA_BACKEND_URL=https://api.midominio.com

# Publishable Key de producción (obtener del dashboard de Medusa)
NEXT_PUBLIC_MEDUSA_PUBLISHABLE_KEY=pk_test_XXXX

# URL del frontend en Vercel (actualizar después del primer deploy)
NEXT_PUBLIC_BASE_URL=https://medusa-project.vercel.app

# Base de datos PostgreSQL en producción
DATABASE_URL=postgresql://usuario:clave@host:puerto/db
```

### Configuración de Entornos

Para cada variable, asegúrate de marcar:
- ✅ Production
- ✅ Preview (opcional)
- ✅ Development (opcional)

## Paso 5: Configurar Build Settings

En Settings > General:

- **Framework Preset**: Next.js
- **Build Command**: `npm run build` (por defecto)
- **Output Directory**: `.next` (por defecto)
- **Install Command**: `npm install` (por defecto)
- **Node Version**: 18.x o superior

## Paso 6: Deploy Inicial

1. Click en "Deploy" en el dashboard
2. Vercel comenzará el proceso de build
3. El proceso tomará 2-5 minutos
4. Si hay errores, revisa los logs de build

### Verificar Build

Durante el build, Vercel ejecutará:

```bash
npm install         # Instalar dependencias
npm run build       # Crear build de producción
```

El build debe completarse sin errores (ya lo verificamos localmente).

## Paso 7: Actualizar NEXT_PUBLIC_BASE_URL

Una vez completado el deploy:

1. Copia la URL de tu proyecto (ej: `https://medusa-project.vercel.app`)
2. Ve a Settings > Environment Variables
3. Actualiza `NEXT_PUBLIC_BASE_URL` con la URL real
4. Guarda los cambios
5. Redeploy el proyecto (Deployments > ... > Redeploy)

## Paso 8: Configurar Dominio Personalizado (Opcional)

Si tienes un dominio propio:

1. Ve a Settings > Domains
2. Agrega tu dominio personalizado (ej: `tienda.midominio.com`)
3. Sigue las instrucciones para configurar DNS
4. Actualiza `NEXT_PUBLIC_BASE_URL` con tu dominio
5. Redeploy

## Paso 9: Verificar el Despliegue

Prueba las siguientes URLs:

```bash
# Página principal
https://tu-proyecto.vercel.app

# API de precios
https://tu-proyecto.vercel.app/api/calculate-price

# Página de producto (reemplaza con un handle real)
https://tu-proyecto.vercel.app/producto/cs-200-a
```

## Paso 10: Configurar Redeploys Automáticos

Vercel automáticamente detectará cambios en tu rama `main` y hará redeploy.

Para desactivar esto:
1. Settings > Git
2. Desactiva "Automatic Deployments from GitHub"

## Variables de Entorno - Referencia Rápida

```env
# Production
NEXT_PUBLIC_MEDUSA_BACKEND_URL=https://api.midominio.com
NEXT_PUBLIC_MEDUSA_PUBLISHABLE_KEY=pk_prod_XXXX
NEXT_PUBLIC_BASE_URL=https://tu-proyecto.vercel.app
DATABASE_URL=postgresql://user:pass@host:5432/db
```

## Troubleshooting

### Error: "Cannot connect to database"

- Verifica que `DATABASE_URL` sea correcta
- Asegúrate de que la base de datos esté accesible desde Vercel
- Revisa los logs: Deployments > tu deploy > View Function Logs

### Error: "Cannot connect to Medusa backend"

- Verifica que `NEXT_PUBLIC_MEDUSA_BACKEND_URL` sea correcta
- Asegúrate de que el backend esté desplegado y accesible
- Prueba hacer curl desde tu navegador: `https://api.midominio.com/health`

### Error en Build

```bash
# Si el build falla, verifica localmente:
npm run build

# Revisa los logs de Vercel para ver el error específico
```

### Imágenes no cargan

Verifica que `next.config.ts` tenga configurados los dominios correctos:

```typescript
images: {
  remotePatterns: [
    {
      protocol: 'https',
      hostname: 'tu-cdn.com',
      pathname: '/**',
    },
  ],
}
```

## Comandos Útiles de Vercel CLI

```bash
# Ver logs en tiempo real
vercel logs

# Ver información del proyecto
vercel inspect

# Ver lista de deployments
vercel ls

# Promover un deployment a producción
vercel promote [deployment-url]

# Ver variables de entorno
vercel env ls

# Agregar variable de entorno
vercel env add VARIABLE_NAME
```

## Monitoreo y Analytics

Vercel proporciona:

- **Analytics**: Métricas de tráfico y rendimiento
- **Speed Insights**: Análisis de velocidad (Core Web Vitals)
- **Logs**: Logs de runtime y errores

Accede desde el dashboard: Analytics > Speed Insights > Logs

## Costos

Vercel ofrece:

- **Hobby Plan** (Gratis):
  - 100 GB bandwidth/mes
  - Deploy ilimitados
  - Dominios personalizados
  - HTTPS automático

- **Pro Plan** ($20/mes):
  - 1 TB bandwidth/mes
  - Analytics avanzados
  - Password protection
  - Soporte prioritario

Para este proyecto, el plan gratuito es suficiente en la mayoría de casos.

## Seguridad

Vercel automáticamente proporciona:

- ✅ HTTPS/SSL gratuito
- ✅ DDoS protection
- ✅ Edge Network global
- ✅ Previews aislados por rama

## Siguiente Paso: Conectar con Backend

Asegúrate de que tu backend de Medusa también esté desplegado y configurado:

1. Backend desplegado en Railway/Heroku/etc.
2. Base de datos PostgreSQL configurada
3. CORS configurado para permitir tu dominio de Vercel
4. Publishable Keys configuradas

## Recursos Adicionales

- [Documentación de Vercel](https://vercel.com/docs)
- [Next.js Deployment](https://nextjs.org/docs/deployment)
- [Medusa Deployment Guide](https://docs.medusajs.com/deployment)

---

**Listo para producción con Vercel + Next.js 16 + Medusa v2**
