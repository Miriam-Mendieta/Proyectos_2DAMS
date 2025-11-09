import sys
import pyperclip
import time
import re

def cargar_palabras_prohibidas(nombre_archivo):
    """
        Carga las palabras prohibidas desde un archivo.
        Todas las palabras se convierten a minúsculas para una comparación
        insensible a mayúsculas y minúsculas.

        Args:
            nombre_archivo (str): Ruta al archivo que contiene las palabras prohibidas.

        Returns:
            set: Un conjunto de palabras prohibidas en minúsculas.
    """
    try:
        with open(nombre_archivo, 'r', encoding='utf-8') as archivo:
            # strip() elimina espacios en blanco y saltos de línea
            # lower() convierte a minúsculas
            palabras = {linea.strip().lower() for linea in archivo if linea.strip()}
        print(f"Palabras prohibidas cargadas: {len(palabras)} ({', '.join(palabras)})")
        return palabras
    except FileNotFoundError:
        print(f"Error: El archivo '{nombre_archivo}' no fue encontrado.")
        sys.exit(1)
    except Exception as e:
        print(f"Ocurrió un error al leer el archivo: {e}")
        sys.exit(1)

def filtrar_texto(texto, palabras_prohibidas):
    """
        Analiza el texto y reemplaza cualquier palabra prohibida con asteriscos (*).
        Mantiene la capitalización y formato del texto original.

        Args:
            texto (str): El texto a analizar.
            palabras_prohibidas (set): Conjunto de palabras prohibidas en minúsculas.
        Returns:
            str: El texto modificado con palabras prohibidas reemplazadas.
            bool: Indica si el texto fue modificado.
    """
    # Expresión regular para encontrar cualquier secuencia que NO sea letra/número/guion bajo
    # Usamos re.split para dividir el texto y mantener los delimitadores
    # re.IGNORECASE asegura que la comparación sea insensible a mayúsculas/minúsculas
    
    # Este patrón encuentra las 'palabras' (secuencias de letras y números)
    # y los 'separadores' (secuencias de otros caracteres como espacios, puntuación, etc.)
    partes = re.split(r'(\b\w+\b)', texto, flags=re.IGNORECASE)
    
    texto_filtrado = []
    modificado = False
    
    for parte in partes:
        # Si la parte es una palabra (no un separador vacío)
        if parte.strip() and parte.isalnum():
            # Comparamos la palabra en minúsculas con nuestro conjunto de prohibidas
            if parte.lower() in palabras_prohibidas:
                # Reemplazamos por asteriscos de la misma longitud
                texto_filtrado.append('*' * len(parte))
                modificado = True
                print(f"  Reemplazada: '{parte}'")
            else:
                texto_filtrado.append(parte)
        else:
            # Los separadores (espacios, puntuación) se añaden sin cambios
            texto_filtrado.append(parte)
            
    return "".join(texto_filtrado), modificado

def main():
    if len(sys.argv) < 2:
        print("Uso: python programa.py <archivo_de_palabras_prohibidas>")
        sys.exit(1)

    nombre_archivo = sys.argv[1]
  
    palabras_prohibidas = cargar_palabras_prohibidas(nombre_archivo)
    
    ultimo_texto = pyperclip.paste()
    print("Portapapeles inicial: '", ultimo_texto[:30], "...'")

    
    print("\nEl programa está monitoreando el portapapeles (presiona Ctrl+C para detener).")
    
    while True:
        try:
            texto_actual = pyperclip.paste()
            
            if texto_actual != ultimo_texto:
                print(f"\nNuevo texto detectado: '{texto_actual}'")
                
                # Filtrar el texto
                texto_filtrado, fue_modificado = filtrar_texto(texto_actual, palabras_prohibidas)
                
                if fue_modificado:
                    # Copiar el texto modificado al portapapeles
                    pyperclip.copy(texto_filtrado)
                    print(f"Texto modificado y copiado al portapapeles: '{texto_filtrado}'")
                    
                    ultimo_texto = texto_filtrado 
                else:
                    print(" No se encontraron palabras prohibidas. Texto sin cambios.")
                    ultimo_texto = texto_actual
            
            time.sleep(0.1)
            
        except Exception as e:
            print(f"\nOcurrió un error inesperado: {e}")
            time.sleep(1)

if __name__ == "__main__":
    main()