#!/bin/bash

# Extraer todos los textos en un único archivo, sin separadores

# Limpiar/crear archivo de salida
> textos_completos.txt

# Extraer todos los texto_completo de todos los JSON
for archivo in *.json; do
    [ -f "$archivo" ] && jq -r '.noticias_musicales[].texto_completo' "$archivo" >> textos_completos.txt
done

echo "Extracción completada en: textos_completos.txt"
