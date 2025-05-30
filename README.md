# AI-Historical-Document-Analysis

[![imagen1](https://github.com/user-attachments/assets/e3aa81e7-b50a-489f-9945-b0d3e177950a)](https://Xicobot.github.io)

# Documentación del Proyecto: Análisis de Documentos Históricos mediante Inteligencia Artificial y OCR

## 1. Introducción y Contexto Académico

### 1.1 Descripción del Proyecto
Este proyecto forma parte de las iniciativas en **Humanidades Digitales** que integran herramientas de inteligencia artificial para el análisis automatizado de documentos históricos. La metodología desarrollada permite la localización, transcripción y análisis sistemático de contenido musical en corpus documentales de gran volumen.

### 1.2 Marco Teórico
El proyecto se enmarca dentro de la corriente de las **Digital Humanities**, específicamente en:
- **Distant Reading** (Franco Moretti): Análisis cuantitativo de textos literarios
- **Cultural Analytics** (Lev Manovich): Aplicación de métodos computacionales al análisis cultural
- **Corpus Linguistics**: Estudio de patrones lingüísticos en grandes colecciones textuales

### 1.3 Objetivos de Investigación

#### Objetivo General
Desarrollar una metodología reproducible para la identificación automatizada de referencias culturales y musicales en documentos históricos mediante técnicas de inteligencia artificial.

#### Objetivos Específicos
1. Implementar un pipeline de procesamiento OCR/HTR para documentos históricos
2. Crear prompts especializados para la extracción de información cultural
3. Validar estadísticamente la precisión de los resultados obtenidos
4. Generar interfaces de visualización para facilitar la investigación humanística
5. Establecer protocolos de reproducibilidad para futuros estudios

## 2. Metodología

### 2.1 Corpus de Estudio
- **Fuente**: [Especificar la fuente documental, ej: Biblioteca Nacional, archivo específico]
- **Período temporal**: [Indicar rango cronológico]
- **Volumen**: [Número de documentos/páginas]
- **Criterios de selección**: [Explicar por qué se eligió este corpus]

### 2.2 Proceso Tecnológico

#### Fase 1: Adquisición de Datos (Web Scraping)
En esta fase voy a poner dos como ejemplo, ya que he trabajado con las dos.
- [HemerotecaBNE](https://github.com/Rafav/HemerotecaBNE)
- [DownThemAll](https://about.downthemall.org/4.0/)

**Consideraciones éticas**:
- Respeto a las políticas de uso de las plataformas
- Implementación de descargas graduales
- Cumplimiento de derechos de autor

#### Fase 2: Preprocesamiento
- **Normalización de nomenclatura** de archivos
- **Control de calidad** de imágenes/PDFs 
- **Organización estructural** del corpus
- **Testeo de Prompts (Prompt engineering vía web o batch)**

![image](https://github.com/user-attachments/assets/ddb54509-c9ce-42f5-b1ec-7efecb8774a2)

#### Fase 3: Procesamiento con IA

**Prompt Engineering Especializado**:
- En el que se requiere tener un poco de conocimiento del tema de los PDF's para poder hacer un prompt que haga bien su funcíon.

**Prompt especializado en OCR del Díario de Madrid de 1788**


```
Eres un asistente especializado en análisis documental. Tu tarea es analizar el contenido de un periódico histórico del siglo XIX y extraer ÚNICAMENTE noticias relacionadas con música en cualquiera de sus manifestaciones. INSTRUCCIONES: 1. Identifica TODAS las noticias que contengan referencias musicales, incluyendo: - Bailes (tambíen los populares como jota,aurresku, fandango, etc.) - Interpretaciones musicales (serenatas, conciertos) - Agrupaciones musicales (sextetos, orquestas, bandas, rondallas, estduiantinas, tunas, coros, orfeones) - Instrumentos musicales (piano, guitarra, etc.) - Compositores y músicos - Cantantes - Teatros y lugares de actuación musical - Romances, odas, tonadillas, zarzuela, charanga y poesía cantable -Música sacra -Crítica musical - Educación musical -Términos de solfeo, armonía, partitura, etc. - Teatro, representación o actuación ya sean realizadas, canceladas, suspendidas, aplazadas o "no hay". Cualquier mención que tenga relación con música. 1. Devuelve EXCLUSIVAMENTE un objeto JSON con la siguiente estructura: ```json { "noticias_musicales": [ { "id": 1, "texto_completo": "Texto íntegro de la noticia sin modificar ni acortar.", "pagina": "Número de página donde aparece" }, { "id": 2, "texto_completo": "...", "pagina": "Número de página donde aparece" } ], "total_noticias": 0, "fecha_periodico": "Fecha del periódico analizado" } IMPORTANTE: Devuelva solo el JSON solicitado, sin ningún comentario adicional. El json debe contener solo noticias musicales, extrae la fecha del propio nombre del pdf, y eliminando caracteres como "/n" o "\n" , comillas simples o dobles anidadas.
```

En esté prompt se aclaran cosas especificas, como el formato del output y las cosas que queremos que extraiga la IA.

#### Métricas de Evaluación
Para saber que la información extraida por la IA es de buena calidad, tenemos en cuenta los siguientes puntos:
- **Precisión**: Relevancia de la información extraída
- **Exhaustividad**: Cobertura de las referencias presentes
- **Coherencia**: Consistencia en la categorización

## 3. Innovaciones Metodológicas

### 3.1 Contribuciones a las Humanidades Digitales

#### Prompt Engineering Especializado
Desarrollo de **prompts disciplinarios** que incorporan:
- Terminología especializada del campo de estudio
- Criterios de relevancia académica
- Estructuras de datos compatibles con análisis posterior

#### Minimización de Alucinaciones
Estrategias implementadas:
- Solicitud de transcripción literal previa al análisis
- Validación cruzada con múltiples modelos
- Controles de coherencia interna

#### Escalabilidad y Reproducibilidad
- **Documentación completa** del proceso
- **Scripts automatizados** para replicación
- **Interfaces estandarizadas** para diferentes tipos de corpus

## 4. Resultados y Análisis

### 4.1 Rendimiento del Sistema
- **Tiempo de procesamiento**: [X] documentos/hora
- **Precisión promedio**: [95]% en identificación de referencias
- **Reducción de tiempo manual**: [3000]Horas aproximadas respecto a métodos tradicionales

### 4.2 Validación por Expertos
- **Evaluación cualitativa** por especialistas en la disciplina
- **Contraste** con investigaciones previas
- **Identificación** de nuevas líneas de investigación

## 5. Impacto y Aplicaciones

### 5.1 Aplicabilidad Interdisciplinaria
Esta metodología puede adaptarse a:
- **Historia de la prensa** y periodismo
- **Estudios literarios** y de recepción
- **Historia cultural** y social
- **Análisis del discurso** histórico

### 5.2 Transferibilidad
El protocolo desarrollado es aplicable a:
- Diferentes tipos de documentos (manuscritos, impresos, digitales)
- Diversos períodos históricos
- Múltiples idiomas y tradiciones culturales

## 6. Aspectos Técnicos

### 6.1 Arquitectura del Sistema
```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Web Scraping  │ -> │  Procesamiento   │ -> │  Visualización  │
│                 │    │     con IA       │    │  y Análisis     │
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

### 6.2 Tecnologías Utilizadas
- **IA**: Claude AI (Anthropic) / GPT (OpenAI)
- **OCR/HTR**: Tesseract, EasyOCR, Surya
- **Procesamiento**: Python, JavaScript
- **Visualización**: HTML5, CSS3, JavaScript
- **Datos**: JSON, CSV para intercambio

### 6.3 Requisitos de Infraestructura
- **Computacional**: [Especificar recursos necesarios]
- **Almacenamiento**: [Volumen de datos]
- **Red**: Conexión estable para APIs de IA


### Validación Estadística

#### Diseño Muestral
- **Población**: 365 documentos totales
- **Nivel de confianza**: 95%
- **Margen de error**: 5%
- **Muestra**: [Díario de Madrid](xicobot.github.io), en el que 17 de 365 PDF's tienen algún error de OCR.


## 7. Conclusiones

Este proyecto demuestra la viabilidad de aplicar técnicas de inteligencia artificial al análisis sistemático de documentos históricos, ofreciendo nuevas posibilidades para la investigación en humanidades digitales. La metodología desarrollada no solo acelera el proceso de análisis sino que también permite identificar patrones y conexiones que podrían pasar desapercibidos en el análisis manual tradicional.

La combinación de rigor académico tradicional con innovación tecnológica abre nuevos horizontes para la investigación humanística, manteniendo siempre la centralidad del criterio experto y la interpretación cultural informada.

## 8. Referencias y Recursos

### 8.1 Recursos Técnicos
- **Repositorio del proyecto**: [URL del repositorio]
- **Documentación técnica**: [Enlaces a documentación específica]
- **Datasets**: [Información sobre acceso a datos]

### 8.2 Herramientas y Librerías
- Anthropic Claude API: https://docs.anthropic.com/
- Hemeroteca Digital Nacional de España: https://hemerotecadigital.bne.es/

---

**Nota**: Esta documentación sigue estándares académicos para proyectos de humanidades digitales y puede adaptarse según las especificidades de cada investigación particular, para el proceso completo y paso a paso, [pincha aquí](/docs/documetacionproceso.md).

### [ESP](README.md)
Esto es un repositorio dedicado al procesamiento de PDF's a traves de inteligencia artificial para humanidades digitales, en esté documento se puede encontrar todo el proceso realizado por mi parte, este proyecto se ha realizado con el proposito de documentar y proporcionar una serie de procedimientos con tal de cumplir esa tarea, aparte de que es un proyecto de la FCT24-25.

### [ENG](docs/eng.md)
This is a repository dedicated to processing PDFs through artificial intelligence for Digital Humanities. In this document, you can find the entire process carried out by me. This project was created with the purpose of documenting and providing a set of procedures to accomplish this task, in addition to being a project for FCT24-25.
        
