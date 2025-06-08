# AI-Historical-Document-Analysis

[![imagen1](https://github.com/user-attachments/assets/e3aa81e7-b50a-489f-9945-b0d3e177950a)](https://Xicobot.github.io)

# Project Documentation: Historical Document Analysis through Artificial Intelligence and OCR

## 1. Introduction and Academic Context

### 1.1 Project Description
This project is part of the **Digital Humanities** initiatives that integrate artificial intelligence tools for automated analysis of historical documents. The developed methodology enables systematic location, transcription, and analysis of musical content in large-volume documentary corpora.

### 1.2 Theoretical Framework
The project is framed within the **Digital Humanities** current, specifically in:
- **Distant Reading** (Franco Moretti): Quantitative analysis of literary texts
- **Cultural Analytics** (Lev Manovich): Application of computational methods to cultural analysis
- **Corpus Linguistics**: Study of linguistic patterns in large textual collections

### 1.3 Research Objectives

#### General Objective
Develop a reproducible methodology for automated identification of cultural and musical references in historical documents through artificial intelligence techniques.

#### Specific Objectives
1. Implement an OCR/HTR processing pipeline for historical documents
2. Create specialized prompts for cultural information extraction
3. Statistically validate the accuracy of obtained results
4. Generate visualization interfaces to facilitate humanistic research
5. Establish reproducibility protocols for future studies

## 2. Methodology

### 2.1 Study Corpus
- **Source**: [https://hemerotecadigital.bne.es/]
- **Temporal period**: [1788-1800]
- **Volume**: [13,478 issues/59,412 pages]
- **Selection criteria**: [Company/researcher needs]

### 2.2 Technological Process

#### Phase 1: Data Acquisition (Web Scraping)
In this phase I will present two as examples, since I have worked with both.
- [HemerotecaBNE](https://github.com/Rafav/HemerotecaBNE)
- [DownThemAll](https://about.downthemall.org/4.0/)

**Ethical considerations**:
- Respect for platform usage policies
- Implementation of gradual downloads
- Copyright compliance

#### Phase 2: Preprocessing
- **File nomenclature normalization**
- **Quality control** of images/PDFs
- **Structural organization** of the corpus
- **Prompt testing (Prompt engineering via web or batch)**

![image](https://github.com/user-attachments/assets/ddb54509-c9ce-42f5-b1ec-7efecb8774a2)

#### Phase 3: AI Processing

**Specialized Prompt Engineering**:
- Which requires having some knowledge of the PDF topic to be able to create a prompt that performs its function well.

**Specialized prompt for OCR of the Diario de Madrid 1788-1800**
```
You are an assistant specialized in document analysis. Your task is to analyze the content of a 19th-century historical newspaper and extract ONLY news related to music in any of its manifestations. INSTRUCTIONS: 1. Identify ALL news containing musical references, including: - Dances (also popular ones like jota, aurresku, fandango, etc.) - Musical performances (serenades, concerts) - Musical groups (sextets, orchestras, bands, rondallas, estudiantinas, tunas, choirs, orfeones) - Musical instruments (piano, guitar, etc.) - Composers and musicians - Singers - Theaters and musical performance venues - Romances, odes, tonadillas, zarzuela, charanga and singable poetry - Sacred music - Musical criticism - Musical education - Terms of solfege, harmony, score, etc. - Theater, representation or performance whether performed, canceled, suspended, postponed or "none". Any mention related to music. 1. Return EXCLUSIVELY a JSON object with the following structure: ```json { "noticias_musicales": [ { "id": 1, "texto_completo": "Complete text of the news without modifying or shortening.", "pagina": "Page number where it appears" }, { "id": 2, "texto_completo": "...", "pagina": "Page number where it appears" } ], "total_noticias": 0, "fecha_periodico": "Date of the analyzed newspaper" } IMPORTANT: Return only the requested JSON, without any additional comments. The json should contain only musical news, extract the date from the pdf filename itself, and removing characters like "/n" or "\n", nested single or double quotes.
```

This prompt clarifies specific things, such as the output format and the things we want the AI to extract.

#### Evaluation Metrics
To know that the information extracted by the AI is of good quality, we take into account the following points:
- **Precision**: Relevance of extracted information
- **Exhaustiveness**: Coverage of present references
- **Coherence**: Consistency in categorization

## 3. Methodological Innovations

### 3.1 Contributions to Digital Humanities

#### Specialized Prompt Engineering
Development of **disciplinary prompts** that incorporate:
- Specialized terminology from the field of study
- Academic relevance criteria
- Data structures compatible with subsequent analysis

#### Minimization of Hallucinations
Implemented strategies:
- Request for literal transcription prior to analysis
- Cross-validation with multiple models
- Internal coherence controls

#### Scalability and Reproducibility
- **Complete documentation** of the process
- **Automated scripts** for replication
- **Standardized interfaces** for different types of corpora

## 4. Results and Analysis

### 4.1 System Performance
- **Processing time**: [X] documents/hour
- **Average precision**: [95]% in reference identification
- **Manual time reduction**: [3,000] approximate hours compared to traditional methods

### 4.2 Expert Validation
- **Qualitative evaluation** by specialists in the discipline
- **Contrast** with previous research
- **Identification** of new research lines

## 5. Impact and Applications

### 5.1 Interdisciplinary Applicability
This methodology can be adapted to:
- **Press history** and journalism
- **Literary studies** and reception
- **Cultural and social history**
- **Historical discourse analysis**

### 5.2 Transferability
The developed protocol is applicable to:
- Different types of documents (manuscripts, printed, digital)
- Various historical periods
- Multiple languages and cultural traditions

## 6. Technical Aspects

### 6.1 System Architecture
```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Web Scraping  │ -> │   AI Processing  │ -> │  Visualization  │
│                 │    │                  │    │  and Analysis   │
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

### 6.2 Technologies Used
- **AI**: Claude AI (Anthropic) / GPT (OpenAI)
- **OCR/HTR**: Tesseract, EasyOCR, Surya
- **Processing**: Python, Claude AI
- **Visualization**: HTML5, CSS3, JavaScript
- **Data**: JSON, CSV for exchange

### Statistical Validation

#### Sample Design
- **Population**: 365 total documents
- **Confidence level**: 95%
- **Margin of error**: 5%
- **Sample**: [Diario de Madrid](xicobot.github.io), in which 17 out of 365 PDFs have some OCR error.

## 7. Conclusions

This project demonstrates the viability of applying artificial intelligence techniques to systematic analysis of historical documents, offering new possibilities for research in digital humanities. The developed methodology not only accelerates the analysis process but also allows identifying patterns and connections that might go unnoticed in traditional manual analysis.

The combination of traditional academic rigor with technological innovation opens new horizons for humanistic research, always maintaining the centrality of expert judgment and informed cultural interpretation.

## 8. References and Resources

### 8.1 Technical Resources
- **Project repository**: [[Xicobot.github.io](https://Xicobot.github.io)]
- **Technical documentation**: [https://github.com/Xicobot/AI-Historical-Document-Analysis/edit/main/docs/documetacionproceso.md]
- **Datasets**: [[Data access information](https://drive.google.com/drive/folders/1OCKzUtLZgnFNtphIlK8gy1NvrY1P7NQX?usp=sharing)]

### 8.2 Tools and Libraries
- Anthropic Claude API: https://docs.anthropic.com/
- Digital Newspaper Archive of Spain: https://hemerotecadigital.bne.es/
- Anthropic Claude Code: https://docs.anthropic.com/en/docs/claude-code/overview
- First reference project: https://rafav.github.io/diariomadrid/

---

**Note**: This documentation follows academic standards for digital humanities projects and can be adapted according to the specificities of each particular research. For the complete step-by-step process, [click here](/docs/documetacionproceso.md).

### [ESP](README.md)
This is a repository dedicated to processing PDFs through artificial intelligence for digital humanities. In this document, you can find the entire process carried out by me. This project was created with the purpose of documenting and providing a set of procedures to accomplish this task, in addition to being a project for FCT24-25.

### [ENG](docs/eng.md)
This is a repository dedicated to processing PDFs through artificial intelligence for Digital Humanities. In this document, you can find the entire process carried out by me. This project was created with the purpose of documenting and providing a set of procedures to accomplish this task, in addition to being a project for FCT24-25.
