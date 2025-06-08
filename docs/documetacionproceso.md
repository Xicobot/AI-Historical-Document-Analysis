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

### 1.2 Normalizacion y organizacion de PDF's
Una vez descargados todos, requerimos de un poquito de organización para hacerlo mas sistematico, primero en la descarga, se tenía en cuenta en el proyecto un drive compartido, en el que se iba actualizando el proceso, y mientras se descargaban en una carpeta en concreto, al final de cada descarga masiva, primero se contaban las paginas por pdf para cuantificar el numero de paginas en total y así poder hacer una estimacíon de costes, y despues se organizaban por años a traves de esté [script](/sw/organizadoraños.sh).

### 1.3 Estimacíon de costes
Antes de procesar nada, se debería de hacer una estimacíon de costes, la cual es X*0.05 (Siendo X el numero de paginas totales de todos los PDF's), dejo un script el cual es capaz de calcular el numero total de paginas de un volumen grande de ejemplares, el [script](/sw/contar.sh) que deja como resultado [total_paginas.txt](/sw/total_paginas.txt).

---

## 2 Procesamiento a traves de IA
### 2.1 Setup del entorno de python y API.

1. Primero, creamos el entorno de python:
`python -m venv claude`
2. Accedemos a el:
`source claude/bin/activate`
3. Desactivamos el entorno: 
`deactivate`
Nos sacaría del entorno virtual.
![image](https://github.com/user-attachments/assets/f505dfdf-a110-443d-b207-637d193872d9)
![image](https://github.com/user-attachments/assets/6b0a6fe1-ad4a-42ba-b3bf-e14c3eeb18ca)

- Ahora, instalamos las dependencias de anthropic.
`pip install anthropic`
![image](https://github.com/user-attachments/assets/5c03760a-a0be-4a91-aec5-95d3c3f7fdc4)

- Para revisar que todo se ha instalado correctamente:
`pip list`

![image](https://github.com/user-attachments/assets/d72f672f-e2a1-44a1-9bcc-9a728ce39857)

- Una vez hecho, necesitaremos la clave de anthropic, la cual se consigue teniendo una cuenta de pago, y accediendo a tu consola de anthropic.
- https://console.anthropic.com
- Una vez tengamos la API, lo que haremos es importarla cada vez que entremos al entorno virtual, con el comando:
`export ANTHROPIC_API_KEY="TU API KEY AQUÍ"`

### 2.2 Prompt engineering

Es la parte del proyecto en la que se pone la mayor parte del tiempo investigando ya que se requiere de mucha investigacin, mucha prueba y error, ya que necesitamos ser precisos y concretos para que nos saque la mejor salida posible.

![image](https://github.com/user-attachments/assets/32c19218-fc00-4fbf-a29b-989c866b44ea)

Al final, el resultado de horas de investigacion en un prompt han resultado los siguientes:

## Prompt:
```prompt
Eres un asistente especializado en análisis documental. Tu tarea es analizar el contenido de un periódico histórico del siglo XIX y extraer ÚNICAMENTE noticias relacionadas con música en cualquiera de sus manifestaciones. INSTRUCCIONES: 1. Identifica TODAS las noticias que contengan referencias musicales, incluyendo: - Bailes (tambíen los populares como jota,aurresku, fandango, etc.) - Interpretaciones musicales (serenatas, conciertos) - Agrupaciones musicales (sextetos, orquestas, bandas, rondallas, estduiantinas, tunas, coros, orfeones) - Instrumentos musicales (piano, guitarra, etc.) - Compositores y músicos - Cantantes - Teatros y lugares de actuación musical - Romances, odas, tonadillas, zarzuela, charanga y poesía cantable -Música sacra -Crítica musical - Educación musical -Términos de solfeo, armonía, partitura, etc. - Teatro, representación o actuación ya sean realizadas, canceladas, suspendidas, aplazadas o "no hay". Cualquier mención que tenga relación con música. 1. Devuelve EXCLUSIVAMENTE un objeto JSON con la siguiente estructura: ```json { "noticias_musicales": [ { "id": 1, "texto_completo": "Texto íntegro de la noticia sin modificar ni acortar.", "pagina": "Número de página donde aparece" }, { "id": 2, "texto_completo": "...", "pagina": "Número de página donde aparece" } ], "total_noticias": 0, "fecha_periodico": "Fecha del periódico analizado" } IMPORTANTE: Devuelva solo el JSON solicitado, sin ningún comentario adicional. El json debe contener solo noticias musicales, extrae la fecha del propio nombre del pdf, y eliminando caracteres como "/n" o "\n" , comillas simples o dobles anidadas.
```

### 2.3 Lanzar batch
Para lanzar un batch, necesitamos tener una estructura organizada, primero, para que el [lanzarbatch.sh](/sw/lanzarbatch.sh) a ejecutar envie todos los pdfs del directorío, lo que hace que:
1. Envia cada pdf por la API, dejando un "nombre del archivo"batch_order.txt con un ID del mensaje que se recoge mas tarde.
2. Se lanza de manera masiva, el script repite en bucle el [musica.py](/sw/musica.py), que contiene el prompt, el modelo, y varíos aspectos mas de la inteligencia artificial.
3. Este proceso puede tardar dependiendo del volumen de archivos que tengamos.
4. el archivo restante que nos deja, es importante tenerlo en cuenta, ya que contiene el mensaje.

![image](https://github.com/user-attachments/assets/e693e08e-f971-4706-a11b-a94b0aa50c74)

### 2.4 Descargar batches
Una vez procesado, esto lo podemos mirar en la consola de anthropic, la cual nos muestra el batch con el msg_idxxxxx, se recupera con [descargarbatches.sh](/sw/descargarbatches.sh), que nos devuelve un output "Sucio" el que tendremos que limpiar primero con [limpieza.py](/sw/limpieza.py), en el que nos sacará, un formato json que guarda de manera fija los datos para despues enviarselos sin necesidad de tener una base de datos.

![image](https://github.com/user-attachments/assets/2865ab0f-a90d-40ac-aa75-bfacc2be7293)

### 2.5 Limpieza manual y obtencion del resultado limpio.
Ahora, lo que nos generará es un montón de resultados, tenemos dos opciones para lidiar con un volumen tan grande de datos.
1. Lo juntamos todo en un archivo, y revisamos que errores tiene.
2. Se revisan los errores uno por uno, viendo así que cosas podrían estár mal, casos en concreto, caracteres mal puestos, cosas del estilo.

(Yo lo que hago es juntarlo todo, y ya lo reviso todo, me ahorra tiempo de estár abriendo archivo por archivo.
![image](https://github.com/user-attachments/assets/fa29f664-2fa8-42e4-ae83-aa8eedef76a9)

### 3 Despliegue.
Para el despliegue, que es lo mas importante, queremos una pagina web que lea los formatos pdfs, que relacione la informacíon que haya en el json con los pdfs, y que normalice fechas por si mismo, así que nos quedaría una cosa así.

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
Y para que esto funcione, la estructura tiene que estár organizada, es decir, que en la misma carpeta tiene que estár el index, junto al json, y a los pdfs.


## Bibliografía:
Anthropic API: https://docs.anthropic.com/en/docs/get-started
Prompt engineering: https://github.com/anthropics/courses/blob/master/prompt_engineering_interactive_tutorial/Anthropic%201P/00_Tutorial_How-To.ipynb
