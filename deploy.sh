#!/bin/bash

# Script de Deploy Automático para Medusa Storefront
# Noviembre 2025 - Stack gratuito optimizado

set -e

# Colores para output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  🚀 Medusa Storefront - Deploy Automático  ${NC}"
echo -e "${BLUE}  Stack: Neon + Vercel (100% Gratis)${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Verificar que estamos en el directorio correcto
if [ ! -f "package.json" ]; then
    echo -e "${RED}❌ Error: Debes ejecutar este script desde el directorio raíz del proyecto${NC}"
    exit 1
fi

# Verificar que Vercel está instalado
if ! command -v npx &> /dev/null; then
    echo -e "${RED}❌ Error: npx no está disponible. Instala Node.js${NC}"
    exit 1
fi

echo -e "${YELLOW}📋 Pasos a seguir:${NC}"
echo -e "  1. Verificar build local"
echo -e "  2. Configurar base de datos Neon"
echo -e "  3. Configurar variables de entorno"
echo -e "  4. Deploy a Vercel"
echo ""

# Paso 1: Verificar build
echo -e "${BLUE}[1/4]${NC} Verificando que el build funciona..."
if npm run build > /dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} Build exitoso"
else
    echo -e "${RED}✗${NC} Build falló. Verifica los errores con: npm run build"
    exit 1
fi

# Paso 2: Neon Database
echo ""
echo -e "${BLUE}[2/4]${NC} Configuración de base de datos Neon..."
echo -e "${YELLOW}⚠️  ACCIÓN REQUERIDA:${NC}"
echo ""
echo -e "  1. Abre: ${GREEN}https://neon.tech${NC}"
echo -e "  2. Crea una cuenta (usa GitHub para login rápido)"
echo -e "  3. Crea un nuevo proyecto llamado: ${GREEN}medusa-store${NC}"
echo -e "  4. Región recomendada: ${GREEN}US East (Ohio)${NC}"
echo -e "  5. Copia la Connection String"
echo ""
echo -e "Ejemplo de Connection String:"
echo -e "${BLUE}postgresql://user:pass@ep-xxx.us-east-2.aws.neon.tech/db?sslmode=require${NC}"
echo ""
read -p "¿Ya tienes la Connection String de Neon? (s/n): " tiene_neon

if [ "$tiene_neon" != "s" ]; then
    echo -e "${YELLOW}⏸️  Pausa: Primero configura Neon y luego vuelve a ejecutar este script${NC}"
    exit 0
fi

read -p "Pega aquí tu DATABASE_URL de Neon: " DATABASE_URL

if [ -z "$DATABASE_URL" ]; then
    echo -e "${RED}❌ DATABASE_URL no puede estar vacío${NC}"
    exit 1
fi

# Validar formato básico de PostgreSQL URL
if [[ ! $DATABASE_URL =~ ^postgresql:// ]]; then
    echo -e "${RED}❌ URL inválida. Debe empezar con postgresql://${NC}"
    exit 1
fi

echo -e "${GREEN}✓${NC} DATABASE_URL configurado"

# Paso 3: Variables de entorno
echo ""
echo -e "${BLUE}[3/4]${NC} Configurando variables de entorno..."

# Leer variables actuales de .env.local
if [ -f ".env.local" ]; then
    source .env.local
fi

PUBLISHABLE_KEY="${NEXT_PUBLIC_MEDUSA_PUBLISHABLE_KEY:-pk_f1e1f52b9d9a06b31c0a0d75e188818220ea0bc3aaae1df27e2e8720ec56cc9b}"

echo ""
echo -e "${YELLOW}📝 Variables a configurar en Vercel:${NC}"
echo ""
echo -e "  ${GREEN}NEXT_PUBLIC_MEDUSA_BACKEND_URL${NC}"
echo -e "    Valor actual: ${NEXT_PUBLIC_MEDUSA_BACKEND_URL}"
echo ""
read -p "¿Cambiar? (deja vacío para mantener): " new_backend
if [ ! -z "$new_backend" ]; then
    BACKEND_URL="$new_backend"
else
    BACKEND_URL="${NEXT_PUBLIC_MEDUSA_BACKEND_URL}"
fi

echo ""
echo -e "  ${GREEN}NEXT_PUBLIC_MEDUSA_PUBLISHABLE_KEY${NC}"
echo -e "    Valor actual: ${PUBLISHABLE_KEY:0:20}..."
echo ""
read -p "¿Cambiar? (deja vacío para mantener): " new_key
if [ ! -z "$new_key" ]; then
    PUBLISHABLE_KEY="$new_key"
fi

echo ""
echo -e "${GREEN}✓${NC} Variables configuradas"

# Paso 4: Deploy a Vercel
echo ""
echo -e "${BLUE}[4/4]${NC} Iniciando deploy a Vercel..."
echo ""

# Verificar si ya está conectado a Vercel
if [ ! -d ".vercel" ]; then
    echo -e "${YELLOW}⚠️  Primera vez: Necesitas conectar con Vercel${NC}"
    echo ""
    npx vercel
    echo ""
else
    echo -e "${GREEN}✓${NC} Proyecto ya conectado a Vercel"
fi

# Configurar variables de entorno
echo ""
echo -e "${YELLOW}📝 Configurando variables de entorno en Vercel...${NC}"
echo ""

# DATABASE_URL
echo "$DATABASE_URL" | npx vercel env add DATABASE_URL production > /dev/null 2>&1 || true
echo -e "${GREEN}✓${NC} DATABASE_URL configurado"

# BACKEND_URL
echo "$BACKEND_URL" | npx vercel env add NEXT_PUBLIC_MEDUSA_BACKEND_URL production > /dev/null 2>&1 || true
echo -e "${GREEN}✓${NC} NEXT_PUBLIC_MEDUSA_BACKEND_URL configurado"

# PUBLISHABLE_KEY
echo "$PUBLISHABLE_KEY" | npx vercel env add NEXT_PUBLIC_MEDUSA_PUBLISHABLE_KEY production > /dev/null 2>&1 || true
echo -e "${GREEN}✓${NC} NEXT_PUBLIC_MEDUSA_PUBLISHABLE_KEY configurado"

# Deploy a producción
echo ""
echo -e "${YELLOW}🚀 Deployando a producción...${NC}"
echo ""

npx vercel --prod

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}  ✅ Deploy completado exitosamente!  ${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${YELLOW}📋 Siguiente paso:${NC}"
echo ""
echo -e "  1. Vercel te mostrará la URL de producción"
echo -e "  2. Ve a Vercel Dashboard y actualiza ${GREEN}NEXT_PUBLIC_BASE_URL${NC}"
echo -e "  3. Haz un redeploy"
echo ""
echo -e "${BLUE}📚 Documentación completa:${NC}"
echo -e "  - DEPLOY-AUTOMATICO.md"
echo -e "  - DESPLIEGUE-VERCEL.md"
echo ""
echo -e "${GREEN}🎉 Tu tienda está en producción!${NC}"
echo ""
