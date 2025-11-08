#!/bin/bash

# ============================================
# Script: Copiar Imágenes CS200S al Public
# ============================================
# Este script copia las 13 imágenes del CS200S
# desde la carpeta de recuperación al directorio
# public del storefront.
# ============================================

set -e  # Salir si hay error

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Directorios
SOURCE_DIR="/Users/ivankorzyniewski/Desktop/RECUPERACION_V_DRIVE/GENERADORES/001-GENERADORES/GAUCHO Generadores Cummins - Linea CS/CS200S/IMAGENES-CS 200 S"
TARGET_DIR="/Users/ivankorzyniewski/medusa-storefront-product-template-20251106/public/productos/cummins/cs200s"

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}COPIAR IMÁGENES CS200S${NC}"
echo -e "${BLUE}============================================${NC}"

# Verificar que existe el directorio origen
if [ ! -d "$SOURCE_DIR" ]; then
    echo -e "${RED}❌ ERROR: No existe el directorio origen${NC}"
    echo -e "${RED}   $SOURCE_DIR${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Directorio origen encontrado${NC}"
echo -e "   $SOURCE_DIR"

# Contar imágenes en origen
IMAGE_COUNT=$(ls -1 "$SOURCE_DIR"/*.webp 2>/dev/null | wc -l | tr -d ' ')
echo -e "${GREEN}✅ Imágenes encontradas: $IMAGE_COUNT${NC}"

if [ "$IMAGE_COUNT" -ne 13 ]; then
    echo -e "${YELLOW}⚠️  ADVERTENCIA: Se esperaban 13 imágenes, se encontraron $IMAGE_COUNT${NC}"
fi

# Crear directorio destino si no existe
echo ""
echo -e "${BLUE}Creando directorio destino...${NC}"
mkdir -p "$TARGET_DIR"
echo -e "${GREEN}✅ Directorio creado/verificado${NC}"
echo -e "   $TARGET_DIR"

# Copiar imágenes con nombres estandarizados
echo ""
echo -e "${BLUE}Copiando imágenes...${NC}"

# Array con mapeo de nombres
declare -A IMAGE_MAP
IMAGE_MAP["CS 200 S_20251014_153804_1.webp"]="CS_200_S_20251014_153804_1.webp"
IMAGE_MAP["CS 200 S_20251014_153804_2.webp"]="CS_200_S_20251014_153804_2.webp"
IMAGE_MAP["CS 200 S_20251014_153804_3.webp"]="CS_200_S_20251014_153804_3.webp"
IMAGE_MAP["CS 200 S_20251014_153804_4.webp"]="CS_200_S_20251014_153804_4.webp"
IMAGE_MAP["CS 200 S_20251014_153804_5.webp"]="CS_200_S_20251014_153804_5.webp"
IMAGE_MAP["CS 200 S_20251014_153804_6.webp"]="CS_200_S_20251014_153804_6.webp"
IMAGE_MAP["CS 200 S_20251014_153804_7.webp"]="CS_200_S_20251014_153804_7.webp"
IMAGE_MAP["CS 200 S_20251014_153804_8.webp"]="CS_200_S_20251014_153804_8.webp"
IMAGE_MAP["CS 200 S_20251014_153804_9.webp"]="CS_200_S_20251014_153804_9.webp"
IMAGE_MAP["CS 200 S_20251014_153804_10.webp"]="CS_200_S_20251014_153804_10.webp"
IMAGE_MAP["CS 200 S_20251014_153804_11.webp"]="CS_200_S_20251014_153804_11.webp"
IMAGE_MAP["CS 200 S_20251014_153804_12.webp"]="CS_200_S_20251014_153804_12.webp"
IMAGE_MAP["CS 200 S_20251014_153804_13.webp"]="CS_200_S_20251014_153804_13.webp"

COPIED=0
ERRORS=0

for SOURCE_NAME in "${!IMAGE_MAP[@]}"; do
    TARGET_NAME="${IMAGE_MAP[$SOURCE_NAME]}"
    SOURCE_FILE="$SOURCE_DIR/$SOURCE_NAME"
    TARGET_FILE="$TARGET_DIR/$TARGET_NAME"

    if [ -f "$SOURCE_FILE" ]; then
        cp "$SOURCE_FILE" "$TARGET_FILE"
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ $TARGET_NAME${NC}"
            ((COPIED++))
        else
            echo -e "${RED}❌ Error copiando $SOURCE_NAME${NC}"
            ((ERRORS++))
        fi
    else
        echo -e "${YELLOW}⚠️  No encontrado: $SOURCE_NAME${NC}"
        ((ERRORS++))
    fi
done

# Resumen
echo ""
echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}RESUMEN${NC}"
echo -e "${BLUE}============================================${NC}"
echo -e "${GREEN}Imágenes copiadas: $COPIED${NC}"
echo -e "${RED}Errores: $ERRORS${NC}"

if [ $COPIED -eq 13 ] && [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}✅ ÉXITO: Todas las imágenes copiadas correctamente${NC}"
else
    echo -e "${YELLOW}⚠️  ADVERTENCIA: Algunas imágenes no se copiaron${NC}"
fi

# Verificar permisos
echo ""
echo -e "${BLUE}Verificando permisos...${NC}"
chmod 644 "$TARGET_DIR"/*.webp 2>/dev/null
echo -e "${GREEN}✅ Permisos ajustados (644)${NC}"

# Listar archivos copiados
echo ""
echo -e "${BLUE}Archivos en destino:${NC}"
ls -lh "$TARGET_DIR"/*.webp

echo ""
echo -e "${BLUE}============================================${NC}"
echo -e "${GREEN}✅ PROCESO COMPLETADO${NC}"
echo -e "${BLUE}============================================${NC}"
echo -e "Directorio destino: $TARGET_DIR"
echo -e "Total archivos: $(ls -1 "$TARGET_DIR"/*.webp 2>/dev/null | wc -l | tr -d ' ')"
echo ""
echo -e "${YELLOW}Próximo paso:${NC}"
echo -e "  Ejecutar el script SQL para importar el producto:"
echo -e "  ${BLUE}psql [CONEXION] -f scripts/import-cs200s-COMPLETE.sql${NC}"
echo ""
