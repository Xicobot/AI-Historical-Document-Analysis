# Documentación Técnica del Procesamiento Masivo de PDFs Históricos de la Hemeroteca

## Proyecto FCT24-25 y Humanidades Digitales

Esta documentación técnica describe el software y scripts utilizados para el procesamiento masivo de documentos históricos, así como el alcance y metodología del proyecto de digitalización de la Hemeroteca.

## 1. Descarga Masiva Mediante Scraping Legítimo

Antes de iniciar el procesamiento, es fundamental disponer de los archivos PDF localmente, ya que las herramientas de IA actuales no pueden acceder directamente a grandes corpus de información a través de enlaces web. Para optimizar este proceso, utilizamos herramientas de scraping legítimo que automatizan la descarga masiva.

### 1.1 Herramientas Utilizadas

#### HemerotecaBNE
- **Repositorio**: [HemerotecaBNE](https://github.com/Rafav/HemerotecaBNE)

**Procedimiento de instalación y uso:**
1. Descargar e instalar el plugin.
2. Acceder a la [Hemeroteca Digital](https://hemerotecadigital.bne.es/hd/es/results?parent=674a2e4f-97ed-463c-af7b-072ceb37a1b7&t=date-asc&s=520)
3. Seleccionar el número de páginas a descargar
![image](https://github.com/user-attachments/assets/20858eda-9e26-4be2-a59c-87002d7330ba)
4. Activar el botón de descarga
![image](https://github.com/user-attachments/assets/2e54eeec-25aa-46e2-abb1-1969103895d6)

#### DownThemAll
- **Sitio oficial**: [DownThemAll 4.0](https://about.downthemall.org/4.0/)

Esta herramienta requiere una lista previa de enlaces directos a los PDFs, permitiendo la descarga simultánea de múltiples archivos. Es importante implementar descargas éticas para evitar sobrecargar los servidores de la plataforma.

### 1.2 Normalización y Organización de PDFs

Una vez completadas las descargas, es esencial implementar un sistema de organización sistemática. El flujo de trabajo establecido incluye:

1. **Almacenamiento centralizado**: Utilización de un drive compartido para monitorizar el progreso del proyecto
2. **Cuantificación de contenido**: Conteo de páginas por PDF para estimar costes de procesamiento
3. **Organización cronológica**: Clasificación automática por años mediante el [script de organización](/sw/organizadoraños.sh)

### 1.3 Estimación de Costes

Es crucial realizar una estimación económica antes del procesamiento masivo. La fórmula de cálculo es:

**Coste = Número total de páginas × 0.05€**

Para automatizar este cálculo, disponemos del [script de conteo](/sw/contar.sh), que genera el archivo [total_paginas.txt](/sw/total_paginas.txt) con el resultado final.

---

## 2. Procesamiento Mediante Inteligencia Artificial

### 2.1 Configuración del Entorno Python y API

**Creación del entorno virtual:**
1. Crear el entorno:
   ```bash
   python -m venv claude
   ```

2. Activar el entorno:
   ```bash
   source claude/bin/activate
   ```

3. Desactivar cuando sea necesario:
   ```bash
   deactivate
   ```

![image](https://github.com/user-attachments/assets/f505dfdf-a110-443d-b207-637d193872d9)
![image](https://github.com/user-attachments/assets/6b0a6fe1-ad4a-42ba-b3bf-e14c3eeb18ca)

**Instalación de dependencias:**
```bash
pip install anthropic
```
![image](https://github.com/user-attachments/assets/5c03760a-a0be-4a91-aec5-95d3c3f7fdc4)

**Verificación de la instalación:**
```bash
pip list
```
![image](https://github.com/user-attachments/assets/d72f672f-e2a1-44a1-9bcc-9a728ce39857)

**Configuración de la API Key:**
- Obtener la clave desde la [consola de Anthropic](https://console.anthropic.com) (requiere cuenta de pago)
- Configurar la variable de entorno:
  ```bash
  export ANTHROPIC_API_KEY="TU API KEY AQUÍ"
  ```

### 2.2 Ingeniería de Prompts

Esta fase constituye el núcleo del proyecto, requiriendo investigación exhaustiva y múltiples iteraciones de prueba y error. El objetivo es desarrollar prompts precisos y específicos que optimicen la calidad de la extracción de información musical.

![image](https://github.com/user-attachments/assets/32c19218-fc00-4fbf-a29b-989c866b44ea)

Tras horas de investigación, en las que tambíen se tienen como opciones de pruebas de otras api's de otras IA's, se ha llegado a la conclusión con que con claude sonnet 3.7 tiene el mejor OCR hasta ahora, y con refinamiento y horas de pulir el prompt el desarrollado es el siguiente:

## Prompt Optimizado:
```prompt
Eres un asistente especializado en análisis documental. Tu tarea es analizar el contenido de un periódico histórico del siglo XIX y extraer ÚNICAMENTE noticias relacionadas con música en cualquiera de sus manifestaciones. INSTRUCCIONES: 1. Identifica TODAS las noticias que contengan referencias musicales, incluyendo: - Bailes (tambíen los populares como jota,aurresku, fandango, etc.) - Interpretaciones musicales (serenatas, conciertos) - Agrupaciones musicales (sextetos, orquestas, bandas, rondallas, estduiantinas, tunas, coros, orfeones) - Instrumentos musicales (piano, guitarra, etc.) - Compositores y músicos - Cantantes - Teatros y lugares de actuación musical - Romances, odas, tonadillas, zarzuela, charanga y poesía cantable -Música sacra -Crítica musical - Educación musical -Términos de solfeo, armonía, partitura, etc. - Teatro, representación o actuación ya sean realizadas, canceladas, suspendidas, aplazadas o "no hay". Cualquier mención que tenga relación con música. 1. Devuelve EXCLUSIVAMENTE un objeto JSON con la siguiente estructura: ```json { "noticias_musicales": [ { "id": 1, "texto_completo": "Texto íntegro de la noticia sin modificar ni acortar.", "pagina": "Número de página donde aparece" }, { "id": 2, "texto_completo": "...", "pagina": "Número de página donde aparece" } ], "total_noticias": 0, "fecha_periodico": "Fecha del periódico analizado" } IMPORTANTE: Devuelva solo el JSON solicitado, sin ningún comentario adicional. El json debe contener solo noticias musicales, extrae la fecha del propio nombre del pdf, y eliminando caracteres como "/n" o "\n" , comillas simples o dobles anidadas.
```

### 2.3 Lanzamiento de Procesamiento Batch

Para el procesamiento masivo, es necesario mantener una estructura organizativa específica. El script [lanzarbatch.sh](/sw/lanzarbatch.sh) automatiza el envío de PDFs mediante las siguientes acciones:

1. **Envío individual**: Cada PDF se procesa individualmente a través de la API
2. **Registro de identificadores**: Se genera un archivo "nombre_del_archivo_batch_order.txt" con el ID del mensaje para posterior recuperación
3. **Procesamiento automático**: El script ejecuta iterativamente [musica.py](/sw/musica.py), que contiene el prompt, configuración del modelo y parámetros de la IA
4. **Escalabilidad temporal**: El tiempo de procesamiento es proporcional al volumen de archivos

![image](https://github.com/user-attachments/assets/e693e08e-f971-4706-a11b-a94b0aa50c74)

### 2.4 Descarga y Recuperación de Resultados

Una vez completado el procesamiento (verificable desde la consola de Anthropic mediante los msg_idxxxxx), la recuperación se realiza con [descargarbatches.sh](/sw/descargarbatches.sh). Este proceso genera una salida inicial que requiere limpieza posterior.

La fase de limpieza utiliza [limpieza.py](/sw/limpieza.py) para:
- Normalizar el formato JSON
- Estructurar los datos de manera consistente
- Eliminar caracteres especiales y errores de codificación
- Preparar los datos para su implementación sin necesidad de base de datos

![image](https://github.com/user-attachments/assets/2865ab0f-a90d-40ac-aa75-bfacc2be7293)

### 2.5 Limpieza Manual y Obtención del Resultado Final

Para el manejo eficiente de grandes volúmenes de datos, se proponen dos estrategias:

1. **Consolidación masiva**: Unificación de todos los resultados en un archivo único para revisión global con el script [combinar_json_add_ejemplares.sh](/sw/combinar_json_add_ejemplares.sh)
2. **Revisión individual**: Verificación archivo por archivo para casos específicos y corrección de errores puntuales

**Recomendación**: La consolidación masiva resulta más eficiente temporalmente, permitiendo una revisión sistemática de patrones de error y inconsistencias.

![image](https://github.com/user-attachments/assets/fa29f664-2fa8-42e4-ae83-aa8eedef76a9)

---

## 3. Despliegue y Visualización

El objetivo del despliegue es crear una interfaz web integral que permita:
- Lectura y visualización de archivos PDF
- Correlación automática entre información del JSON y documentos PDF
- Normalización automática de fechas
- Navegación intuitiva por el corpus documental

### 3.1 Ejemplo en Funcionamiento

**Demostración en vivo**: Como dato curioso y ejemplo práctico de la implementación, se puede consultar una versión funcional del sistema en:

🔗 **[xicobot.github.io](https://xicobot.github.io)**

Esta implementación muestra el sistema completo en funcionamiento con datos históricos del Diario de Madrid del año 1788, permitiendo a los usuarios experimentar directamente con:

- **Navegación temporal**: Selección de fechas específicas mediante interfaz intuitiva
- **Visualización PDF sincronizada**: Lectura de documentos históricos originales
- **Extracción musical contextualizada**: Noticias musicales identificadas y organizadas por fecha
- **Interfaz responsiva**: Adaptación a diferentes dispositivos y tamaños de pantalla

**Características observables en el ejemplo:**
- Diseño histórico que evoca la época del periódico original
- Funcionalidad de zoom y navegación por páginas del PDF
- Sistema de copiado de texto para facilitar la investigación
- Metadatos automáticos con información de página y fecha

Esta implementación sirve como **prueba de concepto** y referencia visual para futuras adaptaciones del sistema a otros corpus documentales históricos o diferentes períodos temporales.

### 3.2 Implementación Web Local

La solución implementada utiliza HTML5, CSS3 y JavaScript vanilla para crear una interfaz responsiva y funcional:

```html
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Diario de Madrid</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdf.js/3.4.120/pdf.min.js"></script>
    <style>
        /* Estilos generales */
        body {
            font-family: 'Georgia', serif;
            background-color: #f5f2e9;
            color: #333;
            max-width: 1600px;
            margin: 0 auto;
            padding: 20px;
            line-height: 1.6;
        }

        header {
            text-align: center;
            margin-bottom: 30px;
            border-bottom: 3px double #8b7d6b;
            padding-bottom: 20px;
            background-color: #eee6d8;
            padding: 20px;
            border-radius: 8px 8px 0 0;
        }

        h1 {
            font-size: 42px;
            margin-bottom: 10px;
            color: #5c4b3c;
            font-weight: bold;
            text-transform: uppercase;
            letter-spacing: 2px;
        }

        .subtitle {
            font-style: italic;
            font-size: 18px;
            margin-bottom: 15px;
            color: #8b7d6b;
        }

        .date {
            font-size: 16px;
            font-weight: bold;
        }

        /* Navegación */
        .navigation {
            display: flex;
            justify-content: center;
            margin: 20px 0;
            flex-wrap: wrap;
            background-color: #e8e0d0;
            padding: 10px;
            border-radius: 5px;
        }

        .nav-button {
            background-color: #d6c9b6;
            border: 1px solid #b3a38f;
            padding: 8px 16px;
            margin: 0 5px;
            cursor: pointer;
            font-family: Georgia, serif;
            font-size: 16px;
            color: #5c4b3c;
            transition: all 0.3s;
            border-radius: 4px;
        }

        .nav-button:hover {
            background-color: #c9b8a3;
        }

        .current-date {
            padding: 8px 16px;
            font-weight: bold;
            color: #5c4b3c;
        }

        /* Contenido principal - Layout reorganizado */
        .main-content {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
        }

        .nav-section {
            flex: 0 0 300px;
            order: 1;
        }

        .content-navigation {
            background-color: #f8f5ef;
            border: 1px solid #b3a38f;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }

        .content-navigation h3 {
            margin-top: 0;
            border-bottom: 1px solid #b3a38f;
            padding-bottom: 10px;
            color: #5c4b3c;
        }

        .news-list {
            list-style-type: none;
            padding: 0;
        }

        .news-list li {
            margin-bottom: 15px;
            border-bottom: 1px dotted #d6c9b6;
            padding-bottom: 10px;
        }

        .news-list a {
            color: #5c4b3c;
            text-decoration: none;
            display: block;
            padding: 5px;
            transition: all 0.3s;
            font-weight: bold;
        }

        .news-list a:hover {
            background-color: #e8e0d0;
        }

        .news-list p {
            margin: 5px 0 0 5px;
            font-size: 14px;
            color: #777;
        }

        .news-list a.active {
            background-color: #d6c9b6;
            font-weight: bold;
        }

        .news-content {
            background-color: #f8f5ef;
            border: 1px solid #b3a38f;
            padding: 20px;
            border-radius: 5px;
            margin-bottom: 20px;
            max-height: 800px;
            overflow-y: auto;
        }

        .news-content h2 {
            color: #5c4b3c;
            margin-top: 0;
            font-size: 24px;
            margin-bottom: 15px;
            border-bottom: 1px solid #d6c9b6;
            padding-bottom: 10px;
        }

        .news-content p {
            margin-bottom: 15px;
            line-height: 1.7;
            white-space: pre-wrap;
            text-align: justify;
        }

        .news-content .meta {
            font-style: italic;
            color: #8b7d6b;
            margin-top: 20px;
            font-size: 14px;
        }

        .pdf-display {
            flex: 1;
            min-width: 750px;
            order: 2;
        }

        #pdf-container {
            width: 100%;
            height: 1000px;
            border: 1px solid #b3a38f;
            background-color: #fff;
            overflow: auto;
            margin-bottom: 20px;
            border-radius: 5px;
        }

        #pdf-canvas {
            display: block;
            margin: 0 auto;
        }

        .viewer-controls {
            background-color: #e8e0d0;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
        }

        .zoom-controls, .page-controls {
            display: flex;
            align-items: center;
        }

        .viewer-controls button {
            background-color: #d6c9b6;
            border: 1px solid #b3a38f;
            padding: 5px 10px;
            margin: 0 5px;
            cursor: pointer;
            font-family: Georgia, serif;
            font-size: 14px;
            color: #5c4b3c;
            border-radius: 4px;
        }

        .viewer-controls button:hover {
            background-color: #c9b8a3;
        }

        .viewer-controls span {
            margin: 0 10px;
            color: #5c4b3c;
            font-weight: bold;
        }

        .page-info {
            font-style: italic;
            margin: 0 0 15px 0;
            color: #8b7d6b;
            text-align: center;
        }

        /* Loader */
        .loader {
            border: 5px solid #f3f3f3;
            border-top: 5px solid #8b7d6b;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            animation: spin 2s linear infinite;
            margin: 20px auto;
            display: none;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        /* Select para fechas */
        .date-select {
            width: 100%;
            padding: 10px;
            margin-bottom: 20px;
            border: 1px solid #b3a38f;
            border-radius: 4px;
            background-color: #f8f5ef;
            color: #5c4b3c;
            font-family: Georgia, serif;
        }

        /* Botón de copiar */
        .copy-button {
            background-color: #d6c9b6;
            border: 1px solid #b3a38f;
            padding: 5px 10px;
            margin-top: 10px;
            cursor: pointer;
            font-family: Georgia, serif;
            font-size: 14px;
            color: #5c4b3c;
            border-radius: 4px;
            display: inline-flex;
            align-items: center;
            transition: all 0.3s;
        }

        .copy-button:hover {
            background-color: #c9b8a3;
        }
        
        .copy-button:before {
            content: "📋";
            margin-right: 5px;
        }
        
        .copy-notification {
            display: none;
            margin-left: 10px;
            color: #4a7c59;
            font-style: italic;
            font-size: 14px;
        }

        /* Error message */
        .error-message {
            padding: 15px;
            background-color: #fff3f3;
            border: 1px solid #ffcaca;
            border-radius: 5px;
            color: #d85050;
            margin: 20px 0;
            text-align: center;
        }

        /* Responsive */
        @media (max-width: 1200px) {
            .main-content {
                flex-wrap: wrap;
            }
            
            .nav-section {
                flex: 1 0 100%;
                order: 1;
            }
            
            .pdf-display {
                flex: 1 0 100%;
                order: 2;
            }
        }

        @media (max-width: 768px) {
            #pdf-container {
                height: 500px;
            }
            
            .viewer-controls {
                flex-direction: column;
                gap: 10px;
            }
            
            .zoom-controls, .page-controls {
                width: 100%;
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <header>
        <h1>DIARIO DE MADRID</h1>
        <p class="subtitle">Versión Digital de la Colección Histórica</p>
        <p class="date" id="year-display">Año 1790</p>
    </header>

    <div class="navigation">
        <button class="nav-button" id="prev-entry">Anterior</button>
        <select id="date-select" class="date-select">
            <option value="">Cargando fechas...</option>
        </select>
        <button class="nav-button" id="next-entry">Siguiente</button>
    </div>

    <div class="main-content">
        <!-- Sección izquierda: Navegación y contenido de las noticias -->
        <div class="nav-section">
            <div class="content-navigation">
                <h3>Noticias musicales</h3>
                <ul class="news-list" id="news-list">
                    <li><a href="#" data-index="0">Cargando...</a></li>
                </ul>
                <div class="loader" id="sidebar-loader"></div>
            </div>
            
            <div class="news-content" id="news-content">
                <h2>Seleccione una noticia</h2>
                <p>Haga clic en una noticia del panel superior para ver su contenido.</p>
            </div>
        </div>

        <!-- Sección derecha: Visualización del PDF -->
        <div class="pdf-display">
            <div class="viewer-controls">
                <div class="page-controls">
                    <button id="prev-page">< Página</button>
                    <span id="page-counter">Página 1 de ?</span>
                    <button id="next-page">Página ></button>
                </div>
                <div class="zoom-controls">
                    <button id="zoom-out">-</button>
                    <button id="zoom-reset">100%</button>
                    <button id="zoom-in">+</button>
                </div>
            </div>
            
            <div class="page-info" id="page-info">Cargando información...</div>
            
            <div id="pdf-container">
                <canvas id="pdf-canvas"></canvas>
                <div class="loader" id="pdf-loader"></div>
            </div>
        </div>
    </div>

    <script>
        // Configuración PDF.js
        pdfjsLib.GlobalWorkerOptions.workerSrc = 'https://cdnjs.cloudflare.com/ajax/libs/pdf.js/3.4.120/pdf.worker.min.js';

        // Variables para datos
        let allData = null;
        let currentEntryIndex = 0;
        let currentNewsIndex = 0;
        
        // Variables para PDF
        let pdfDoc = null;
        let pageNum = 1;
        let pageRendering = false;
        let pageNumPending = null;
        let scale = 1.2;
        let canvas = document.getElementById('pdf-canvas');
        let ctx = canvas.getContext('2d');
        
        // Elementos DOM
        const pdfLoader = document.getElementById('pdf-loader');
        const sidebarLoader = document.getElementById('sidebar-loader');
        const pageCounter = document.getElementById('page-counter');
        const dateSelect = document.getElementById('date-select');
        const newsList = document.getElementById('news-list');
        const newsContent = document.getElementById('news-content');
        const pageInfo = document.getElementById('page-info');
        const yearDisplay = document.getElementById('year-display');

        // Función para normalizar fechas desde el nombre del PDF
        function normalizeDateFromPDF(pdfFilename) {
            if (!pdfFilename) return null;
            
            let match;
            let day, month, year;
            
            // Intenta el formato DD-MM-YYYY.pdf (ej: 02-01-1790.pdf)
            match = pdfFilename.match(/(\d{2})-(\d{2})-(\d{4})\.pdf/);
            if (match) {
                day = parseInt(match[1], 10);
                month = parseInt(match[2], 10);
                year = match[3];
            } else {
                // Intenta el formato YYYY-MM-DD.pdf (ej: 1790-01-02.pdf)
                match = pdfFilename.match(/(\d{4})-(\d{2})-(\d{2})\.pdf/);
                if (match) {
                    year = match[1];
                    month = parseInt(match[2], 10);
                    day = parseInt(match[3], 10);
                } else {
                    return null; // No pudo reconocer el formato
                }
            }
            
            // Nombres de los meses en español
            const monthNames = [
                "enero", "febrero", "marzo", "abril", "mayo", "junio",
                "julio", "agosto", "septiembre", "octubre", "noviembre", "diciembre"
            ];
            
            // Formatear como "DD de [mes] de YYYY"
            return `${day} de ${monthNames[month - 1]} de ${year}`;
        }

        // Función para copiar texto al portapapeles
        function copyToClipboard(text) {
            const tempElement = document.createElement('textarea');
            tempElement.value = text;
            tempElement.setAttribute('readonly', '');
            tempElement.style.position = 'absolute';
            tempElement.style.left = '-9999px';
            document.body.appendChild(tempElement);
            
            tempElement.select();
            document.execCommand('copy');
            
            document.body.removeChild(tempElement);
            
            const notification = document.getElementById('copy-notification');
            notification.style.display = 'inline';
            
            setTimeout(() => {
                notification.style.display = 'none';
            }, 2000);
        }

        // NUEVA FUNCIÓN: Generar una ruta a PDF compatible con diferentes formatos
        function generatePdfPath(pdfFilename) {
            if (!pdfFilename) return null;
            
            // Si es un formato de fecha DD-MM-YYYY
            const ddmmyyyyMatch = pdfFilename.match(/(\d{2})-(\d{2})-(\d{4})\.pdf/);
            if (ddmmyyyyMatch) {
                const day = ddmmyyyyMatch[1];
                const month = ddmmyyyyMatch[2];
                const year = ddmmyyyyMatch[3];
                
                // Generar formato año-mes-día como alternativa
                return `${year}-${month}-${day}.pdf`;
            }
            
            return pdfFilename;
        }

        // Cargar datos del JSON
        async function loadData() {
            try {
                sidebarLoader.style.display = 'block';
                
                const response = await fetch('combined.json');
                if (!response.ok) {
                    throw new Error(`Error al cargar datos: ${response.status}`);
                }
                
                allData = await response.json();
                
                // Actualizar el año en la interfaz
                if (allData && allData.Año) {
                    yearDisplay.textContent = `Año ${allData.Año}`;
                }
                
                // Cargar lista de fechas en el selector
                populateDateSelect();
                
                // Cargar la primera entrada
                if (allData && allData.ejemplares && allData.ejemplares.length > 0) {
                    loadEntry(0);
                }
                
                sidebarLoader.style.display = 'none';
                
            } catch (error) {
                console.error('Error cargando datos:', error);
                sidebarLoader.style.display = 'none';
                alert('Error al cargar los datos. Por favor, intenta recargar la página.');
            }
        }

        // Llenar el selector de fechas
        function populateDateSelect() {
            dateSelect.innerHTML = '';
            
            if (allData && allData.ejemplares && allData.ejemplares.length > 0) {
                allData.ejemplares.forEach((entry, index) => {
                    const option = document.createElement('option');
                    option.value = index;
                    
                    // Usar la fecha normalizada si existe un PDF
                    let displayDate = entry.fecha_periodico || "Fecha desconocida";
                    
                    if (entry.PDF) {
                        const normalizedDate = normalizeDateFromPDF(entry.PDF);
                        if (normalizedDate) {
                            displayDate = normalizedDate;
                        }
                    }
                    
                    option.textContent = displayDate;
                    dateSelect.appendChild(option);
                });
            }
        }

        // Cargar una entrada específica
        function loadEntry(index) {
            if (!allData || !allData.ejemplares || index < 0 || index >= allData.ejemplares.length) {
                return;
            }
            
            currentEntryIndex = index;
            dateSelect.value = index;
            
            const entry = allData.ejemplares[index];
            
            // Actualizar año en la interfaz
            if (allData && allData.Año) {
                yearDisplay.textContent = `Año ${allData.Año}`;
            }
            
            // Usar fecha formateada si está disponible
            let displayDate = entry.fecha_periodico || "Fecha desconocida";
            if (entry.PDF) {
                const normalizedDate = normalizeDateFromPDF(entry.PDF);
                if (normalizedDate) {
                    displayDate = normalizedDate;
                }
            }
            
            pageInfo.textContent = `Mostrando: Diario de Madrid - ${displayDate}`;
            
            // Actualizar lista de noticias
            updateNewsList(entry);
            
            // Cargar el PDF
            if (entry.PDF) {
                loadPDF(entry.PDF);
            } else {
                document.getElementById('pdf-container').innerHTML = '<div class="error-message">No hay PDF disponible para esta entrada.</div>';
            }
            
            // Si hay noticias, cargar la primera
            if (entry.noticias_musicales && entry.noticias_musicales.length > 0) {
                loadNews(0);
            } else {
                newsContent.innerHTML = '<h2>No hay noticias disponibles</h2><p>No se encontraron noticias musicales para esta fecha.</p>';
            }
        }

        // Actualizar lista de noticias
        function updateNewsList(entry) {
            newsList.innerHTML = '';
            
            if (entry.noticias_musicales && entry.noticias_musicales.length > 0) {
                entry.noticias_musicales.forEach((news, index) => {
                    const li = document.createElement('li');
                    const a = document.createElement('a');
                    a.href = '#';
                    
                    // Obtener primeras palabras del texto para mostrar como título
                    const words = news.texto_completo.split(' ');
                    const textSnippet = words.slice(0, 8).join(' ') + (words.length > 8 ? '...' : '');
                    a.textContent = `Noticia ${index + 1}: ${textSnippet}`;
                    
                    a.setAttribute('data-index', index);
                    
                    if (index === 0) {
                        a.classList.add('active');
                    }
                    
                    a.addEventListener('click', function(e) {
                        e.preventDefault();
                        const newsIndex = parseInt(this.getAttribute('data-index'));
                        loadNews(newsIndex);
                        
                        // Actualizar enlaces activos
                        document.querySelectorAll('.news-list a').forEach(link => {
                            link.classList.remove('active');
                        });
                        this.classList.add('active');
                    });
                    
                    li.appendChild(a);
                    newsList.appendChild(li);
                });
            } else {
                const li = document.createElement('li');
                li.textContent = 'No hay noticias musicales disponibles';
                newsList.appendChild(li);
            }
        }

        // Cargar noticia específica
        function loadNews(index) {
            if (!allData || !allData.ejemplares || currentEntryIndex < 0 || currentEntryIndex >= allData.ejemplares.length) {
                return;
            }
            
            const entry = allData.ejemplares[currentEntryIndex];
            
            if (!entry.noticias_musicales || index < 0 || index >= entry.noticias_musicales.length) {
                return;
            }
            
            currentNewsIndex = index;
            const news = entry.noticias_musicales[index];
            
            // Asegurarse de que tenemos el texto completo
            let fullText = news.texto_completo || '';
            
            // Actualizar contenido de la noticia
            let htmlContent = '';
            
            htmlContent += `<h2>Noticia musical ${news.id}</h2>`;
            htmlContent += `<p style="white-space: pre-wrap;">${fullText}</p>`;
            
            // Añadir botón de copiar
            htmlContent += `<button id="copy-button" class="copy-button">Copiar texto</button>`;
            htmlContent += `<span id="copy-notification" class="copy-notification">¡Texto copiado!</span>`;
            
            // Metadatos
            htmlContent += `<div class="meta">`;
            
            // Usar fecha formateada para los metadatos
            let displayDate = entry.fecha_periodico || "Fecha desconocida";
            if (entry.PDF) {
                const normalizedDate = normalizeDateFromPDF(entry.PDF);
                if (normalizedDate) {
                    displayDate = normalizedDate;
                }
            }
            
            htmlContent += `<p>Fecha: ${displayDate}</p>`;
            
            if (news.pagina) {
                htmlContent += `<p>Página ${news.pagina} del periódico</p>`;
                
                // Ir a la página correspondiente en el PDF
                if (pdfDoc && !isNaN(parseInt(news.pagina))) {
                    queueRenderPage(parseInt(news.pagina));
                }
            }
            
            htmlContent += `</div>`;
            
            newsContent.innerHTML = htmlContent;
            
            // Añadir evento al botón de copiar
            document.getElementById('copy-button').addEventListener('click', function() {
                copyToClipboard(fullText);
            });
        }

        // Función para cargar un PDF
        function loadPDF(pdfFilename) {
            if (!pdfFilename) {
                document.getElementById('pdf-container').innerHTML = '<div class="error-message">No hay PDF disponible para esta entrada.</div>';
                return;
            }
            
            pdfLoader.style.display = 'block';
            
            // MODIFICADO: Ahora busca en la misma carpeta del index.html
            const alternativePdfFilename = generatePdfPath(pdfFilename);
            const pdfUrl = alternativePdfFilename; // Sin prefijo 'pdfs/'
            
            console.log("Intentando cargar PDF:", pdfUrl);
            
            // Cargar documento PDF
            pdfjsLib.getDocument(pdfUrl).promise.then(function(pdf) {
                pdfDoc = pdf;
                pageCounter.textContent = `Página ${pageNum} de ${pdf.numPages}`;
                
                // Renderizar primera página
                renderPage(pageNum);
                pdfLoader.style.display = 'none';
            }).catch(function(error) {
                console.error('Error al cargar el PDF:', error);
                
                // Si falla con el formato alternativo, intentar con el original
                if (alternativePdfFilename !== pdfFilename) {
                    console.log("Intentando con formato original:", pdfFilename);
                    const originalPdfUrl = pdfFilename; // Sin prefijo 'pdfs/'
                    
                    pdfjsLib.getDocument(originalPdfUrl).promise.then(function(pdf) {
                        pdfDoc = pdf;
                        pageCounter.textContent = `Página ${pageNum} de ${pdf.numPages}`;
                        renderPage(pageNum);
                        pdfLoader.style.display = 'none';
                    }).catch(function(secondError) {
                        console.error('Error al cargar el PDF con formato original:', secondError);
                        pdfLoader.style.display = 'none';
                        
                        document.getElementById('pdf-container').innerHTML = `
                            <div class="error-message">
                                <p><strong>Error al cargar el PDF:</strong> ${pdfFilename}</p>
                                <p>También se intentó con: ${alternativePdfFilename}</p>
                                <p>Asegúrate de que:</p>
                                <ul style="text-align: left; list-style-type: disc; padding-left: 30px;">
                                    <li>El archivo existe en la misma carpeta que el index.html</li>
                                    <li>El nombre del archivo coincide exactamente con el especificado en los datos JSON</li>
                                    <li>El servidor web tiene permisos para acceder al archivo PDF</li>
                                </ul>
                            </div>`;
                    });
                } else {
                    pdfLoader.style.display = 'none';
                    document.getElementById('pdf-container').innerHTML = `
                        <div class="error-message">
                            <p><strong>Error al cargar el PDF:</strong> ${pdfFilename}</p>
                            <p>Asegúrate de que:</p>
                            <ul style="text-align: left; list-style-type: disc; padding-left: 30px;">
                                <li>El archivo existe en la misma carpeta que el index.html</li>
                                <li>El nombre del archivo coincide exactamente con el especificado en los datos JSON</li>
                                <li>El servidor web tiene permisos para acceder al archivo PDF</li>
                            </ul>
                        </div>`;
                }
            });
        }

        // Renderizar página del PDF
        function renderPage(num) {
            pageRendering = true;
            
            // Obtener página
            pdfDoc.getPage(num).then(function(page) {
                const viewport = page.getViewport({ scale });
                canvas.height = viewport.height;
                canvas.width = viewport.width;
                
                // Renderizar PDF en el canvas
                const renderContext = {
                    canvasContext: ctx,
                    viewport: viewport
                };
                
                const renderTask = page.render(renderContext);
                
                // Esperar hasta que la página se haya renderizado
                renderTask.promise.then(function() {
                    pageRendering = false;
                    
                    if (pageNumPending !== null) {
                        // Se solicitó renderizar otra página mientras se estaba renderizando
                        renderPage(pageNumPending);
                        pageNumPending = null;
                    }
                });
            });
            
            // Actualizar contador de página
            pageCounter.textContent = `Página ${num} de ${pdfDoc.numPages}`;
        }

        // Poner en cola la renderización de una página
        function queueRenderPage(num) {
            if (!pdfDoc) return;
            
            // Asegurarse de que el número de página es válido
            if (num < 1) num = 1;
            if (num > pdfDoc.numPages) num = pdfDoc.numPages;
            
            if (pageRendering) {
                pageNumPending = num;
            } else {
                renderPage(num);
            }
            pageNum = num;
        }

        // Ir a la página anterior
        function onPrevPage() {
            if (pdfDoc === null || pageNum <= 1) {
                return;
            }
            pageNum--;
            queueRenderPage(pageNum);
        }

        // Ir a la página siguiente
        function onNextPage() {
            if (pdfDoc === null || pageNum >= pdfDoc.numPages) {
                return;
            }
            pageNum++;
            queueRenderPage(pageNum);
        }

        // Ir a la entrada anterior
        function onPrevEntry() {
            if (currentEntryIndex > 0) {
                loadEntry(currentEntryIndex - 1);
            }
        }

        // Ir a la entrada siguiente
        function onNextEntry() {
            if (allData && allData.ejemplares && currentEntryIndex < allData.ejemplares.length - 1) {
                loadEntry(currentEntryIndex + 1);
            }
        }

        // Eventos para botones y select
        document.getElementById('prev-page').addEventListener('click', onPrevPage);
        document.getElementById('next-page').addEventListener('click', onNextPage);
        document.getElementById('prev-entry').addEventListener('click', onPrevEntry);
        document.getElementById('next-entry').addEventListener('click', onNextEntry);
        
        dateSelect.addEventListener('change', function() {
            const index = parseInt(this.value);
            if (!isNaN(index)) {
                loadEntry(index);
            }
        });

        // Eventos para zoom
        document.getElementById('zoom-in').addEventListener('click', function() {
            scale += 0.2;
            queueRenderPage(pageNum);
        });

        document.getElementById('zoom-out').addEventListener('click', function() {
            if (scale > 0.4) {
                scale -= 0.2;
                queueRenderPage(pageNum);
            }
        });

        document.getElementById('zoom-reset').addEventListener('click', function() {
            scale = 1.2;
            queueRenderPage(pageNum);
        });

        // Inicializar la aplicación
        loadData();
    </script>
</body>
</html>
```

### 3.3 Estructura de Archivos Requerida

Para el correcto funcionamiento del sistema, es imprescindible mantener la siguiente estructura organizativa:

```
proyecto/
├── index.html          # Interfaz web principal
├── combined.json       # Datos procesados y consolidados
├── archivo1.pdf        # Documentos PDF originales
├── archivo2.pdf
└── ...
```

**Nota importante**: Todos los archivos (HTML, JSON y PDFs) deben ubicarse en el mismo directorio para garantizar el acceso adecuado a los recursos.

### 3.4 Desplliegue

Simplemente para el despliegue, he usado [Mi pagina de github](https://xicobot.github.io) para hacer la demostracíon de un año, y luego para la entrega del resto de años, lo que he hecho ha sido meter todos los ejemplares a drive, con el combined.json y el index.html para que se lo descargen y un [abrirpagina.bat](/sw/abrirpagina.bat) y un [abrirpagina.sh](/sw/abrirpagina.sh) ejecutables para que se lancé solo y no haya problemas de compatibilidad con el navegador.

![image](https://github.com/user-attachments/assets/e724bdb5-f64b-4c37-a248-75070ffcb94d)


---

## Bibliografía y Referencias

- **API de Anthropic**: [Documentación oficial](https://docs.anthropic.com/en/docs/get-started)
- **Ingeniería de Prompts**: [Tutorial interactivo de Anthropic](https://github.com/anthropics/courses/blob/master/prompt_engineering_interactive_tutorial/Anthropic%201P/00_Tutorial_How-To.ipynb)

---

## Conclusiones

Este proyecto demuestra la viabilidad de implementar un sistema automatizado para la extracción y digitalización de información musical histórica. La combinación de herramientas de scraping ético, procesamiento mediante IA y visualización web ofrece una solución integral para la investigación en humanidades digitales.

**Validación práctica**: La implementación funcional disponible en [xicobot.github.io](https://xicobot.github.io) constituye una prueba empírica de la efectividad del sistema, demostrando su capacidad para manejar corpus documentales históricos reales y proporcionar una experiencia de usuario satisfactoria para investigadores y académicos.

**Ventajas del sistema implementado:**
- Escalabilidad para procesar grandes volúmenes documentales
- Precisión en la extracción temática específica
- Interfaz intuitiva para investigadores y usuarios finales
- Estructura modular que permite adaptaciones futuras
- **Funcionalidad demostrada**: Sistema validado con datos históricos reales en entorno de producción

**Consideraciones técnicas importantes:**
- La calidad del prompt es fundamental para la precisión de los resultados
- El coste de procesamiento debe calcularse previamente para presupuestar adecuadamente
- La organización estructural de archivos es crítica para el funcionamiento del sistema
- **Escalabilidad probada**: El ejemplo en funcionamiento demuestra la viabilidad técnica para corpus de mayor envergadura

Este flujo de trabajo establece un precedente replicable para proyectos similares en el ámbito de las humanidades digitales y la preservación del patrimonio documental histórico. La disponibilidad de una implementación funcional facilita la adopción y adaptación del sistema por parte de otras instituciones o proyectos de investigación histórica.
