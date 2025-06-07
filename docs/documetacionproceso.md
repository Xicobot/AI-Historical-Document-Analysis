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

Probablemente, la mayor parte del proyecto, se las pasa aquí probando si el prompt funciona o no, ya que para ello, se requiere de muchas horas de prueba y error para conseguir lo que se necesita del pdf.

![image](https://github.com/user-attachments/assets/32c19218-fc00-4fbf-a29b-989c866b44ea)

## Prompt:
```prompt
Eres un asistente especializado en análisis documental. Tu tarea es analizar el contenido de un periódico histórico del siglo XIX y extraer ÚNICAMENTE noticias relacionadas con música en cualquiera de sus manifestaciones. INSTRUCCIONES: 1. Identifica TODAS las noticias que contengan referencias musicales, incluyendo: - Bailes (tambíen los populares como jota,aurresku, fandango, etc.) - Interpretaciones musicales (serenatas, conciertos) - Agrupaciones musicales (sextetos, orquestas, bandas, rondallas, estduiantinas, tunas, coros, orfeones) - Instrumentos musicales (piano, guitarra, etc.) - Compositores y músicos - Cantantes - Teatros y lugares de actuación musical - Romances, odas, tonadillas, zarzuela, charanga y poesía cantable -Música sacra -Crítica musical - Educación musical -Términos de solfeo, armonía, partitura, etc. - Teatro, representación o actuación ya sean realizadas, canceladas, suspendidas, aplazadas o "no hay". Cualquier mención que tenga relación con música. 1. Devuelve EXCLUSIVAMENTE un objeto JSON con la siguiente estructura: ```json { "noticias_musicales": [ { "id": 1, "texto_completo": "Texto íntegro de la noticia sin modificar ni acortar.", "pagina": "Número de página donde aparece" }, { "id": 2, "texto_completo": "...", "pagina": "Número de página donde aparece" } ], "total_noticias": 0, "fecha_periodico": "Fecha del periódico analizado" } IMPORTANTE: Devuelva solo el JSON solicitado, sin ningún comentario adicional. El json debe contener solo noticias musicales, extrae la fecha del propio nombre del pdf, y eliminando caracteres como "/n" o "\n" , comillas simples o dobles anidadas.
```

### 2.3 Lanzar batch
Para lanzar un batch, necesitamos tener una estructura organizada, primero, para que el [script](/sw/lanzarbatch.sh) a ejecutar envie todos los pdfs del directorío, lo que hace que:
1. Envia el pdf por la API, dejando un "nombre del archivo"batch_output.txt con un ID del mensaje que se recoge mas tarde.
2. Una vez procesado, esto lo podemos mirar en la consola de anthropic, la cual nos mostrar

## Bibliografía:
Anthropic API: https://docs.anthropic.com/en/docs/get-started
Prompt engineering: https://github.com/anthropics/courses/blob/master/prompt_engineering_interactive_tutorial/Anthropic%201P/00_Tutorial_How-To.ipynb
