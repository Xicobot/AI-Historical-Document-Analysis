#!/bin/bash

# Organizador de PDFs por año
# Organiza archivos PDF en carpetas por año basandose en los primeros 4 caracteres del nombre

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo "======================================="
echo "    ORGANIZADOR DE PDFs POR AÑO"
echo "======================================="
echo

# Verificar si hay archivos PDF en el directorio actual
pdf_files=( *.pdf )
if [ ! -e "${pdf_files[0]}" ]; then
    echo -e "${RED}Error: No se encontraron archivos PDF en el directorio actual.${NC}"
    echo "Por favor, ejecuta este script desde la carpeta que contiene los PDFs."
    exit 1
fi

# Contar archivos PDF
pdf_count=${#pdf_files[@]}
echo -e "${BLUE}Encontrados ${pdf_count} archivos PDF en el directorio actual.${NC}"
echo

# Mostrar algunos ejemplos
echo "Ejemplos de archivos encontrados:"
count=0
for file in "${pdf_files[@]}"; do
    if [ $count -lt 5 ]; then
        echo "  - $file"
        count=$((count + 1))
    else
        break
    fi
done

if [ $pdf_count -gt 5 ]; then
    remaining=$((pdf_count - 5))
    echo "  ... y $remaining archivos mas"
fi
echo

# Analisis previo de archivos por año
declare -A years_count
files_without_year=0

echo "Analizando archivos por año..."
for file in "${pdf_files[@]}"; do
    # Extraer los primeros 4 caracteres
    year="${file:0:4}"
    
    # Verificar si es un año valido (4 digitos)
    if [[ $year =~ ^[0-9]{4}$ ]]; then
        years_count[$year]=$((${years_count[$year]} + 1))
    else
        files_without_year=$((files_without_year + 1))
    fi
done

# Mostrar resumen
echo
echo "Resumen de archivos por año:"
for year in $(printf '%s\n' "${!years_count[@]}" | sort); do
    echo -e "${GREEN}  Año $year: ${years_count[$year]} archivos${NC}"
done

if [ $files_without_year -gt 0 ]; then
    echo -e "${YELLOW}  Sin año valido: $files_without_year archivos${NC}"
fi

echo
# Confirmar antes de proceder
read -p "¿Deseas continuar con la organizacion? (s/N): " confirm
if [[ ! $confirm =~ ^[Ss]$ ]]; then
    echo "Operacion cancelada."
    exit 0
fi

echo
echo "Organizando archivos..."
echo

# Contadores para el resumen final
moved_files=0
errors=0
created_dirs=0

# Procesar cada archivo PDF
for file in "${pdf_files[@]}"; do
    # Extraer el año (primeros 4 caracteres)
    year="${file:0:4}"
    
    # Verificar si es un año valido
    if [[ $year =~ ^[0-9]{4}$ ]]; then
        # Crear carpeta del año si no existe
        if [ ! -d "$year" ]; then
            if mkdir "$year" 2>/dev/null; then
                echo -e "${BLUE}Creada carpeta: $year/${NC}"
                created_dirs=$((created_dirs + 1))
            else
                echo -e "${RED}Error creando carpeta: $year${NC}"
                errors=$((errors + 1))
                continue
            fi
        fi
        
        # Verificar si ya existe el archivo en destino
        if [ -e "$year/$file" ]; then
            echo -e "${YELLOW}  Ya existe: $file en $year/${NC}"
            continue
        fi
        
        # Mover archivo a la carpeta del año
        if mv "$file" "$year/" 2>/dev/null; then
            echo -e "${GREEN}  Movido: $file -> $year/${NC}"
            moved_files=$((moved_files + 1))
        else
            echo -e "${RED}  Error moviendo: $file${NC}"
            errors=$((errors + 1))
        fi
    else
        # Archivo sin año valido - crear carpeta Sin_Año
        if [ ! -d "Sin_Año" ]; then
            if mkdir "Sin_Año" 2>/dev/null; then
                echo -e "${BLUE}Creada carpeta: Sin_Año/${NC}"
                created_dirs=$((created_dirs + 1))
            else
                echo -e "${RED}Error creando carpeta: Sin_Año${NC}"
                errors=$((errors + 1))
                continue
            fi
        fi
        
        # Verificar si ya existe el archivo en destino
        if [ -e "Sin_Año/$file" ]; then
            echo -e "${YELLOW}  Ya existe: $file en Sin_Año/${NC}"
            continue
        fi
        
        # Mover archivo a carpeta Sin_Año
        if mv "$file" "Sin_Año/" 2>/dev/null; then
            echo -e "${GREEN}  Movido: $file -> Sin_Año/ (sin año valido)${NC}"
            moved_files=$((moved_files + 1))
        else
            echo -e "${RED}  Error moviendo: $file${NC}"
            errors=$((errors + 1))
        fi
    fi
done

# Resumen final
echo
echo "======================================="
echo "             RESUMEN FINAL"
echo "======================================="
echo -e "${GREEN}Archivos movidos exitosamente: $moved_files${NC}"
echo -e "${BLUE}Carpetas creadas: $created_dirs${NC}"
if [ $errors -gt 0 ]; then
    echo -e "${RED}Errores: $errors${NC}"
fi
echo "======================================="
echo

# Mostrar estructura final
echo "Estructura de carpetas creada:"
for dir in */; do
    if [ -d "$dir" ]; then
        count=$(find "$dir" -name "*.pdf" | wc -l)
        echo -e "${BLUE}  📁 $dir ($count archivos)${NC}"
    fi
done

echo
echo -e "${GREEN}¡Organizacion completada!${NC}"
echo "Revisa las carpetas creadas para verificar el resultado."
