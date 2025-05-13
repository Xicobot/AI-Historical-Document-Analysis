# Sistema de Procesamiento por Lotes para Transcripción de Documentos Históricos

## Introducción para Humanidades Digitales

En el ámbito de las humanidades digitales, la recuperación y procesamiento de fuentes primarias históricas representa uno de los mayores desafíos metodológicos. El presente sistema emerge como una respuesta tecnológica al complejo problema de extraer, procesar y hacer accesible el valioso patrimonio documental relacionado con la historia de la música en textos literarios y periodísticos de épocas pasadas.

La intersección entre música y literatura ha sido un campo fértil pero escasamente explorado debido a la dificultad de acceder sistemáticamente a las fuentes originales. Este sistema de procesamiento por lotes facilita el trabajo de los investigadores en humanidades digitales, permitiendo transformar documentos históricos digitalizados en formato PDF —frecuentemente caracterizados por tipografías antiguas, deterioro físico y estructuras textuales complejas— en datos estructurados y analizables mediante técnicas computacionales modernas.

La metodología implementada representa un ejemplo paradigmático de cómo las tecnologías de inteligencia artificial contemporáneas pueden ser aplicadas para revitalizar el estudio de nuestro patrimonio cultural, democratizando el acceso a fuentes que, de otro modo, permanecerían confinadas en archivos físicos o repositorios digitales poco accesibles. El enfoque interdisciplinario adoptado integra conocimientos de procesamiento de lenguaje natural, ciencia de datos, musicología histórica y estudios literarios, ejemplificando el potencial transformador de las humanidades digitales para reconfigurar nuestra comprensión del pasado cultural.

## Flujo completo del proceso

### 1. Obtención de los documentos
- **Identificación de la fuente web**: Localizar la página web que contiene los documentos históricos de interés.
- **Extracción de URLs**: Obtener las URLs de los documentos PDF mediante herramientas de scraping legítimas como DownloadThemAll.
- **Descarga de PDFs**: Descargar sistemáticamente los documentos PDF para su procesamiento.

### 2. Desarrollo de prompts
- **Investigación y comprensión**: Invertir tiempo en investigar y comprender el contexto histórico y los campos específicos que se desean extraer.
- **Diseño del prompt**: Crear un prompt detallado con instrucciones claras para Claude sobre cómo identificar y transcribir la información musical relevante.
- **Pruebas iniciales**: Realizar pruebas con algunos documentos para refinar el prompt antes del procesamiento masivo.

### 3. Componentes del Sistema
El sistema consta de cuatro scripts principales que trabajan en conjunto:
1. **script.sh**: Script principal que itera sobre todos los archivos PDF en el directorio actual y lanza el proceso de solicitud de transcripción para cada uno.
2. **musica.py**: Script de Python que se encarga de codificar un archivo PDF en base64 y enviarlo como solicitud de procesamiento por lotes (batch) a la API de Claude, con instrucciones específicas para la transcripción de noticias musicales en documentos históricos.
3. **descargarbatches.sh**: Script que procesa los archivos de órdenes de lotes generados, extrae los identificadores de los lotes y ejecuta el script de recuperación para obtener los resultados.
4. **recuperar_batch.py**: Script que utiliza los identificadores de lotes para solicitar y mostrar los resultados del procesamiento a la API de Claude.

### 4. Procesamiento técnico
1. **Configuración del entorno**:
   - Crear un entorno virtual de Python para gestionar las dependencias
   - Instalar las bibliotecas necesarias, especialmente la API de Anthropic

2. **Lanzamiento de batches**:
   - Ejecutar `script.sh` para iniciar el procesamiento de los PDFs
   - Este proceso puede tomar tiempo dependiendo del volumen de documentos
   - Importante: No intentar descargar los resultados inmediatamente después del lanzamiento

3. **Descarga de resultados**:
   - Una vez que los batches hayan sido procesados, ejecutar `descargarbatches.sh`
   - El script recuperará los resultados de todos los lotes procesados
   - Los resultados se guardarán en archivos con formato `[nombre_archivo]_batch_output.txt`

4. **Limpieza de resultados**:
   - Aplicar script de limpieza para eliminar elementos no deseados en los resultados
   - Convertir los datos a un formato JSON legible y estructurado

### 5. Limpieza manual
- Revisar los archivos JSON generados para detectar errores de formato
- Corregir problemas comunes como comillas simples faltantes o mal escapadas
- Verificar la integridad estructural del JSON, que es especialmente sensible a errores de sintaxis
- Validar que no haya datos truncados o mal formateados

### 6. Unificación de resultados
- Combinar todos los archivos JSON individuales en una estructura unificada
- Organizar los datos siguiendo un esquema coherente y consistente
- Asegurar que la estructura final sea limpia y fácilmente navegable

### 7. Despliegue y visualización
- Desarrollar una página web alojada en GitHub para visualizar los resultados
- Implementar funcionalidades de búsqueda y filtrado para facilitar la consulta
- Asegurar que la interfaz sea accesible para investigadores de humanidades digitales
- Incluir todos los ejemplares con su información completa para una lectura cómoda
- Proporcionar documentación sobre la metodología utilizada

## Requisitos
- Python 3.x
- Biblioteca Anthropic para Python (para acceso a la API de Claude)
- Bash (para ejecutar los scripts shell)
- Credenciales válidas para la API de Claude
- Archivos PDF a procesar
- Herramientas de scraping legítimas como DownloadThemAll

## Consideraciones
El sistema está configurado específicamente para identificar y transcribir noticias musicales en documentos históricos, incluyendo:
- Óperas, conciertos y representaciones musicales
- Documentos sobre establecimientos de ópera
- Listas de actores de compañías teatrales y cómicas
- Poesías y textos que pudieran ser cantados
- Innovaciones relacionadas con instrumentos musicales
- Cualquier mención a música, representaciones, tonadas o tonadillas
- Información sobre asistencia a espectáculos musicales

La salida final del sistema es un conjunto de datos estructurados en formato JSON, visualizables a través de una interfaz web, que facilita la investigación en humanidades digitales relacionada con la historia musical y literaria.
