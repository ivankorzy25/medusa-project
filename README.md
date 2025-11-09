# Medusa Storefront - Sistema de Gestión de Productos

Frontend de e-commerce construido con Next.js 16 y Medusa.js v2, especializado en gestión de productos con variantes, accesorios compatibles y productos relacionados.

## Descripción

Aplicación web moderna para la venta de generadores eléctricos industriales, con catálogo de productos, sistema de variantes dinámico, accesorios compatibles, y checkout integrado con Medusa.js.

## Stack Tecnológico

- **Framework**: Next.js 16 (App Router)
- **React**: 19.2.0
- **Language**: TypeScript 5
- **Styling**: Tailwind CSS 4
- **UI Components**: Radix UI + shadcn/ui
- **Backend**: Medusa.js v2 (JS SDK)
- **Database**: PostgreSQL (pg driver)
- **State Management**: TanStack Query + Zustand
- **Forms**: React Hook Form + Zod
- **Animations**: Framer Motion
- **Package Manager**: npm/yarn/pnpm

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

## Requisitos Previos

- Node.js 18.x o superior
- PostgreSQL 14.x o superior
- Medusa Backend v2 corriendo (por defecto en puerto 9000)
- npm, yarn o pnpm

## Variables de Entorno

### Desarrollo Local

1. Crear archivo de environment:
```bash
cp .env.example .env.local
```

2. Configurar variables (`.env.local`):
```env
# Backend de Medusa
NEXT_PUBLIC_MEDUSA_BACKEND_URL=http://localhost:9000

# Publishable Key (obtener del dashboard de Medusa)
NEXT_PUBLIC_MEDUSA_PUBLISHABLE_KEY=pk_tu_clave_aqui

# URL del frontend
NEXT_PUBLIC_BASE_URL=http://localhost:3000

# Base de datos PostgreSQL
DATABASE_URL=postgresql://usuario:password@localhost:5432/medusa-store
```

### Producción (Vercel/Railway/etc.)

```env
# Backend de Medusa en producción
NEXT_PUBLIC_MEDUSA_BACKEND_URL=https://api.tu-dominio.com

# Publishable Key de producción
NEXT_PUBLIC_MEDUSA_PUBLISHABLE_KEY=pk_tu_clave_produccion

# URL del frontend en producción
NEXT_PUBLIC_BASE_URL=https://tu-dominio.com

# Base de datos PostgreSQL en producción (Railway/Supabase/Neon)
DATABASE_URL=postgresql://usuario:password@host.railway.app:5432/database
```

## Instalación y Configuración

### 1. Clonar el repositorio

```bash
git clone https://github.com/ivankorzy25/medusa-project.git
cd medusa-project
```

### 2. Instalar dependencias

```bash
npm install
# o
yarn install
# o
pnpm install
```

### 3. Configurar PostgreSQL

```bash
# Conectarse a PostgreSQL
psql -U postgres

# Crear la base de datos
CREATE DATABASE "medusa-store";

# Salir
\q
```

### 4. Configurar variables de entorno

```bash
cp .env.example .env.local
# Editar .env.local con tus valores específicos
```

### 5. Verificar conexión con Medusa Backend

Asegúrate de que tu Medusa Backend esté corriendo en `http://localhost:9000`

## Comandos Disponibles

### Desarrollo
```bash
npm run dev     # Inicia servidor desarrollo (puerto 3000)
npm run lint    # Ejecuta linter
```

### Producción
```bash
npm run build   # Crea build optimizado
npm run start   # Inicia servidor producción
```

### Backup y Restauración
```bash
npm run backup          # Backup completo (código + push a GitHub)
npm run backup:watch    # Watcher automático de cambios
npm run setup           # Setup completo desde GitHub
```

> **Documentación de backup:** Ver [COMO-USAR.md](./COMO-USAR.md)

## Estructura del Proyecto

```
medusa-storefront-product-template-20251106/
├── src/
│   ├── app/                           # App Router de Next.js
│   │   ├── producto/[handle]/         # Página dinámica de productos
│   │   └── ...
│   ├── components/                    # Componentes reutilizables
│   │   ├── products/                  # Componentes de productos
│   │   │   ├── VariantSelector.tsx    # Selector de variantes dinámico
│   │   │   ├── CompatibleAccessories.tsx  # Accesorios compatibles
│   │   │   ├── RelatedProducts.tsx    # Productos relacionados
│   │   │   └── ProductInfoTabs.tsx    # Tabs informativos
│   │   └── ui/                        # Componentes UI base (Radix/shadcn)
│   ├── lib/                           # Utilidades y helpers
│   │   ├── medusa-client.ts           # Cliente Medusa SDK
│   │   ├── variant-utils.ts           # Lógica de variantes
│   │   └── format-price.ts            # Formateo de precios
│   └── types/                         # Definiciones TypeScript
├── public/                            # Archivos estáticos
├── scripts/backup/                    # Scripts de backup automático
├── .env.example                       # Template de variables
├── .env.local                         # Variables locales (no commiteado)
├── next.config.ts                     # Configuración Next.js
├── tailwind.config.ts                 # Configuración Tailwind
└── package.json                       # Dependencias y scripts
```

## 🔗 Integración con Backend

El storefront se conecta al backend Medusa.js mediante:
- **API**: Store API de Medusa v2
- **SDK**: @medusajs/js-sdk
- **Region**: USD (United States)

## Características Principales

- Catálogo de productos con búsqueda y filtros
- Sistema completo de variantes dinámicas
- Selector de variantes con validación en tiempo real
- Accesorios compatibles por producto
- Sugerencias de productos relacionados
- Galería de imágenes con lightbox integrado
- Tabs informativos con especificaciones técnicas
- Sistema de precios con/sin impuestos
- Integración directa con PostgreSQL
- Diseño responsive y moderno
- Animaciones suaves con Framer Motion
- Optimizado para SEO

## Despliegue en Vercel

### Prerequisitos

1. **Probar localmente primero**:
```bash
npm run build    # Debe completarse sin errores
npm run start    # Verificar que funciona en modo producción
```

2. **Preparar base de datos en producción**:
   - Railway: https://railway.app
   - Supabase: https://supabase.com
   - Neon: https://neon.tech
   - AWS RDS (para enterprise)

### Pasos de despliegue

1. **Instalar Vercel CLI**:
```bash
npm i -g vercel
```

2. **Login y deploy**:
```bash
vercel login
vercel
```

3. **Configurar variables de entorno** en Vercel Dashboard:
   - `NEXT_PUBLIC_MEDUSA_BACKEND_URL`
   - `NEXT_PUBLIC_MEDUSA_PUBLISHABLE_KEY`
   - `NEXT_PUBLIC_BASE_URL`
   - `DATABASE_URL`

4. **Configurar dominios** en Project Settings

### Configuración de Next.js para producción

Modifica [next.config.ts](next.config.ts) para tus dominios:

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

## Troubleshooting

### Error: Cannot connect to database

```bash
# Verificar PostgreSQL
pg_isready

# Probar conexión manual
psql -U usuario -d medusa-store
```

### Error: Cannot connect to Medusa backend

```bash
# Verificar que el backend esté corriendo
curl http://localhost:9000/health

# Ver logs del backend
cd ../medusa-backend
npm run dev
```

### Error en build de producción

```bash
# Limpiar caché
rm -rf .next

# Reinstalar dependencias
rm -rf node_modules package-lock.json
npm install

# Intentar build nuevamente
npm run build
```

### Imágenes no cargan

Verifica que los dominios estén configurados en [next.config.ts](next.config.ts) y las URLs sean correctas.

## Documentación Adicional

- [Guía de implementación de variantes](./GUIA-IMPLEMENTACION-VARIANTES.md)
- [Análisis del sistema de variantes](./ANALISIS-SISTEMA-VARIANTES.md)
- [Arquitectura de productos](./ARQUITECTURA-PRODUCTOS-DEFINITIVA.md)
- [Documentación de backup](./COMO-USAR.md)

## Tecnologías y Dependencias

### Core
- Next.js 16.0.1
- React 19.2.0
- TypeScript 5

### UI/UX
- Tailwind CSS 4
- Radix UI (Accordion, Dialog, Label, Slot, Tabs)
- Framer Motion 12.23.24
- Lucide React (iconos)
- Embla Carousel
- Yet Another React Lightbox

### Backend/Data
- @medusajs/js-sdk 2.11.2
- PostgreSQL (pg 8.16.3)
- TanStack Query 5.90.7
- Zustand 5.0.8

### Forms & Validation
- React Hook Form 7.66.0
- Zod 4.1.12

### Utils
- class-variance-authority
- clsx
- tailwind-merge

## Licencia

Privado - Uso interno

## Repositorios Relacionados

- **Backend**: https://github.com/ivankorzy25/medusa-backend
- **Storefront**: https://github.com/ivankorzy25/medusa-project (este repo)

---

**Desarrollado con Next.js 16, Medusa.js v2 y Claude Code**
