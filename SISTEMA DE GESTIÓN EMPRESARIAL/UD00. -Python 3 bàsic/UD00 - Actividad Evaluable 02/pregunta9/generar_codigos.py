# generar_codigos.py

import sys
import csv
import os
from barcode import EAN13
from barcode.writer import ImageWriter

# --- 1. Definición del Formato EAN-13 ---
# EAN-13 necesita un número de 12 dígitos, ya que el dígito 13 (el de control)
# es calculado automáticamente por la librería.

def formatear_id_para_ean13(id_alumno):
    """
        Rellena el ID del alumno con ceros a la izquierda para alcanzar 12 dígitos.
        Args:
            id_alumno (str o int): El ID del alumno.
        Returns:
            str: El ID formateado con 12 dígitos.   

    """
    # Se asegura de que el ID sea una cadena
    str_id = str(id_alumno)
    # Rellena con ceros a la izquierda hasta 12 dígitos
    return str_id.zfill(12)

# --- 2. Lectura de Argumentos y CSV ---

def generar_codigos_desde_csv(ruta_csv):
    """
        Lee el archivo CSV y genera un código de barras EAN-13 para cada alumno.
        Args:
            ruta_csv (str): La ruta al archivo CSV con los datos de los alumnos.
        Returns:
            None                
    """
    print(f"Procesando el archivo CSV: {ruta_csv}")

    try:
        with open(ruta_csv, 'r', newline='', encoding='utf-8') as archivo_csv:
            # csv.reader, se asume que el separador es la coma (",")
            # y que los campos pueden estar entre comillas dobles (") 
            lector_csv = csv.reader(archivo_csv, delimiter=',', quotechar='"')
            
            # Iterar sobre cada fila del archivo CSV
            for i, fila in enumerate(lector_csv):
                # Omitir filas vacías
                if not fila:
                    continue
                    
                # Verificar el formato de la fila
                if len(fila) < 2:
                    print(f"Advertencia: Fila {i+1} ignorada. Formato incorrecto: {fila}")
                    continue
                
                # Desempaquetar los datos: nombre_alumno, ID
                nombre_alumno_crudo = fila[0].strip()
                id_alumno_crudo = fila[1].strip()

                # Limpieza y preparación del nombre
                # Se eliminan caracteres no válidos para nombres de archivo
                nombre_archivo_base = nombre_alumno_crudo.replace(" ", "_").replace("\"", "").replace("'", "")
                
                # Preparar ID para EAN-13
                try:
                    codigo_ean = formatear_id_para_ean13(id_alumno_crudo)
                except ValueError:
                    print(f"Error en fila {i+1}: El ID '{id_alumno_crudo}' no es un número válido. Saltando.")
                    continue
                
                # --- 3. Generación del Código de Barras ---
                
                # Crear el objeto EAN13. Se usa ImageWriter para generar PNGs.
                try:
                    ean = EAN13(codigo_ean, writer=ImageWriter())
                    
                    # Definir el nombre del archivo de salida: "nomalumne.png"
                    nombre_archivo_salida = f"{nombre_archivo_base}.png"
                    
                    # Guardar la imagen del código de barras
                    nombre_guardado = ean.save(nombre_archivo_salida)
                    print(f"Generado: '{nombre_guardado}' para el alumno '{nombre_alumno_crudo}' con ID: {id_alumno_crudo}")
                    
                except Exception as e:
                    print(f"Error al generar el código de barras para '{nombre_alumno_crudo}' (ID: {id_alumno_crudo}): {e}. Saltando.")
                    
    except FileNotFoundError:
        print(f"Error: El archivo '{ruta_csv}' no se encontró.")
        sys.exit(1)
    except Exception as e:
        print(f"Un error inesperado ocurrió: {e}")
        sys.exit(1)


if __name__ == "__main__":
    # sys.argv[0] es el nombre del script
    if len(sys.argv) < 2:
        print("Uso: python generar_codigos.py <ruta_del_archivo.csv>")
        sys.exit(1)
        
    # sys.argv[1] es el primer argumento pasado por consola (la ruta del archivo)
    archivo_entrada = sys.argv[1]
    generar_codigos_desde_csv(archivo_entrada)