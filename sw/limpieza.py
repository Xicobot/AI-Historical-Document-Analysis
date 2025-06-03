#!/usr/bin/env python3
import os
import json
import re
import sys
from pathlib import Path

# Crear directorio para los JSON extraídos
output_dir = Path("json_extraidos")
output_dir.mkdir(exist_ok=True)

# Patrón para extraer JSON de la estructura BetaMessageBatchIndividualResponse
json_pattern = re.compile(r"text='.*?```json\s*(.*?)\s*```.*?'", re.DOTALL)

# Procesar todos los archivos batch_output.txt
for file_path in Path('.').glob('*batch_output.txt'):
    print(f"Procesando {file_path}...")
    
    # Extraer nombre base del archivo
    base_name = file_path.stem.replace('_batch_output', '')
    output_file = output_dir / f"{base_name}.json"
    
    try:
        # Leer el contenido del archivo
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Buscar el patrón de JSON
        match = json_pattern.search(content)
        
        if match:
            # Extraer y limpiar el JSON
            json_content = match.group(1)
            json_content = json_content.replace('\\n', '\n').replace('\\t', '\t')
            json_content = json_content.replace('\\r', '').replace('\\\\', '\\')
            json_content = json_content.replace('\\"', '"')
            
            # Verificar si es un JSON válido
            try:
                json_obj = json.loads(json_content)
                # Guardar el JSON formateado
                with open(output_file, 'w', encoding='utf-8') as f:
                    json.dump(json_obj, f, ensure_ascii=False, indent=2)
                print(f"  JSON extraído exitosamente a {output_file}")
            except json.JSONDecodeError as e:
                print(f"  Error: JSON inválido en {file_path}: {e}")
                # Guardar el contenido sin procesar
                with open(f"{output_file}.raw", 'w', encoding='utf-8') as f:
                    f.write(json_content)
                print(f"  Contenido sin procesar guardado en {output_file}.raw")
        else:
            print(f"  Error: No se encontró contenido JSON en {file_path}")
            # Guardar los primeros 1000 caracteres para diagnóstico
            with open(f"{output_file}.sample", 'w', encoding='utf-8') as f:
                f.write(content[:1000])
            print(f"  Muestra del archivo guardada en {output_file}.sample")
    
    except Exception as e:
        print(f"  Error al procesar {file_path}: {e}")
