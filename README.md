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
1. Descargar el plugin.
2. Irse a la pagina de la [Hemeroteca digital](https://hemerotecadigital.bne.es/hd/es/results?parent=674a2e4f-97ed-463c-af7b-072ceb37a1b7&t=date-asc&s=520)
3. Escoger el numero de paginas a descargar

4. ![image](https://github.com/user-attachments/assets/2e54eeec-25aa-46e2-abb1-1969103895d6)

- [DownThemAll](https://about.downthemall.org/4.0/)

<!-- (Foto de ambas) --->

**Consideraciones éticas**:
- Respeto a las políticas de uso de las plataformas
- Implementación de descargas graduales
- Cumplimiento de derechos de autor

<!-- (Checkpoint) --->


#### Fase 2: Preprocesamiento
- **Normalización de nomenclatura** de archivos
- **Control de calidad** de imágenes/PDFs
- **Organización estructural** del corpus

#### Fase 3: Procesamiento con IA

**Prompt Engineering Especializado**:
```json
{
  "contexto_disciplinar": "Análisis filológico e histórico-cultural",
  "categorias_extraccion": [
    "referencias_literarias_directas",
    "referencias_literarias_indirectas", 
    "manifestaciones_culturales",
    "contexto_sociohistorico"
  ],
  "formato_salida": "JSON estructurado",
  "validacion": "transcripcion_literal_obligatoria"
}
```

### 2.3 Validación Estadística

#### Diseño Muestral
- **Población**: N documentos totales
- **Nivel de confianza**: 95%
- **Margen de error**: 5%
- **Muestra**: n documentos seleccionados aleatoriamente

#### Métricas de Evaluación
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

### 3.2 Interface de Investigación

#### Visualización Interactiva
```html
<!-- Sistema de navegación dual: resultados + visualización PDF -->
<div class="research-interface">
  <div class="results-panel"><!-- Resultados estructurados --></div>
  <div class="document-viewer"><!-- Visualización sincronizada --></div>
</div>
```

#### Funcionalidades Académicas
- **Navegación por categorías** temáticas
- **Búsqueda semántica** avanzada
- **Exportación** a formatos académicos (LaTeX, BibTeX)
- **Anotación colaborativa** para validación

## 4. Resultados y Análisis

### 4.1 Rendimiento del Sistema
- **Tiempo de procesamiento**: [X] documentos/hora
- **Precisión promedio**: [X]% en identificación de referencias
- **Reducción de tiempo manual**: [X]% respecto a métodos tradicionales

### 4.2 Descubrimientos Académicos
[Incluir hallazgos específicos del análisis, por ejemplo:]
- Patrones de recepción cultural en el período estudiado
- Evolución de referencias literarias a lo largo del tiempo
- Conexiones interdisciplinarias identificadas

### 4.3 Validación por Expertos
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

## 7. Consideraciones Éticas y Legales

### 7.1 Propiedad Intelectual
- Respeto a **derechos de autor** de documentos
- **Uso académico** bajo principios de fair use
- **Atribución adecuada** de fuentes primarias

### 7.2 Transparencia Metodológica
- **Código abierto** disponible en repositorio público
- **Documentación completa** del proceso
- **Datos de entrenamiento** y validación accesibles

### 7.3 Privacidad y Datos Sensibles
- **Anonimización** cuando corresponda
- **Protocolo de seguridad** para documentos sensibles

## 8. Limitaciones y Trabajo Futuro

### 8.1 Limitaciones Actuales
- Dependencia de la calidad del material digitalizado
- Posibles sesgos en la selección automatizada
- Limitaciones linguísticas de los modelos de IA

### 8.2 Líneas de Desarrollo
- **Integración con linked data** y ontologías especializadas
- **Análisis de sentimientos** y tonalidad histórica
- **Comparación temporal** automatizada
- **Multimodalidad**: integración de imágenes y texto

## 9. Conclusiones

Este proyecto demuestra la viabilidad de aplicar técnicas de inteligencia artificial al análisis sistemático de documentos históricos, ofreciendo nuevas posibilidades para la investigación en humanidades digitales. La metodología desarrollada no solo acelera el proceso de análisis sino que también permite identificar patrones y conexiones que podrían pasar desapercibidos en el análisis manual tradicional.

La combinación de rigor académico tradicional con innovación tecnológica abre nuevos horizontes para la investigación humanística, manteniendo siempre la centralidad del criterio experto y la interpretación cultural informada.

## 10. Referencias y Recursos

### 10.1 Bibliografía Académica
- Moretti, F. (2013). *Distant Reading*. Verso Books.
- Hockey, S. (2004). "The History of Humanities Computing: An Overview". En *A Companion to Digital Humanities*.
- Ramsay, S. (2011). *Reading Machines: Toward an Algorithmic Criticism*.

### 10.2 Recursos Técnicos
- **Repositorio del proyecto**: [URL del repositorio]
- **Documentación técnica**: [Enlaces a documentación específica]
- **Datasets**: [Información sobre acceso a datos]

### 10.3 Herramientas y Librerías
- Anthropic Claude API: https://docs.anthropic.com/
- EasyOCR: https://github.com/JaidedAI/EasyOCR
- Digital Humanities toolkit recommendations

---

**Nota**: Esta documentación sigue estándares académicos para proyectos de humanidades digitales y puede adaptarse según las especificidades de cada investigación particular.

### [ESP](README.md)
Esto es un repositorio dedicado al procesamiento de PDF's a traves de inteligencia artificial para humanidades digitales, en esté documento se puede encontrar todo el proceso realizado por mi parte, este proyecto se ha realizado con el proposito de documentar y proporcionar una serie de procedimientos con tal de cumplir esa tarea, aparte de que es un proyecto de la FCT24-25.

### [ENG](docs/eng.md)
This is a repository dedicated to processing PDFs through artificial intelligence for Digital Humanities. In this document, you can find the entire process carried out by me. This project was created with the purpose of documenting and providing a set of procedures to accomplish this task, in addition to being a project for FCT24-25.
        
