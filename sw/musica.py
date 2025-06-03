import anthropic
import base64
import argparse
from anthropic.types.beta.message_create_params import MessageCreateParamsNonStreaming
from anthropic.types.beta.messages.batch_create_params import Request
from anthropic import Anthropic

def main():
    # Set up command line argument parser
    parser = argparse.ArgumentParser(description='Process PDF files with Claude API')
    parser.add_argument('--file_name', required=True, help='Path to the PDF file')
    parser.add_argument('--custom_id', required=True, help='Custom ID for the request')
    args = parser.parse_args()

    # Read and encode the PDF file
    with open(args.file_name, "rb") as pdf_file:
        binary_data = pdf_file.read()
        base64_encoded_data = base64.standard_b64encode(binary_data)
        base64_string = base64_encoded_data.decode("utf-8")

    prompt = """
Eres un asistente especializado en análisis documental. Tu tarea es analizar el contenido de un periódico histórico del siglo XIX y extraer ÚNICAMENTE noticias, cartas, artículos y críticas relacionadas con música en cualquiera de sus manifestaciones.
INSTRUCCIONES: 1. Identifica TODAS las noticias que contengan referencias musicales, incluyendo: - Bailes (tambíen los populares como jota,aurresku, fandango, etc.) - Interpretaciones musicales (serenatas, conciertos) - Agrupaciones musicales (sextetos, orquestas, bandas, rondallas, estduiantinas, tunas, coros, orfeones) - Instrumentos musicales (piano, guitarra, etc.) - Compositores y músicos - Cantantes - Teatros y lugares de actuación musical - Romances, odas, tonadillas, zarzuela, charanga y poesía cantable -Música sacra -Crítica musical - Educación musical -Términos de solfeo, armonía, partitura, etc. - Teatro, representación o actuación ya sean realizadas, canceladas, suspendidas, aplazadas o "no hay".
Cualquier mención que tenga relación con música. 1. Devuelve EXCLUSIVAMENTE un objeto JSON con la siguiente estructura: ```json { "noticias_musicales": [ { "id": 1, "texto_completo": "Texto íntegro de la noticia, carta, artículo o crítica sin modificar ni acortar.", "pagina": "Número de página o paginas donde aparece" }, { "id": 2, "texto_completo": "...", "pagina": "Número de página donde aparece" } ], "total_noticias": 0, "fecha_periodico": "Fecha del periódico analizado" }
IMPORTANTE: Devuelva solo el JSON solicitado, sin ningún comentario adicional. El json debe contener solo noticias musicales, extrae la fecha del propio nombre del pdf, y eliminando caracteres como "/n" o "\n" , comillas simples o dobles anidadas.
"""

    client = anthropic.Anthropic()

    message_batch = client.beta.messages.batches.create(
   
    requests=[
        {
            "custom_id": args.custom_id,
            "params": {
                "model": "claude-3-7-sonnet-20250219",  # Updated to use Claude 3.7 Sonnet
                "max_tokens": 120000,
                 "thinking" : {
                    "type": "enabled",
                "budget_tokens": 100000
    },
                
                "messages": [
                    {
                        "role": "user",
                        "content": [
                            {
                                "type": "document",
                                "source": {
                                    "type": "base64",
                                    "media_type": "application/pdf",
                                    "data": base64_string
                                }
                            },
                            {
                                "type": "text",
                                "text": prompt
                            }
                        ]
                    }
                ]
            }
        }
    ]
)


    print(message_batch)

if __name__ == "__main__":
    main()
