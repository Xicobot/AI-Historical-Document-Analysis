# AI-Historical-Document-Analysis

[![imagen1](https://github.com/user-attachments/assets/e3aa81e7-b50a-489f-9945-b0d3e177950a)](https://Xicobot.github.io)

# Project Documentation: Analysis of Historical Documents through Artificial Intelligence and OCR

## 1. Introduction and Academic Context

### 1.1 Project Description
This project is part of initiatives in **Digital Humanities** that integrate artificial intelligence tools for the automated analysis of historical documents. The developed methodology allows for the location, transcription, and systematic analysis of musical content in large document corpora.

### 1.2 Theoretical Framework
The project is framed within the current of **Digital Humanities**, specifically in:
- **Distant Reading** (Franco Moretti): Quantitative analysis of literary texts
- **Cultural Analytics** (Lev Manovich): Application of computational methods to cultural analysis
- **Corpus Linguistics**: Study of linguistic patterns in large textual collections

### 1.3 Research Objectives

#### General Objective
Develop a reproducible methodology for the automated identification of cultural and musical references in historical documents using artificial intelligence techniques.

#### Specific Objectives
1. Implement an OCR/HTR processing pipeline for historical documents
2. Create specialized prompts for cultural information extraction
3. Statistically validate the accuracy of the obtained results
4. Generate visualization interfaces to facilitate humanistic research
5. Establish reproducibility protocols for future studies

## 2. Methodology

### 2.1 Study Corpus
- **Source**: [Specify the documentary source, e.g.: National Library, specific archive]
- **Time period**: [Indicate chronological range]
- **Volume**: [Number of documents/pages]
- **Selection criteria**: [Explain why this corpus was chosen]

### 2.2 Technological Process

#### Phase 1: Data Acquisition (Web Scraping)
In this phase, I will provide two examples, as I have worked with both.
- [HemerotecaBNE](https://github.com/Rafav/HemerotecaBNE)
- [DownThemAll](https://about.downthemall.org/4.0/)

**Ethical Considerations**:
- Respect for platform usage policies
- Implementation of gradual downloads
- Compliance with copyright

#### Phase 2: Preprocessing
- **Standardization of file nomenclature**
- **Quality control** of images/PDFs
- **Structural organization** of the corpus
- **Prompt testing (Prompt engineering via web or batch)**

![image](https://github.com/user-attachments/assets/ddb54509-c9ce-42f5-b1ec-7efecb8774a2)

#### Phase 3: AI Processing

**Specialized Prompt Engineering**:
- Which requires some knowledge of the PDF topic to create a prompt that performs its function well.

**Specialized prompt for OCR of the Madrid Diary from 1788**

```
You are an assistant specialized in document analysis. Your task is to analyze the content of a historical newspaper from the 19th century and extract ONLY news related to music in any of its manifestations. INSTRUCTIONS: 1. Identify ALL news that contain musical references, including: - Dances (also popular ones like jota, aurresku, fandango, etc.) - Musical performances (serenades, concerts) - Musical groups (sextets, orchestras, bands, rondallas, student groups, tunas, choirs, choral societies) - Musical instruments (piano, guitar, etc.) - Composers and musicians - Singers - Theaters and musical performance venues - Romances, odes, tonadillas, zarzuela, brass bands and singable poetry - Sacred music - Music criticism - Music education - Terms of solfeggio, harmony, score, etc. - Theater, representation or performance whether performed, canceled, suspended, postponed or "none". Any mention that is related to music. 1. Return EXCLUSIVELY a JSON object with the following structure: ```json { "musical_news": [ { "id": 1, "full_text": "Complete text of the news without modification or shortening.", "page": "Page number where it appears" }, { "id": 2, "full_text": "...", "page": "Page number where it appears" } ], "total_news": 0, "newspaper_date": "Date of the analyzed newspaper" } IMPORTANT: Return only the requested JSON, without any additional comments. The json should contain only musical news, extract the date from the pdf name itself, and remove characters like "/n" or "\n", nested single or double quotes.
```

In this prompt, specific things are clarified, such as the output format and what we want the AI to extract.

#### Evaluation Metrics
To ensure that the information extracted by AI is of good quality, we take into account the following points:
- **Precision**: Relevance of the extracted information
- **Thoroughness**: Coverage of the present references
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
- **Manual time reduction**: [3000] Approximate hours compared to traditional methods

### 4.2 Expert Validation
- **Qualitative evaluation** by specialists in the discipline
- **Contrast** with previous research
- **Identification** of new lines of research

## 5. Impact and Applications

### 5.1 Interdisciplinary Applicability
This methodology can be adapted to:
- **History of the press** and journalism
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
│   Web Scraping  │ -> │  AI Processing   │ -> │  Visualization  │
│                 │    │                  │    │  and Analysis   │
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

### 6.2 Technologies Used
- **AI**: Claude AI (Anthropic) / GPT (OpenAI)
- **OCR/HTR**: Tesseract, EasyOCR, Surya
- **Processing**: Python, JavaScript
- **Visualization**: HTML5, CSS3, JavaScript
- **Data**: JSON, CSV for exchange

### 6.3 Infrastructure Requirements
- **Computational**: [Specify necessary resources]
- **Storage**: [Data volume]
- **Network**: Stable connection for AI APIs

### Statistical Validation

#### Sample Design
- **Population**: 365 total documents
- **Confidence level**: 95%
- **Margin of error**: 5%
- **Sample**: [Madrid Diary](xicobot.github.io), in which 17 out of 365 PDFs have some OCR error.

## 7. Conclusions

This project demonstrates the feasibility of applying artificial intelligence techniques to the systematic analysis of historical documents, offering new possibilities for research in digital humanities. The developed methodology not only accelerates the analysis process but also allows for the identification of patterns and connections that might go unnoticed in traditional manual analysis.

The combination of traditional academic rigor with technological innovation opens new horizons for humanistic research, always maintaining the centrality of expert criteria and informed cultural interpretation.

## 8. References and Resources

### 8.1 Technical Resources
- **Project repository**: [Repository URL]
- **Technical documentation**: [Links to specific documentation]
- **Datasets**: [Information on data access]

### 8.2 Tools and Libraries
- Anthropic Claude API: https://docs.anthropic.com/
- National Digital Newspaper Library of Spain: https://hemerotecadigital.bne.es/

---

**Note**: This documentation follows academic standards for digital humanities projects and can be adapted according to the specificities of each particular research. For the complete step-by-step process, [click here](/docs/documetacionproceso.md).

### [ESP](README.md)
This is a repository dedicated to processing PDFs through artificial intelligence for digital humanities. In this document, you can find the entire process carried out by me. This project was created with the purpose of documenting and providing a set of procedures to accomplish this task, in addition to being a project for FCT24-25.

### [ENG](docs/eng.md)
This is a repository dedicated to processing PDFs through artificial intelligence for Digital Humanities. In this document, you can find the entire process carried out by me. This project was created with the purpose of documenting and providing a set of procedures to accomplish this task, in addition to being a project for FCT24-25.
