# 🚀 Cómo Usar el Sistema de Backup Automático - Storefront

Tu frontend de Medusa ahora está **completamente configurado** con backup automático a GitHub!

## ✅ ¿Qué se configuró?

1. ✅ Repositorio creado en GitHub: https://github.com/ivankorzy25/medusa-storefront
2. ✅ Primer backup del código frontend creado
3. ✅ Sistema de versionado configurado
4. ✅ Todo el código subido a GitHub

## 📦 Formas de Hacer Backup

### Opción 1: Backup Manual (Recomendado para empezar)

Cuando hagas cambios importantes en el frontend:

```bash
cd /Users/ivankorzyniewski/medusa-storefront-product-template-20251106
npm run backup
```

Esto hará:
- ✅ Backup de builds de Next.js (si existen)
- ✅ Commit de todos los cambios de código
- ✅ Push automático a GitHub

### Opción 2: Watcher Automático (Para trabajar sin preocupaciones)

Inicia el watcher en una terminal separada:

```bash
cd /Users/ivankorzyniewski/medusa-storefront-product-template-20251106
npm run backup:watch
```

Esto monitoreará cambios en tiempo real y hará backup automáticamente cada 60 segundos cuando detecte modificaciones en:
- Archivos en `src/` (.tsx, .ts, .jsx, .js, .css)
- Archivos en `public/`
- Archivos de configuración (.env.local, next.config.ts, package.json, etc.)

**Uso recomendado:**
- Terminal 1: `npm run dev` (servidor Next.js)
- Terminal 2: `npm run backup:watch` (auto-backup)

## 🎯 Workflow Recomendado

### Para el Día a Día:

```bash
# 1. Iniciar el servidor Next.js
npm run dev

# 2. Trabaja normalmente (modifica componentes, estilos, etc.)

# 3. Cuando termines tu sesión de trabajo:
npm run backup
```

### Para Cambios en el Storefront:

Cuando modifiques componentes, páginas, o estilos:

```bash
# Después de agregar/modificar componentes
npm run backup
```

**El sistema guardará automáticamente:**
- Los cambios en el código frontend
- Configuraciones de Next.js
- Estilos y assets
- Todo quedará en GitHub con fecha y hora

## 📊 Ver Tu Historial de Backups

### En GitHub:
Visita: https://github.com/ivankorzy25/medusa-storefront/commits/main

Verás todos los commits con:
- Fecha y hora exacta
- Descripción de cambios
- Todo el código frontend versionado

### Localmente:
```bash
# Ver últimos commits
git log --oneline

# Ver backups de builds
ls -lht backups/builds/
```

## 🔄 Restaurar Si Algo Sale Mal

### Restaurar Código a Versión Anterior:

```bash
# 1. Ver versiones disponibles
git log --oneline

# 2. Volver a una versión específica
git checkout <commit-hash>

# 3. Si quieres hacer permanente este rollback
git checkout -b recovery
git push origin recovery
```

### Restaurar Build:

```bash
# Ver builds disponibles
ls -lht backups/builds/

# Restaurar un build específico
tar -xzf backups/builds/build-YYYYMMDD_HHMMSS.tar.gz
```

## 🌟 Comandos Útiles

```bash
# BACKUP
npm run backup           # Backup completo (código + builds + push)
npm run backup:watch     # Watcher automático
npm run setup            # Setup desde GitHub

# DESARROLLO
npm run dev              # Iniciar servidor Next.js (puerto 3000)
npm run build            # Construir para producción
npm run start            # Iniciar en modo producción

# GIT
git status               # Ver estado actual
git log --oneline        # Ver historial
git push origin main     # Push manual
```

## 💡 Tips y Mejores Prácticas

### 1. Backup Frecuente
Después de:
- Crear/modificar componentes importantes
- Cambiar estilos globales
- Agregar nuevas páginas
- Actualizar configuración
- Cualquier cambio crítico en UI/UX

→ Ejecuta: `npm run backup`

### 2. Commits Descriptivos
Si prefieres hacer commits manuales antes del backup:

```bash
git add .
git commit -m "Agregado componente de galería de productos"
npm run backup  # Esto solo hará push
```

### 3. Branches para Features Grandes
Para cambios grandes en la UI:

```bash
git checkout -b nueva-seccion-checkout
# ... haces cambios ...
npm run backup
git push origin nueva-seccion-checkout
```

### 4. Tags para Versiones Importantes
Marca hitos importantes:

```bash
git tag -a v1.0.0 -m "Versión 1.0: Storefront completo"
git push origin v1.0.0
```

## 🆘 Troubleshooting

### "Error al hacer push"
```bash
# Verificar conexión con GitHub
git remote -v

# Si falla, reconectar (usa tu token personal de GitHub)
git remote remove origin
git remote add origin "https://TU_TOKEN_GITHUB@github.com/ivankorzy25/medusa-storefront.git"
git push origin main
```

### "Error de conexión con backend"
Verifica tu archivo .env.local:

```bash
# Debe contener:
NEXT_PUBLIC_MEDUSA_BACKEND_URL=http://localhost:9000
NEXT_PUBLIC_MEDUSA_PUBLISHABLE_KEY=tu_key_aqui
NEXT_PUBLIC_BASE_URL=http://localhost:3000
```

### Ver el backup más reciente
```bash
# Último commit
git log -1

# Último build backup
ls -lht backups/builds/ | head -2
```

## 🔗 Integración con Backend

Este storefront está diseñado para trabajar con el backend de Medusa. Asegúrate de:

1. **Backend corriendo** en http://localhost:9000
2. **Publishable Key** configurada en .env.local
3. **CORS** configurado en el backend para permitir http://localhost:3000

## 📞 Resumen Rápido

**¿Cuándo hacer backup?**
- Después de modificar componentes o páginas
- Al final del día de trabajo
- Antes de hacer cambios grandes en UI
- Cuando algo funcione perfectamente (para poder volver)

**¿Cómo hacer backup?**
```bash
npm run backup
```

**¿Dónde están mis backups?**
- En GitHub: https://github.com/ivankorzy25/medusa-storefront
- Builds localmente: `backups/builds/`

**¿Cómo restaurar código?**
```bash
git log --oneline          # Ver versiones
git checkout <commit>      # Restaurar
```

---

## 🎨 Separación Frontend/Backend

Este repositorio contiene **solo el frontend** (storefront). Los beneficios de esta separación:

### ✅ Ventajas:
- **Aislamiento de problemas**: Un error en el frontend no afecta el backend
- **Desarrollo independiente**: Puedes trabajar en UI sin tocar la API
- **Deploys separados**: Actualiza el storefront sin reiniciar el backend
- **Historial limpio**: Commits de UI separados de commits de API/DB
- **Escalabilidad**: Cada parte puede escalar de forma independiente

### 🔗 Repositorios:
- **Backend**: https://github.com/ivankorzy25/medusa-backend (API + DB + Admin)
- **Storefront**: https://github.com/ivankorzy25/medusa-storefront (UI + Tienda)

### 🔄 Workflow Completo:
```bash
# Terminal 1: Backend
cd /Users/ivankorzyniewski/medusa-backend
npm run dev              # Puerto 9000

# Terminal 2: Frontend
cd /Users/ivankorzyniewski/medusa-storefront-product-template-20251106
npm run dev              # Puerto 3000

# Terminal 3 (opcional): Auto-backup Frontend
cd /Users/ivankorzyniewski/medusa-storefront-product-template-20251106
npm run backup:watch

# Terminal 4 (opcional): Auto-backup Backend
cd /Users/ivankorzyniewski/medusa-backend
npm run backup:watch
```

---

**¡Sistema completamente funcional y listo para usar!**

Ahora trabaja con tranquilidad sabiendo que todo tu frontend está respaldado automáticamente en GitHub.
