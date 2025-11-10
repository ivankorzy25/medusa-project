#!/bin/bash

# Script para conectar el frontend de Vercel con el backend de Railway
# Uso: bash conectar-railway.sh [URL_DE_RAILWAY]

set -e

echo "════════════════════════════════════════════════════════════════"
echo "  🔗 CONECTAR VERCEL CON RAILWAY"
echo "════════════════════════════════════════════════════════════════"
echo ""

# Verificar que se pasó la URL
if [ -z "$1" ]; then
    echo "❌ Error: Necesito la URL de Railway"
    echo ""
    echo "Uso:"
    echo "  bash conectar-railway.sh https://medusa-backend-production-xxxx.up.railway.app"
    echo ""
    echo "La URL de Railway la encuentras en:"
    echo "  1. Ve a https://railway.app/dashboard"
    echo "  2. Click en tu proyecto 'medusa-backend'"
    echo "  3. Click en 'Settings'"
    echo "  4. Sección 'Networking' → 'Generate Domain'"
    echo "  5. Copia la URL que te da Railway"
    echo ""
    exit 1
fi

RAILWAY_URL="$1"

# Limpiar URL (quitar trailing slash si existe)
RAILWAY_URL="${RAILWAY_URL%/}"

echo "✅ URL de Railway: $RAILWAY_URL"
echo ""

# Verificar que la URL es válida
if [[ ! $RAILWAY_URL =~ ^https?:// ]]; then
    echo "❌ Error: La URL debe empezar con http:// o https://"
    echo "Ejemplo: https://medusa-backend-production-xxxx.up.railway.app"
    exit 1
fi

echo "🔍 Probando conectividad con Railway..."
if curl -s -o /dev/null -w "%{http_code}" "$RAILWAY_URL/health" | grep -q "200"; then
    echo "✅ Backend de Railway responde correctamente"
else
    echo "⚠️  Advertencia: El backend no responde en /health"
    echo "   Continuaré de todas formas, pero verifica que Railway esté desplegado"
fi
echo ""

echo "📝 Actualizando variable de entorno en Vercel..."
echo ""

# Actualizar la variable en Vercel
npx vercel env rm NEXT_PUBLIC_MEDUSA_BACKEND_URL production --yes 2>/dev/null || true
echo "$RAILWAY_URL" | npx vercel env add NEXT_PUBLIC_MEDUSA_BACKEND_URL production

echo ""
echo "✅ Variable actualizada"
echo ""

echo "🚀 Desplegando frontend a producción..."
npx vercel --prod

echo ""
echo "════════════════════════════════════════════════════════════════"
echo "  ✅ ¡DEPLOY COMPLETO!"
echo "════════════════════════════════════════════════════════════════"
echo ""
echo "🎯 Tu tienda ya funciona en la nube:"
echo "   👉 https://medusa-storefront-product-template.vercel.app"
echo ""
echo "🔗 Backend conectado:"
echo "   👉 $RAILWAY_URL"
echo ""
echo "🧪 Prueba tu producto:"
echo "   👉 https://medusa-storefront-product-template.vercel.app/producto/cummins-cs200a"
echo ""
echo "════════════════════════════════════════════════════════════════"
