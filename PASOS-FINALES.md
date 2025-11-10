# 🎯 ÚLTIMOS 3 PASOS PARA TENER TU TIENDA EN LA NUBE

## 📍 DÓNDE ESTÁS AHORA

```
✅ Frontend desplegado en Vercel
✅ Base de datos en Neon funcionando
✅ Backend code en Railway
🔄 Falta: Configurar variables en Railway
```

---

## 🚀 PASO 1: CONFIGURAR RAILWAY (3 minutos)

### Opción A: Copy-Paste Rápido (RECOMENDADO)

1. **Abre Railway:**
   ```
   https://railway.app/dashboard
   ```

2. **Entra a tu proyecto:**
   - Click en **"medusa-backend"**

3. **Ve a Variables:**
   - Click en la pestaña **"Variables"**

4. **Usa Raw Editor:**
   - Click en **"Raw Editor"** (botón arriba a la derecha)

5. **Copia y pega esto:**
   ```
   DATABASE_URL=postgresql://neondb_owner:npg_XAcOGj9Kf0vU@ep-billowing-cake-aex6r2oa-pooler.c-2.us-east-2.aws.neon.tech/neondb?sslmode=require
   JWT_SECRET=supersecretkey123medusa
   COOKIE_SECRET=supersecretcookie456medusa
   ADMIN_CORS=*
   STORE_CORS=https://medusa-storefront-product-template.vercel.app,http://localhost:3000
   ```

6. **Guarda:**
   - Click en **"Update Variables"**

7. **Espera:**
   - Railway hará redeploy automático (2-3 minutos)
   - Verás el progreso en la pestaña "Deployments"

### ¿Dónde está esto?

El texto completo está en:
```
/Users/ivankorzyniewski/medusa-backend/COPIAR-VARIABLES.txt
```

---

## 🌐 PASO 2: OBTENER URL DE RAILWAY

Después de que termine el deploy:

1. **Ve a Settings:**
   - En tu proyecto de Railway, click en **"Settings"**

2. **Genera dominio:**
   - Busca la sección **"Networking"**
   - Click en **"Generate Domain"**

3. **Copia la URL:**
   - Railway te dará algo como:
   ```
   https://medusa-backend-production-xxxx.up.railway.app
   ```
   - **Cópiala completa**

---

## 🔗 PASO 3: CONECTAR VERCEL CON RAILWAY

Ya tengo un script listo para hacer esto automáticamente:

```bash
cd /Users/ivankorzyniewski/medusa-storefront-product-template-20251106
bash conectar-railway.sh https://medusa-backend-production-xxxx.up.railway.app
```

Reemplaza `https://medusa-backend-production-xxxx.up.railway.app` con tu URL real de Railway.

### ¿Qué hace este script?

1. ✅ Verifica que tu backend de Railway esté funcionando
2. ✅ Actualiza la variable `NEXT_PUBLIC_MEDUSA_BACKEND_URL` en Vercel
3. ✅ Redeploy automático del frontend
4. ✅ Te da la URL final para probar

---

## 🎉 ¡LISTO!

Después del PASO 3, tu tienda estará funcionando en:

```
https://medusa-storefront-product-template.vercel.app
```

Y tu producto de prueba en:

```
https://medusa-storefront-product-template.vercel.app/producto/cummins-cs200a
```

**¡Exactamente como funciona en localhost!** 🚀

---

## 🆘 SI ALGO NO FUNCIONA

Escríbeme:
- "terminé paso 1" → cuando termines Railway
- "no puedo encontrar X" → si te trabaste
- Screenshot → si no sabes qué hacer

O simplemente pégame tu **URL de Railway** cuando la tengas, y yo ejecuto el script por ti.

---

## 📂 ARCHIVOS DE REFERENCIA

- Variables completas: `/Users/ivankorzyniewski/medusa-backend/COPIAR-VARIABLES.txt`
- Guía detallada Railway: `/Users/ivankorzyniewski/medusa-backend/PASO-A-PASO-RAILWAY.md`
- Script de conexión: `/Users/ivankorzyniewski/medusa-storefront-product-template-20251106/conectar-railway.sh`

---

**¡Estás a 10 minutos de tener tu tienda funcionando! 💪**
