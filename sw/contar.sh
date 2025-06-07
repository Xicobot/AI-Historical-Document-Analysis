#!/bin/bash

# Nombre del archivo de salida
archivo_salida="total_paginas.txt"

# Inicializar contador de páginas
total_paginas=0

# Crear o sobrescribir el archivo de salida con un encabezado
echo "INFORME DE CONTEO DE PÁGINAS" > "$archivo_salida"
echo "===========================" >> "$archivo_salida"
echo "" >> "$archivo_salida"
echo "Fecha: $(date)" >> "$archivo_salida"
echo "" >> "$archivo_salida"
echo "DETALLE DE ARCHIVOS:" >> "$archivo_salida"
echo "-------------------" >> "$archivo_salida"

# Buscar todos los archivos PDF en el directorio actual
for archivo in *.pdf; do
    # Verificar que el archivo existe y es un archivo regular
    if [ -f "$archivo" ]; then
        # Obtener el número de páginas del PDF usando qpdf
        paginas=$(qpdf --show-npages "$archivo" 2>/dev/null)
        
        # Si hay error, intentar con grep en la salida de qpdf
        if [ $? -ne 0 ]; then
            paginas=$(qpdf --show-object=1 "$archivo" 2>/dev/null | grep -o "/Count [0-9]*" | awk '{print $2}')
        fi
        
        # Sumar al total
        total_paginas=$((total_paginas + paginas))
        
        # Mostrar información del archivo en la terminal
        echo "Archivo: $archivo - Páginas: $paginas"
        
        # Guardar información en el archivo de salida
        echo "- $archivo: $paginas páginas" >> "$archivo_salida"
    fi
done

# Añadir el total al archivo de salida
echo "" >> "$archivo_salida"
echo "RESUMEN:" >> "$archivo_salida"
echo "--------" >> "$archivo_salida"
echo "Total de archivos PDF: $(ls -1 *.pdf 2>/dev/null | wc -l)" >> "$archivo_salida"
echo "Total de páginas en todos los PDFs: $total_paginas" >> "$archivo_salida"

# Mostrar el total de páginas en la terminal
echo ""
echo "Total de páginas en todos los PDFs: $total_paginas"
echo "Reporte guardado en: $archivo_salida"
