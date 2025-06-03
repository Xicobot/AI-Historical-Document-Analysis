#!/bin/bash
# Procesar cada archivo que coincida con el patrón *_batch_order.txt
for file in *_batch_order.txt; do
    if [ -f "$file" ]; then
        # Extraer el ID usando grep
        id=$(grep -o "msgbatch_[[:alnum:]]\+" "$file")
        
        # Procesar el nombre del archivo para obtener el nuevo nombre
        # Quita _batch_order del nombre del archivo
        output_file=$(basename "$file" "_batch_order.txt")_batch_output.txt
        
        if [ ! -z "$id" ]; then
            echo "Procesando archivo $file con ID: $id"
            echo "Guardando resultado en: $output_file"
            python recuperar_batch.py "$id" > "$output_file"
        else
            echo "No se encontró ID en el archivo $file"
        fi
    fi
done
