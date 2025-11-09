# lector_codigo_barra.py

import os
import subprocess

def leer_codigo_barra(imagen_path):
    '''
        Lee el código de barras EAN-13 de una imagen usando zbarimg.
        Args:
            imagen_path (str): Ruta a la imagen del código de barras.
        Returns:
            str: El código de barras leído o None si no se pudo leer.
    '''

    try:
        resultado = subprocess.run(['zbarimg', imagen_path], capture_output=True, text=True)
        salida = resultado.stdout.strip()
        if salida.startswith('EAN-13:'):
            return salida.split(':')[1]
    except Exception as e:
        print(f"Error al leer {imagen_path}: {e}")
    return None

def procesar_directorio(directorio):
    '''
        Procesa todas las imágenes .png en un directorio para leer códigos de barras.
        Args:
            directorio (str): Ruta al directorio con las imágenes.
    Returns:
        None    
    '''
    for archivo in os.listdir(directorio):
        if archivo.lower().endswith('.png'):
            ruta_imagen = os.path.join(directorio, archivo)
            nombre_alumno = os.path.splitext(archivo)[0].replace('_', ' ')
            id_alumno = leer_codigo_barra(ruta_imagen)
            if id_alumno:
                print(f"Alumno: {nombre_alumno} | ID: {id_alumno}")
            else:
                print(f"Alumno: {nombre_alumno} | Código no detectado")

if __name__ == "__main__":
    directorio = input("Introduce la ruta del directorio con los .png: ")
    procesar_directorio(directorio)
