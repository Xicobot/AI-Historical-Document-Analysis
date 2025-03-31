# Sistema de Procesamiento por Lotes para Transcripción de Documentos Históricos

## Introducción

Este sistema está diseñado para procesar masivamente documentos históricos en formato PDF y generar transcripciones en formato JSON utilizando la API de Claude. El conjunto de scripts permite automatizar el envío de solicitudes por lotes (batches) y la recuperación posterior de los resultados, facilitando el trabajo con grandes volúmenes de documentos históricos, especialmente aquellos relacionados con noticias musicales de épocas pasadas.

## Componentes del Sistema

El sistema consta de cuatro scripts principales que trabajan en conjunto:

1. **script.sh**: Script principal que itera sobre todos los archivos PDF en el directorio actual y lanza el proceso de solicitud de transcripción para cada uno.

2. **musica.py**: Script de Python que se encarga de codificar un archivo PDF en base64 y enviarlo como solicitud de procesamiento por lotes (batch) a la API de Claude, con instrucciones específicas para la transcripción de noticias musicales en documentos históricos.

3. **descargarbatches.sh**: Script que procesa los archivos de órdenes de lotes generados, extrae los identificadores de los lotes y ejecuta el script de recuperación para obtener los resultados.

4. **recuperar_batch.py**: Script que utiliza los identificadores de lotes para solicitar y mostrar los resultados del procesamiento a la API de Claude.

## Flujo de Trabajo

El sistema funciona de la siguiente manera:

1. El usuario coloca los archivos PDF a procesar en el directorio de trabajo.
2. Se ejecuta `script.sh`, que para cada archivo PDF:
   - Invoca `musica.py` con el nombre del archivo y un ID personalizado
   - Genera un archivo de orden de lote con formato `[nombre_archivo]_batch_order.txt`
3. Después de completar todas las solicitudes, se ejecuta `descargarbatches.sh`, que:
   - Busca todos los archivos de orden de lote generados anteriormente
   - Extrae el ID del lote de cada archivo
   - Ejecuta `recuperar_batch.py` para cada ID, recuperando el resultado
   - Guarda el resultado en un archivo con formato `[nombre_archivo]_batch_output.txt`

Este sistema está especialmente optimizado para la transcripción de documentos históricos con contenido musical, como periódicos antiguos, partituras, o documentos relacionados con eventos musicales del pasado.

## Requisitos

- Python 3.x
- Biblioteca Anthropic para Python (para acceso a la API de Claude)
- Bash (para ejecutar los scripts shell)
- Credenciales válidas para la API de Claude
- Archivos PDF a procesar

## Consideraciones

El sistema está configurado específicamente para identificar y transcribir noticias musicales en documentos históricos, incluyendo:
- Óperas, conciertos y representaciones musicales
- Documentos sobre establecimientos de ópera
- Listas de actores de compañías teatrales y cómicas
- Poesías y textos que pudieran ser cantados
- Innovaciones relacionadas con instrumentos musicales
- Cualquier mención a música, representaciones, tonadas o tonadillas
- Información sobre asistencia a espectáculos musicales

La salida del sistema es un archivo JSON estructurado con las transcripciones completas de las noticias musicales encontradas en los documentos.
