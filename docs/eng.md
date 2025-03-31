# Batch Processing System for Historical Document Transcription

## Introduction

This system is designed to process historical documents in PDF format in bulk and generate transcriptions in JSON format using the Claude API. The set of scripts automates sending batch requests and subsequent retrieval of results, facilitating work with large volumes of historical documents, especially those related to musical news from past eras.

## System Components

The system consists of four main scripts that work together:

1. **script.sh**: Main script that iterates over all PDF files in the current directory and initiates the transcription request process for each one.

2. **musica.py**: Python script that encodes a PDF file in base64 and sends it as a batch processing request to the Claude API, with specific instructions for transcribing musical news in historical documents.

3. **descargarbatches.sh**: Script that processes the generated batch order files, extracts the batch identifiers, and executes the retrieval script to obtain the results.

4. **recuperar_batch.py**: Script that uses batch identifiers to request and display processing results from the Claude API.

## Workflow

The system works as follows:

1. The user places the PDF files to be processed in the working directory.
2. `script.sh` is executed, which for each PDF file:
   - Invokes `musica.py` with the filename and a custom ID
   - Generates a batch order file with the format `[filename]_batch_order.txt`
3. After completing all requests, `descargarbatches.sh` is executed, which:
   - Searches for all batch order files generated previously
   - Extracts the batch ID from each file
   - Runs `recuperar_batch.py` for each ID, retrieving the result
   - Saves the result in a file with the format `[filename]_batch_output.txt`

This system is specially optimized for transcribing historical documents with musical content, such as old newspapers, sheet music, or documents related to musical events from the past.

## Requirements

- Python 3.x
- Anthropic library for Python (for Claude API access)
- Bash (to run shell scripts)
- Valid credentials for the Claude API
- PDF files to process

## Considerations

The system is specifically configured to identify and transcribe musical news in historical documents, including:
- Operas, concerts, and musical performances
- Documents about opera establishments
- Lists of actors from theatrical and comic companies
- Poetry and texts that could be sung
- Innovations related to musical instruments
- Any mention of music, performances, tunes, or musical pieces
- Information about attendance at musical shows

The system output is a structured JSON file with complete transcriptions of the musical news found in the documents.
