# 🛍️ Medusa Storefront - Sistema con Backup Automático

Frontend de e-commerce construido con Next.js 16 y Medusa.js v2 con sistema integrado de backup automático y versionado en GitHub.

## 📋 Descripción

Aplicación web moderna para la venta de generadores eléctricos industriales, con catálogo de productos, carrito de compras, y sistema de checkout integrado con Medusa.js.

## 🛠️ Stack Tecnológico

- **Framework**: Next.js 15 (App Router)
- **Language**: TypeScript
- **Styling**: Tailwind CSS
- **UI Components**: shadcn/ui
- **Backend**: Medusa.js v2 (API REST)
- **State Management**: TanStack Query
- **Package Manager**: pnpm

## 🚀 Quick Start

### Primera vez

```bash
# 1. Clonar el repositorio
git clone https://github.com/ivankorzy25/medusa-storefront.git
cd medusa-storefront

# 2. Ejecutar setup automático
npm run setup

# 3. Configurar .env.local con tus valores

# 4. Iniciar el servidor
npm run dev
```

### Desarrollo diario

```bash
# Iniciar servidor
npm run dev

# Después de hacer cambios, guardar backup
npm run backup
```

## ⚙️ Configuración

1. Crear archivo de environment:
```bash
cp .env.example .env.local
```

2. Configurar variables de entorno:
```env
NEXT_PUBLIC_MEDUSA_BACKEND_URL=http://192.168.1.100:9000
NEXT_PUBLIC_BASE_URL=http://192.168.1.100:3000
NEXT_PUBLIC_MEDUSA_PUBLISHABLE_KEY=tu_publishable_key
```

## 📦 Comandos Disponibles

### Desarrollo
- `npm run dev` - Inicia el servidor en modo desarrollo (puerto 3000)
- `npm run build` - Construye el proyecto para producción
- `npm run start` - Inicia el servidor en modo producción
- `npm run lint` - Ejecuta el linter

### Backup y Restauración
- `npm run backup` - **Backup completo** (código + builds + push a GitHub)
- `npm run backup:watch` - Watcher automático que monitorea cambios
- `npm run setup` - Setup completo desde GitHub

> 📖 **Documentación completa de backup:** Ver [COMO-USAR.md](./COMO-USAR.md)

## 📁 Estructura del Proyecto

```
storefront/
├── src/
│   ├── app/              # App Router pages
│   │   ├── producto/     # Página de productos
│   │   └── ...
│   ├── components/       # Componentes React
│   │   ├── products/     # Componentes de productos
│   │   └── ui/           # shadcn/ui components
│   └── lib/              # Utilidades y helpers
│       ├── medusa-client.ts  # Cliente Medusa SDK
│       └── format-price.ts   # Formateo de precios
├── public/               # Archivos estáticos
└── next.config.ts        # Configuración Next.js
```

## 🔗 Integración con Backend

El storefront se conecta al backend Medusa.js mediante:
- **API**: Store API de Medusa v2
- **SDK**: @medusajs/js-sdk
- **Region**: USD (United States)

## 🎨 Características

- ✅ Catálogo de productos con búsqueda
- ✅ Páginas de detalle de producto con galería de imágenes
- ✅ Especificaciones técnicas completas
- ✅ Sistema de precios con/sin impuestos
- ✅ Diseño responsive
- ✅ Dark mode support
- 🚧 Carrito de compras (en desarrollo)
- 🚧 Checkout (en desarrollo)
- 🚧 Sistema de autenticación (en desarrollo)

## 🔗 Repositorios Relacionados

Este proyecto es parte del ecosistema Medusa E-commerce:

- **Backend**: https://github.com/ivankorzy25/medusa-backend (API + DB + Admin Dashboard)
- **Storefront**: https://github.com/ivankorzy25/medusa-storefront (Frontend de tienda - este repo)

### ✅ Ventajas de la Separación:
- Aislamiento de problemas (frontend/backend independientes)
- Desarrollo paralelo sin conflictos
- Deploys separados
- Historial de commits limpio y organizado
- Escalabilidad independiente

## 🚀 Despliegue en Vercel

Para desplegar el proyecto en producción, consulta la guía completa:

**[📘 DESPLIEGUE-VERCEL.md](./DESPLIEGUE-VERCEL.md)**

La guía incluye:
- Configuración de base de datos en producción (Railway/Supabase/Neon)
- Variables de entorno necesarias
- Pasos detallados de deploy
- Configuración de dominio personalizado
- Troubleshooting común

### Variables de entorno para Vercel:

```env
NEXT_PUBLIC_MEDUSA_BACKEND_URL=https://api.midominio.com
NEXT_PUBLIC_MEDUSA_PUBLISHABLE_KEY=pk_test_XXXX
NEXT_PUBLIC_BASE_URL=https://medusa-project.vercel.app
DATABASE_URL=postgresql://usuario:clave@host:puerto/db
```

## 🆘 Troubleshooting

Ver documentación completa en [COMO-USAR.md](./COMO-USAR.md)

## 📚 Documentación Adicional

- [Guía de despliegue en Vercel](./DESPLIEGUE-VERCEL.md)
- [Guía de implementación de variantes](./GUIA-IMPLEMENTACION-VARIANTES.md)
- [Análisis del sistema de variantes](./ANALISIS-SISTEMA-VARIANTES.md)
- [Arquitectura de productos](./ARQUITECTURA-PRODUCTOS-DEFINITIVA.md)

---

**Generado con ❤️ usando Next.js, Medusa.js y Claude Code**
