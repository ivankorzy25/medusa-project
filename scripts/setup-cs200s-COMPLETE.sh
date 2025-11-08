#!/bin/bash

# ============================================
# Script Maestro: Setup Completo CS200S
# ============================================
# Este script ejecuta TODO el proceso de importación:
# 1. Copia las 13 imágenes al public
# 2. Importa el producto a la base de datos
# 3. Verifica la importación
# ============================================

set -e  # Salir si hay error

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# Banner
clear
echo -e "${CYAN}${BOLD}"
echo "════════════════════════════════════════════════════════════════"
echo "   SETUP COMPLETO: CUMMINS CS200S"
echo "════════════════════════════════════════════════════════════════"
echo -e "${NC}"
echo -e "${BLUE}Producto:${NC} Generador Diesel Industrial 200 KVA"
echo -e "${BLUE}Modelo:${NC} CS200S (Silent - Insonorizado 71dB)"
echo -e "${BLUE}Precio:${NC} USD 28,707 (sin IVA)"
echo -e "${BLUE}Imágenes:${NC} 13 archivos WebP"
echo ""
echo -e "${YELLOW}Este script realizará:${NC}"
echo "  ✓ Copiar 13 imágenes al directorio public"
echo "  ✓ Importar producto completo a la base de datos"
echo "  ✓ Verificar importación exitosa"
echo ""
echo -e "${CYAN}════════════════════════════════════════════════════════════════${NC}"
echo ""

# Solicitar confirmación
read -p "¿Continuar con la importación? (y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Importación cancelada.${NC}"
    exit 0
fi

# Variables
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# ============================================
# PASO 1: COPIAR IMÁGENES
# ============================================
echo ""
echo -e "${CYAN}${BOLD}════════════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}${BOLD}PASO 1/3: COPIAR IMÁGENES${NC}"
echo -e "${CYAN}${BOLD}════════════════════════════════════════════════════════════════${NC}"
echo ""

if [ -f "$SCRIPT_DIR/copy-cs200s-images.sh" ]; then
    bash "$SCRIPT_DIR/copy-cs200s-images.sh"
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Imágenes copiadas exitosamente${NC}"
    else
        echo -e "${RED}❌ Error al copiar imágenes${NC}"
        exit 1
    fi
else
    echo -e "${RED}❌ No se encontró el script copy-cs200s-images.sh${NC}"
    exit 1
fi

# ============================================
# PASO 2: IMPORTAR A BASE DE DATOS
# ============================================
echo ""
echo -e "${CYAN}${BOLD}════════════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}${BOLD}PASO 2/3: IMPORTAR A BASE DE DATOS${NC}"
echo -e "${CYAN}${BOLD}════════════════════════════════════════════════════════════════${NC}"
echo ""

# Solicitar credenciales de base de datos
echo -e "${YELLOW}Ingrese la cadena de conexión a PostgreSQL:${NC}"
echo -e "${BLUE}Ejemplo:${NC} postgresql://usuario:password@localhost:5432/medusa-store"
echo -e "${BLUE}O presione ENTER para usar:${NC} postgresql://localhost:5432/medusa-store"
read -p "Conexión: " DB_CONNECTION

# Usar default si está vacío
if [ -z "$DB_CONNECTION" ]; then
    DB_CONNECTION="postgresql://localhost:5432/medusa-store"
fi

echo ""
echo -e "${BLUE}Ejecutando script SQL...${NC}"
echo -e "${BLUE}Archivo:${NC} $SCRIPT_DIR/import-cs200s-COMPLETE.sql"
echo ""

# Ejecutar SQL
psql "$DB_CONNECTION" -f "$SCRIPT_DIR/import-cs200s-COMPLETE.sql"

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}✅ Producto importado exitosamente${NC}"
else
    echo ""
    echo -e "${RED}❌ Error al importar producto${NC}"
    echo -e "${YELLOW}Verifica:${NC}"
    echo "  1. Que la base de datos esté corriendo"
    echo "  2. Que las credenciales sean correctas"
    echo "  3. Que existan las tablas Type, Collection, Categories y Tags"
    exit 1
fi

# ============================================
# PASO 3: VERIFICACIÓN
# ============================================
echo ""
echo -e "${CYAN}${BOLD}════════════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}${BOLD}PASO 3/3: VERIFICACIÓN${NC}"
echo -e "${CYAN}${BOLD}════════════════════════════════════════════════════════════════${NC}"
echo ""

echo -e "${BLUE}Verificando producto...${NC}"

# Query de verificación
VERIFICATION_QUERY="
SELECT
  'Producto' as tipo,
  id,
  title,
  handle
FROM product
WHERE id = 'prod_cummins_cs200s'
UNION ALL
SELECT
  'Variant' as tipo,
  id,
  sku,
  CAST(inventory_quantity AS TEXT)
FROM product_variant
WHERE product_id = 'prod_cummins_cs200s';
"

psql "$DB_CONNECTION" -c "$VERIFICATION_QUERY"

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}✅ Verificación exitosa${NC}"
else
    echo ""
    echo -e "${YELLOW}⚠️  No se pudo verificar automáticamente${NC}"
    echo -e "${YELLOW}   Verifica manualmente en el Admin Panel${NC}"
fi

# ============================================
# RESUMEN FINAL
# ============================================
echo ""
echo -e "${CYAN}${BOLD}════════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}${BOLD}✅ IMPORTACIÓN COMPLETADA${NC}"
echo -e "${CYAN}${BOLD}════════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}Producto creado:${NC}"
echo "  • ID: prod_cummins_cs200s"
echo "  • Handle: cummins-cs200s"
echo "  • Título: CUMMINS CS200S - Generador Diesel Industrial 200 KVA"
echo "  • SKU: GEN-CUM-CS200S-STD"
echo ""
echo -e "${BOLD}Especificaciones:${NC}"
echo "  • Potencia Stand-by: 200 KVA / 160 KW"
echo "  • Potencia Prime: 180 KVA / 144 KW"
echo "  • Motor: Cummins 6CTAA8.3-G (241 HP)"
echo "  • Alternador: Stamford UCI274G1"
echo "  • Panel: Comap MRS16"
echo "  • Nivel de ruido: 71 dB (INSONORIZADO)"
echo "  • Peso: 2,500 kg"
echo ""
echo -e "${BOLD}Precio:${NC}"
echo "  • Sin IVA: USD 28,707.00"
echo "  • Con IVA 10.5%: USD 31,721.24"
echo ""
echo -e "${BOLD}Contenido importado:${NC}"
echo "  ✓ 1 Producto con 60+ campos de metadata"
echo "  ✓ 1 Variant (SKU) con stock de 5 unidades"
echo "  ✓ 13 Imágenes en formato WebP"
echo "  ✓ Taxonomía completa (Type, Collection, Category, 11 Tags)"
echo "  ✓ Precios en USD"
echo ""
echo -e "${BOLD}URLs de acceso:${NC}"
echo -e "  ${BLUE}Storefront:${NC} http://localhost:8000/products/cummins-cs200s"
echo -e "  ${BLUE}Admin:${NC}      http://localhost:9000/a/products/prod_cummins_cs200s"
echo ""
echo -e "${YELLOW}Próximos pasos:${NC}"
echo "  1. Abrir el Admin Panel y verificar el producto"
echo "  2. Revisar que las 13 imágenes se muestren correctamente"
echo "  3. Verificar precios y stock"
echo "  4. Probar búsqueda por 'cummins cs200s'"
echo "  5. Filtrar por tag 'insonorizado' (debe aparecer)"
echo ""
echo -e "${BLUE}Documentación:${NC}"
echo "  • Comparativa CS200A vs CS200S: docs/COMPARATIVA_CS200A_VS_CS200S.md"
echo "  • Guía completa: docs/CS200S_IMPORTACION_COMPLETA.md"
echo ""
echo -e "${CYAN}════════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${GREEN}${BOLD}¡IMPORTACIÓN EXITOSA! 🎉${NC}"
echo ""
