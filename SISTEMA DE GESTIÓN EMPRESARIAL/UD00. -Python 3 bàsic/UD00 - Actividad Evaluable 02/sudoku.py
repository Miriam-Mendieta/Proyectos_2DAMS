#sudoku.py

import os

# ---  Definición de la función de verificación ---

def esSudokuCorrecto(miArrayBi):
    """
    Comprueba si la matriz de Sudoku de 9x9 es válida.
    Un Sudoku es válido si cada fila, cada columna y cada subcuadrícula 3x3 
    contiene todos los dígitos del 1 al 9 una sola vez.
    Args:
        miArrayBi (list of list of int): Matriz 9x9 que representa el Sudoku.
    Returns:
        bool: True si el Sudoku es correcto, False en caso contrario.
    """
    
def esSudokuCorrecto(miArrayBi):
    # Verifica que cada fila tenga números del 1 al 9 sin repetir
    for fila in miArrayBi:
        if set(fila) != set(range(1, 10)):
            return False

    # Verifica que cada columna tenga números del 1 al 9 sin repetir
    for col in range(9):
        columna = {miArrayBi[fila][col] for fila in range(9)}
        if columna != set(range(1, 10)):
            return False

    # Verifica cada subcuadro 3x3
    for fila in range(0, 9, 3):
        for col in range(0, 9, 3):
            subcuadro = set()
            for i in range(3):
                for j in range(3):
                    subcuadro.add(miArrayBi[fila + i][col + j])
            if subcuadro != set(range(1, 10)):
                return False

    return True


# ---  Lectura del archivo y lógica principal ---

NOMBRE_ARCHIVO = "Sudoku.in"

# Comprobación de que el archivo existe, no vaya a ser que lo estemos buscando bajo las piedras.
if not os.path.exists(NOMBRE_ARCHIVO):
    print(f"Error: No se encontró el archivo '{NOMBRE_ARCHIVO}'.")
    print("Asegúrate de que está en la misma carpeta que el script.")
    exit()

try:
    # Leer el archivo y parsear la matriz
    with open(NOMBRE_ARCHIVO, 'r') as f:
        datos = f.readlines()
    
    matriz_sudoku = []
    
    # Procesar cada línea
    for linea in datos:
        # Quitamos espacios iniciales/finales, dividimos por espacios y convertimos a entero
        numeros = [int(n) for n in linea.strip().split() if n.isdigit()]
        
        # Validación de formato (debe haber 9 números por línea)
        if len(numeros) != 9:
            print("Error de formato: Cada línea en 'Sudoku.in' debe contener exactamente 9 números.")
            # Puedes devolver 'incorrecto' o salir, salimos para ser estrictos.
            exit() 
            
        matriz_sudoku.append(numeros)
        
    # Validación de formato (debe haber 9 líneas)
    if len(matriz_sudoku) != 9:
        print("Error de formato: 'Sudoku.in' debe contener exactamente 9 líneas.")
        exit()

    # ---  Llamada a la función y salida ---
    
    # Hacemos la comprobación
    resultado = esSudokuCorrecto(matriz_sudoku)

    # Imprimimos el resultado por consola
    if resultado:
        print("correcto")
    else:
        print("incorrecto")

except Exception as e:
    # Esto captura cualquier otro error inesperado, como un carácter no numérico en el archivo.
    print(f"Ocurrió un error al procesar el archivo: {e}")
    print("Asegúrate de que 'Sudoku.in' solo contiene números separados por espacios.")

    # desde terminal --> python sudoku.py