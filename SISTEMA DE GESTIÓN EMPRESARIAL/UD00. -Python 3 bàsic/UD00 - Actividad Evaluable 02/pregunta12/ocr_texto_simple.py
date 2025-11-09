# ocr_texto_simple.py
# Este script utiliza OCR para extraer texto de una imagen y mostrarlo en la consola.

from PIL import Image  # Para abrir imágenes
import pytesseract     # Para aplicar OCR

# Ruta al ejecutable de Tesseract en Windows
pytesseract.pytesseract.tesseract_cmd = r'C:\Program Files\Tesseract-OCR\tesseract.exe'

# Abrimos la imagen que contiene texto
imagen = Image.open("ejemplo.png").convert("L")  # Escala de grises

# Extraemos el texto usando OCR
texto = pytesseract.image_to_string(imagen, lang='spa')  # 'spa' para español

# Mostramos el texto reconocido
print("Texto detectado:")
print(texto)
