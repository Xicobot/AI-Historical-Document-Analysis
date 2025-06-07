# Documentación tecnica del procesamiento masivo de PDF's historicos de la Hemeroteca para el proyecto de FCT24-25 y Humanidades digitales

Esta es la documentacion tecnica, donde encontraras el software y scripts utilizados, tanto para procesar, como para entender un poco el alcance del proyecto.

## 1. Descarga Masiva a traves de scrapping legitimo.

Se debe de tener claro que antes de empezar, necesitamos tener de manera local los PDF's/archivos a descargar, ya que actualmente las IA's no pueden acceder a un corpus de informacioón grande a traves de enlaces.
Para ello, usaremos herramientas de scrapping legitimo, el cual nos ahorrara tiempo.

### Herramientas utilizadas
- [HemerotecaBNE](https://github.com/Rafav/HemerotecaBNE)
1. Descargar el plugin.
2. Irse a la pagina de la [Hemeroteca digital](https://hemerotecadigital.bne.es/hd/es/results?parent=674a2e4f-97ed-463c-af7b-072ceb37a1b7&t=date-asc&s=520)
3. Escoger el numero de paginas a descargar
![image](https://github.com/user-attachments/assets/20858eda-9e26-4be2-a59c-87002d7330ba)
Darle al botón de descargar.
![image](https://github.com/user-attachments/assets/2e54eeec-25aa-46e2-abb1-1969103895d6)
- [DownThemAll](https://about.downthemall.org/4.0/)
Este requiere de todos los enlaces a los pdfs, lo cual nos permitiría descargarlos todos de golpe, evidentemente haciendolo de manera etica para no tener problemas de ningún tipo con
la pagina a hacer scrapping.

# 1.2 Normalizacion y organizacion de PDF's
Una vez descargados todos, requerimos de un poquito de organización para hacerlo mas sistematico, primero en la descarga, se tenía en cuenta en el proyecto un drive compartido, en el que se iba actualizando el proceso, y mientras se descargaban en una carpeta en concreto, al final de cada descarga masiva, se organizaban por años a traves de esté [script](/sw/organizadoraños.sh).



2. Desarrollo de prompts
Investigación y comprensión: Invertir tiempo en investigar y comprender el contexto histórico y los campos específicos que se desean extraer.
Diseño del prompt: Crear un prompt detallado con instrucciones claras para Claude sobre cómo identificar y transcribir la información musical relevante.
Pruebas iniciales: Realizar pruebas con algunos documentos para refinar el prompt antes del procesamiento masivo.
3. Componentes del Sistema
El sistema consta de cuatro scripts principales que trabajan en conjunto:

script.sh: Script principal que itera sobre todos los archivos PDF en el directorio actual y lanza el proceso de solicitud de transcripción para cada uno.
musica.py: Script de Python que se encarga de codificar un archivo PDF en base64 y enviarlo como solicitud de procesamiento por lotes (batch) a la API de Claude, con instrucciones específicas para la transcripción de noticias musicales en documentos históricos.
descargarbatches.sh: Script que procesa los archivos de órdenes de lotes generados, extrae los identificadores de los lotes y ejecuta el script de recuperación para obtener los resultados.
recuperar_batch.py: Script que utiliza los identificadores de lotes para solicitar y mostrar los resultados del procesamiento a la API de Claude.
4. Procesamiento técnico
Configuración del entorno:

Crear un entorno virtual de Python para gestionar las dependencias
Instalar las bibliotecas necesarias, especialmente la API de Anthropic
Lanzamiento de batches:

Ejecutar script.sh para iniciar el procesamiento de los PDFs
Este proceso puede tomar tiempo dependiendo del volumen de documentos
Importante: No intentar descargar los resultados inmediatamente después del lanzamiento
Descarga de resultados:

Una vez que los batches hayan sido procesados, ejecutar descargarbatches.sh
El script recuperará los resultados de todos los lotes procesados
Los resultados se guardarán en archivos con formato [nombre_archivo]_batch_output.txt
Limpieza de resultados:

Aplicar script de limpieza para eliminar elementos no deseados en los resultados
Convertir los datos a un formato JSON legible y estructurado
5. Limpieza manual
Revisar los archivos JSON generados para detectar errores de formato
Corregir problemas comunes como comillas simples faltantes o mal escapadas
Verificar la integridad estructural del JSON, que es especialmente sensible a errores de sintaxis
Validar que no haya datos truncados o mal formateados
6. Unificación de resultados
Combinar todos los archivos JSON individuales en una estructura unificada
Organizar los datos siguiendo un esquema coherente y consistente
Asegurar que la estructura final sea limpia y fácilmente navegable
7. Despliegue y visualización
Desarrollar una página web alojada en GitHub para visualizar los resultados
Implementar funcionalidades de búsqueda y filtrado para facilitar la consulta
Asegurar que la interfaz sea accesible para investigadores de humanidades digitales
Incluir todos los ejemplares con su información completa para una lectura cómoda
Proporcionar documentación sobre la metodología utilizada
Requisitos
Python 3.x
Biblioteca Anthropic para Python (para acceso a la API de Claude)
Bash (para ejecutar los scripts shell)
Credenciales válidas para la API de Claude
Archivos PDF a procesar
Herramientas de scraping legítimas como DownloadThemAll
Consideraciones
El sistema está configurado específicamente para identificar y transcribir noticias musicales en documentos históricos, incluyendo:

Óperas, conciertos y representaciones musicales
Documentos sobre establecimientos de ópera
Listas de actores de compañías teatrales y cómicas
Poesías y textos que pudieran ser cantados
Innovaciones relacionadas con instrumentos musicales
Cualquier mención a música, representaciones, tonadas o tonadillas
Información sobre asistencia a espectáculos musicales
