# Technical Documentation for Massive Processing of Historical PDFs from Digital Newspaper Archive

## FCT24-25 Project and Digital Humanities

This technical documentation describes the software and scripts used for massive processing of historical documents, as well as the scope and methodology of the Digital Newspaper Archive digitization project.

## 1. Massive Download Through Legitimate Scraping

Before starting processing, it is essential to have PDF files/archives locally, since current AIs cannot access large information corpora through web links. To optimize this process, we use legitimate scraping tools that automate massive downloads and save time.

### 1.1 Tools Used

#### HemerotecaBNE
- **Repository**: [HemerotecaBNE](https://github.com/Rafav/HemerotecaBNE)

**Installation and usage procedure:**
1. Download and install the plugin.
2. Access the [Digital Newspaper Archive](https://hemerotecadigital.bne.es/hd/es/results?parent=674a2e4f-97ed-463c-af7b-072ceb37a1b7&t=date-asc&s=520)
3. Select the number of pages to download
![image](https://github.com/user-attachments/assets/20858eda-9e26-4be2-a59c-87002d7330ba)
4. Activate the download button
![image](https://github.com/user-attachments/assets/2e54eeec-25aa-46e2-abb1-1969103895d6)

#### DownThemAll
- **Official site**: [DownThemAll 4.0](https://about.downthemall.org/4.0/)

This tool requires a previous list of direct links to PDFs, allowing simultaneous download of multiple files. It is important to implement ethical downloads to avoid overloading the platform servers.

### 1.2 PDF Normalization and Organization

Once downloads are completed, it is essential to implement a systematic organization system. The established workflow includes:

1. **Centralized storage**: Use of a shared drive to monitor project progress
2. **Content quantification**: Page counting per PDF to estimate processing costs
3. **Chronological organization**: Automatic classification by years through the [organization script](/sw/organizadoraños.sh)

### 1.3 Cost Estimation

It is crucial to perform an economic estimation before massive processing. The calculation formula is:

**Cost = Total number of pages × €0.05**

To automate this calculation, we have the [counting script](/sw/contar.sh), which generates the [total_paginas.txt](/sw/total_paginas.txt) file with the final result.

---

## 2. Processing Through Artificial Intelligence

### 2.1 Python Environment and API Setup

**Virtual environment creation:**
1. Create the environment:
   ```bash
   python -m venv claude
   ```

2. Activate the environment:
   ```bash
   source claude/bin/activate
   ```

3. Deactivate when necessary:
   ```bash
   deactivate
   ```

![image](https://github.com/user-attachments/assets/f505dfdf-a110-443d-b207-637d193872d9)
![image](https://github.com/user-attachments/assets/6b0a6fe1-ad4a-42ba-b3bf-e14c3eeb18ca)

**Dependencies installation:**
```bash
pip install anthropic
```
![image](https://github.com/user-attachments/assets/5c03760a-a0be-4a91-aec5-95d3c3f7fdc4)

**Installation verification:**
```bash
pip list
```
![image](https://github.com/user-attachments/assets/d72f672f-e2a1-44a1-9bcc-9a728ce39857)

**API Key configuration:**
- Obtain the key from the [Anthropic console](https://console.anthropic.com) (requires paid account)
- Configure environment variable:
  ```bash
  export ANTHROPIC_API_KEY="YOUR API KEY HERE"
  ```

### 2.2 Prompt Engineering

This phase constitutes the project's core, requiring exhaustive research and multiple trial-and-error iterations. The objective is to develop precise and specific prompts that optimize the quality of musical information extraction.

![image](https://github.com/user-attachments/assets/32c19218-fc00-4fbf-a29b-989c866b44ea)

After hours of research and refinement, the final developed prompt is:

## Optimized Prompt:
```prompt
You are an assistant specialized in document analysis. Your task is to analyze the content of a 19th-century historical newspaper and extract ONLY news related to music in any of its manifestations. INSTRUCTIONS: 1. Identify ALL news containing musical references, including: - Dances (also popular ones like jota, aurresku, fandango, etc.) - Musical performances (serenades, concerts) - Musical groups (sextets, orchestras, bands, rondallas, estudiantinas, tunas, choirs, orfeones) - Musical instruments (piano, guitar, etc.) - Composers and musicians - Singers - Theaters and musical performance venues - Romances, odes, tonadillas, zarzuela, charanga and singable poetry - Sacred music - Musical criticism - Musical education - Terms of solfege, harmony, score, etc. - Theater, representation or performance whether performed, canceled, suspended, postponed or "none". Any mention related to music. 1. Return EXCLUSIVELY a JSON object with the following structure: ```json { "noticias_musicales": [ { "id": 1, "texto_completo": "Complete text of the news without modifying or shortening.", "pagina": "Page number where it appears" }, { "id": 2, "texto_completo": "...", "pagina": "Page number where it appears" } ], "total_noticias": 0, "fecha_periodico": "Date of the analyzed newspaper" } IMPORTANT: Return only the requested JSON, without any additional comments. The json should contain only musical news, extract the date from the pdf filename itself, and removing characters like "/n" or "\n", nested single or double quotes.
```

### 2.3 Batch Processing Launch

For massive processing, it is necessary to maintain a specific organizational structure. The [lanzarbatch.sh](/sw/lanzarbatch.sh) script automates PDF submission through the following actions:

1. **Individual submission**: Each PDF is processed individually through the API
2. **Identifier registration**: A "filename_batch_order.txt" file is generated with the message ID for later retrieval
3. **Automatic processing**: The script iteratively executes [musica.py](/sw/musica.py), which contains the prompt, model configuration, and AI parameters
4. **Temporal scalability**: Processing time is proportional to file volume

![image](https://github.com/user-attachments/assets/e693e08e-f971-4706-a11b-a94b0aa50c74)

### 2.4 Results Download and Retrieval

Once processing is completed (verifiable from the Anthropic console via msg_idxxxxx), retrieval is performed with [descargarbatches.sh](/sw/descargarbatches.sh). This process generates an initial output that requires subsequent cleaning.

The cleaning phase uses [limpieza.py](/sw/limpieza.py) to:
- Normalize JSON format
- Structure data consistently
- Remove special characters and encoding errors
- Prepare data for implementation without database requirements

![image](https://github.com/user-attachments/assets/2865ab0f-a90d-40ac-aa75-bfacc2be7293)

### 2.5 Manual Cleaning and Final Result Obtention

For efficient handling of large data volumes, two strategies are proposed:

1. **Massive consolidation**: Unification of all results in a single file for global review
2. **Individual review**: File-by-file verification for specific cases and punctual error correction

**Recommendation**: Massive consolidation is more temporally efficient, allowing systematic review of error patterns and inconsistencies.

![image](https://github.com/user-attachments/assets/fa29f664-2fa8-42e4-ae83-aa8eedef76a9)

---

## 3. Deployment and Visualization

The deployment objective is to create a comprehensive web interface that allows:
- PDF file reading and visualization
- Automatic correlation between JSON information and PDF documents
- Automatic date normalization
- Intuitive navigation through the documentary corpus

### 3.1 Working Example

**Live demonstration**: As a curious fact and practical example of the implementation, a functional version of the system can be consulted at:

🔗 **[xicobot.github.io](https://xicobot.github.io)**

This implementation shows the complete system in operation with historical data from the Diario de Madrid from 1788, allowing users to directly experience:

- **Temporal navigation**: Specific date selection through intuitive interface
- **Synchronized PDF visualization**: Reading of original historical documents
- **Contextualized musical extraction**: Musical news identified and organized by date
- **Responsive interface**: Adaptation to different devices and screen sizes

**Observable characteristics in the example:**
- Historical design that evokes the original newspaper era
- Zoom functionality and PDF page navigation
- Text copying system to facilitate research
- Automatic metadata with page and date information

This implementation serves as a **proof of concept** and visual reference for future adaptations of the system to other historical documentary corpora or different temporal periods.

### 3.2 Local Web Implementation

The implemented solution uses HTML5, CSS3, and vanilla JavaScript to create a responsive and functional interface:

```html
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Diario de Madrid</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdf.js/3.4.120/pdf.min.js"></script>
    <style>
        /* General styles */
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

        /* Navigation */
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

        /* Main content - Reorganized layout */
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

        /* Date select */
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

        /* Copy button */
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
        <p class="subtitle">Digital Version of the Historical Collection</p>
        <p class="date" id="year-display">Year 1790</p>
    </header>

    <div class="navigation">
        <button class="nav-button" id="prev-entry">Previous</button>
        <select id="date-select" class="date-select">
            <option value="">Loading dates...</option>
        </select>
        <button class="nav-button" id="next-entry">Next</button>
    </div>

    <div class="main-content">
        <!-- Left section: Navigation and news content -->
        <div class="nav-section">
            <div class="content-navigation">
                <h3>Musical news</h3>
                <ul class="news-list" id="news-list">
                    <li><a href="#" data-index="0">Loading...</a></li>
                </ul>
                <div class="loader" id="sidebar-loader"></div>
            </div>
            
            <div class="news-content" id="news-content">
                <h2>Select a news item</h2>
                <p>Click on a news item from the panel above to view its content.</p>
            </div>
        </div>

        <!-- Right section: PDF visualization -->
        <div class="pdf-display">
            <div class="viewer-controls">
                <div class="page-controls">
                    <button id="prev-page">< Page</button>
                    <span id="page-counter">Page 1 of ?</span>
                    <button id="next-page">Page ></button>
                </div>
                <div class="zoom-controls">
                    <button id="zoom-out">-</button>
                    <button id="zoom-reset">100%</button>
                    <button id="zoom-in">+</button>
                </div>
            </div>
            
            <div class="page-info" id="page-info">Loading information...</div>
            
            <div id="pdf-container">
                <canvas id="pdf-canvas"></canvas>
                <div class="loader" id="pdf-loader"></div>
            </div>
        </div>
    </div>

    <script>
        // PDF.js configuration
        pdfjsLib.GlobalWorkerOptions.workerSrc = 'https://cdnjs.cloudflare.com/ajax/libs/pdf.js/3.4.120/pdf.worker.min.js';

        // Data variables
        let allData = null;
        let currentEntryIndex = 0;
        let currentNewsIndex = 0;
        
        // PDF variables
        let pdfDoc = null;
        let pageNum = 1;
        let pageRendering = false;
        let pageNumPending = null;
        let scale = 1.2;
        let canvas = document.getElementById('pdf-canvas');
        let ctx = canvas.getContext('2d');
        
        // DOM elements
        const pdfLoader = document.getElementById('pdf-loader');
        const sidebarLoader = document.getElementById('sidebar-loader');
        const pageCounter = document.getElementById('page-counter');
        const dateSelect = document.getElementById('date-select');
        const newsList = document.getElementById('news-list');
        const newsContent = document.getElementById('news-content');
        const pageInfo = document.getElementById('page-info');
        const yearDisplay = document.getElementById('year-display');

        // Function to normalize dates from PDF filename
        function normalizeDateFromPDF(pdfFilename) {
            if (!pdfFilename) return null;
            
            let match;
            let day, month, year;
            
            // Try DD-MM-YYYY.pdf format (e.g.: 02-01-1790.pdf)
            match = pdfFilename.match(/(\d{2})-(\d{2})-(\d{4})\.pdf/);
            if (match) {
                day = parseInt(match[1], 10);
                month = parseInt(match[2], 10);
                year = match[3];
            } else {
                // Try YYYY-MM-DD.pdf format (e.g.: 1790-01-02.pdf)
                match = pdfFilename.match(/(\d{4})-(\d{2})-(\d{2})\.pdf/);
                if (match) {
                    year = match[1];
                    month = parseInt(match[2], 10);
                    day = parseInt(match[3], 10);
                } else {
                    return null; // Could not recognize format
                }
            }
            
            // Month names in Spanish
            const monthNames = [
                "enero", "febrero", "marzo", "abril", "mayo", "junio",
                "julio", "agosto", "septiembre", "octubre", "noviembre", "diciembre"
            ];
            
            // Format as "DD de [month] de YYYY"
            return `${day} de ${monthNames[month - 1]} de ${year}`;
        }

        // Function to copy text to clipboard
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

        // NEW FUNCTION: Generate PDF path compatible with different formats
        function generatePdfPath(pdfFilename) {
            if (!pdfFilename) return null;
            
            // If it's DD-MM-YYYY format
            const ddmmyyyyMatch = pdfFilename.match(/(\d{2})-(\d{2})-(\d{4})\.pdf/);
            if (ddmmyyyyMatch) {
                const day = ddmmyyyyMatch[1];
                const month = ddmmyyyyMatch[2];
                const year = ddmmyyyyMatch[3];
                
                // Generate year-month-day format as alternative
                return `${year}-${month}-${day}.pdf`;
            }
            
            return pdfFilename;
        }

        // Load JSON data
        async function loadData() {
            try {
                sidebarLoader.style.display = 'block';
                
                const response = await fetch('combined.json');
                if (!response.ok) {
                    throw new Error(`Error loading data: ${response.status}`);
                }
                
                allData = await response.json();
                
                // Update year in interface
                if (allData && allData.Año) {
                    yearDisplay.textContent = `Year ${allData.Año}`;
                }
                
                // Load date list in selector
                populateDateSelect();
                
                // Load first entry
                if (allData && allData.ejemplares && allData.ejemplares.length > 0) {
                    loadEntry(0);
                }
                
                sidebarLoader.style.display = 'none';
                
            } catch (error) {
                console.error('Error loading data:', error);
                sidebarLoader.style.display = 'none';
                alert('Error loading data. Please try reloading the page.');
            }
        }

        // Fill date selector
        function populateDateSelect() {
            dateSelect.innerHTML = '';
            
            if (allData && allData.ejemplares && allData.ejemplares.length > 0) {
                allData.ejemplares.forEach((entry, index) => {
                    const option = document.createElement('option');
                    option.value = index;
                    
                    // Use normalized date if PDF exists
                    let displayDate = entry.fecha_periodico || "Unknown date";
                    
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

        // Load specific entry
        function loadEntry(index) {
            if (!allData || !allData.ejemplares || index < 0 || index >= allData.ejemplares.length) {
                return;
            }
            
            currentEntryIndex = index;
            dateSelect.value = index;
            
            const entry = allData.ejemplares[index];
            
            // Update year in interface
            if (allData && allData.Año) {
                yearDisplay.textContent = `Year ${allData.Año}`;
            }
            
            // Use formatted date if available
            let displayDate = entry.fecha_periodico || "Unknown date";
            if (entry.PDF) {
                const normalizedDate = normalizeDateFromPDF(entry.PDF);
                if (normalizedDate) {
                    displayDate = normalizedDate;
                }
            }
            
            pageInfo.textContent = `Showing: Diario de Madrid - ${displayDate}`;
            
            // Update news list
            updateNewsList(entry);
            
            // Load PDF
            if (entry.PDF) {
                loadPDF(entry.PDF);
            } else {
                document.getElementById('pdf-container').innerHTML = '<div class="error-message">No PDF available for this entry.</div>';
            }
            
            // If there are news, load the first one
            if (entry.noticias_musicales && entry.noticias_musicales.length > 0) {
                loadNews(0);
            } else {
                newsContent.innerHTML = '<h2>No news available</h2><p>No musical news found for this date.</p>';
            }
        }

        // Update news list
        function updateNewsList(entry) {
            newsList.innerHTML = '';
            
            if (entry.noticias_musicales && entry.noticias_musicales.length > 0) {
                entry.noticias_musicales.forEach((news, index) => {
                    const li = document.createElement('li');
                    const a = document.createElement('a');
                    a.href = '#';
                    
                    // Get first words of text to show as title
                    const words = news.texto_completo.split(' ');
                    const textSnippet = words.slice(0, 8).join(' ') + (words.length > 8 ? '...' : '');
                    a.textContent = `News ${index + 1}: ${textSnippet}`;
                    
                    a.setAttribute('data-index', index);
                    
                    if (index === 0) {
                        a.classList.add('active');
                    }
                    
                    a.addEventListener('click', function(e) {
                        e.preventDefault();
                        const newsIndex = parseInt(this.getAttribute('data-index'));
                        loadNews(newsIndex);
                        
                        // Update active links
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
                li.textContent = 'No musical news available';
                newsList.appendChild(li);
            }
        }

        // Load specific news
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
            
            // Ensure we have the complete text
            let fullText = news.texto_completo || '';
            
            // Update news content
            let htmlContent = '';
            
            htmlContent += `<h2>Musical news ${news.id}</h2>`;
            htmlContent += `<p style="white-space: pre-wrap;">${fullText}</p>`;
            
            // Add copy button
            htmlContent += `<button id="copy-button" class="copy-button">Copy text</button>`;
            htmlContent += `<span id="copy-notification" class="copy-notification">Text copied!</span>`;
            
            // Metadata
            htmlContent += `<div class="meta">`;
            
            // Use formatted date for metadata
            let displayDate = entry.fecha_periodico || "Unknown date";
            if (entry.PDF) {
                const normalizedDate = normalizeDateFromPDF(entry.PDF);
                if (normalizedDate) {
                    displayDate = normalizedDate;
                }
            }
            
            htmlContent += `<p>Date: ${displayDate}</p>`;
            
            if (news.pagina) {
                htmlContent += `<p>Page ${news.pagina} of the newspaper</p>`;
                
                // Go to corresponding page in PDF
                if (pdfDoc && !isNaN(parseInt(news.pagina))) {
                    queueRenderPage(parseInt(news.pagina));
                }
            }
            
            htmlContent += `</div>`;
            
            newsContent.innerHTML = htmlContent;
            
            // Add event to copy button
            document.getElementById('copy-button').addEventListener('click', function() {
                copyToClipboard(fullText);
            });
        }

        // Function to load a PDF
        function loadPDF(pdfFilename) {
            if (!pdfFilename) {
                document.getElementById('pdf-container').innerHTML = '<div class="error-message">No PDF available for this entry.</div>';
                return;
            }
            
            pdfLoader.style.display = 'block';
            
            // MODIFIED: Now searches in the same folder as index.html
            const alternativePdfFilename = generatePdfPath(pdfFilename);
            const pdfUrl = alternativePdfFilename; // Without 'pdfs/' prefix
            
            console.log("Trying to load PDF:", pdfUrl);
            
            // Load PDF document
            pdfjsLib.getDocument(pdfUrl).promise.then(function(pdf) {
                pdfDoc = pdf;
                pageCounter.textContent = `Page ${pageNum} of ${pdf.numPages}`;
                
                // Render first page
                renderPage(pageNum);
                pdfLoader.style.display = 'none';
            }).catch(function(error) {
                console.error('Error loading PDF:', error);
                
                // If fails with alternative format, try with original
                if (alternativePdfFilename !== pdfFilename) {
                    console.log("Trying with original format:", pdfFilename);
                    const originalPdfUrl = pdfFilename; // Without 'pdfs/' prefix
                    
                    pdfjsLib.getDocument(originalPdfUrl).promise.then(function(pdf) {
                        pdfDoc = pdf;
                        pageCounter.textContent = `Page ${pageNum} of ${pdf.numPages}`;
                        renderPage(pageNum);
                        pdfLoader.style.display = 'none';
                    }).catch(function(secondError) {
                        console.error('Error loading PDF with original format:', secondError);
                        pdfLoader.style.display = 'none';
                        
                        document.getElementById('pdf-container').innerHTML = `
                            <div class="error-message">
                                <p><strong>Error loading PDF:</strong> ${pdfFilename}</p>
                                <p>Also tried with: ${alternativePdfFilename}</p>
                                <p>Make sure that:</p>
                                <ul style="text-align: left; list-style-type: disc; padding-left: 30px;">
                                    <li>The file exists in the same folder as index.html</li>
                                    <li>The filename exactly matches what's specified in the JSON data</li>
                                    <li>The web server has permissions to access the PDF file</li>
                                </ul>
                            </div>`;
                    });
                } else {
                    pdfLoader.style.display = 'none';
                    document.getElementById('pdf-container').innerHTML = `
                        <div class="error-message">
                            <p><strong>Error loading PDF:</strong> ${pdfFilename}</p>
                            <p>Make sure that:</p>
                            <ul style="text-align: left; list-style-type: disc; padding-left: 30px;">
                                <li>The file exists in the same folder as index.html</li>
                                <li>The filename exactly matches what's specified in the JSON data</li>
                                <li>The web server has permissions to access the PDF file</li>
                            </ul>
                        </div>`;
                }
            });
        }

        // Render PDF page
        function renderPage(num) {
            pageRendering = true;
            
            // Get page
            pdfDoc.getPage(num).then(function(page) {
                const viewport = page.getViewport({ scale });
                canvas.height = viewport.height;
                canvas.width = viewport.width;
                
                // Render PDF on canvas
                const renderContext = {
                    canvasContext: ctx,
                    viewport: viewport
                };
                
                const renderTask = page.render(renderContext);
                
                // Wait until page has been rendered
                renderTask.promise.then(function() {
                    pageRendering = false;
                    
                    if (pageNumPending !== null) {
                        // Another page was requested while rendering
                        renderPage(pageNumPending);
                        pageNumPending = null;
                    }
                });
            });
            
            // Update page counter
            pageCounter.textContent = `Page ${num} of ${pdfDoc.numPages}`;
        }

        // Queue page rendering
        function queueRenderPage(num) {
            if (!pdfDoc) return;
            
            // Ensure page number is valid
            if (num < 1) num = 1;
            if (num > pdfDoc.numPages) num = pdfDoc.numPages;
            
            if (pageRendering) {
                pageNumPending = num;
            } else {
                renderPage(num);
            }
            pageNum = num;
        }

        // Go to previous page
        function onPrevPage() {
            if (pdfDoc === null || pageNum <= 1) {
                return;
            }
            pageNum--;
            queueRenderPage(pageNum);
        }

        // Go to next page
        function onNextPage() {
            if (pdfDoc === null || pageNum >= pdfDoc.numPages) {
                return;
            }
            pageNum++;
            queueRenderPage(pageNum);
        }

        // Go to previous entry
        function onPrevEntry() {
            if (currentEntryIndex > 0) {
                loadEntry(currentEntryIndex - 1);
            }
        }

        // Go to next entry
        function onNextEntry() {
            if (allData && allData.ejemplares && currentEntryIndex < allData.ejemplares.length - 1) {
                loadEntry(currentEntryIndex + 1);
            }
        }

        // Events for buttons and select
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

        // Zoom events
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

        // Initialize application
        loadData();
    </script>
</body>
</html>
```

### 3.3 Required File Structure

For proper system functioning, it is imperative to maintain the following organizational structure:

```
project/
├── index.html          # Main web interface
├── combined.json       # Processed and consolidated data
├── file1.pdf          # Original PDF documents
├── file2.pdf
└── ...
```

**Important note**: All files (HTML, JSON, and PDFs) must be located in the same directory to ensure proper resource access.

---

## Bibliography and References

- **Anthropic API**: [Official Documentation](https://docs.anthropic.com/en/docs/get-started)
- **Prompt Engineering**: [Anthropic Interactive Tutorial](https://github.com/anthropics/courses/blob/master/prompt_engineering_interactive_tutorial/Anthropic%201P/00_Tutorial_How-To.ipynb)

---

## Conclusions

This project demonstrates the viability of implementing an automated system for extraction and digitization of historical musical information. The combination of ethical scraping tools, AI processing, and web visualization offers a comprehensive solution for digital humanities research.

**Practical validation**: The functional implementation available at [xicobot.github.io](https://xicobot.github.io) constitutes empirical proof of the system's effectiveness, demonstrating its capacity to handle real historical documentary corpora and provide a satisfactory user experience for researchers and academics.

**Advantages of the implemented system:**
- Scalability for processing large documentary volumes
- Precision in specific thematic extraction
- Intuitive interface for researchers and end users
- Modular structure allowing future adaptations
- **Demonstrated functionality**: System validated with real historical data in production environment

**Important technical considerations:**
- Prompt quality is fundamental for result precision
- Processing cost must be calculated beforehand for adequate budgeting
- Structural file organization is critical for system functioning
- **Proven scalability**: The working example demonstrates technical viability for larger corpora

This workflow establishes a replicable precedent for similar projects in the field of digital humanities and historical documentary heritage preservation. The availability of a functional implementation facilitates adoption and adaptation of the system by other institutions or historical research projects.
