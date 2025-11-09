# Función que cuenta las minas adyacentes para cada celda del campo
def contandoMinas(miCampo):
    '''
    Esta función recibe una matriz que representa un campo de Buscaminas,
    donde -1 representa una mina y 0 una casilla vacía.
    Devuelve una nueva matriz donde cada casilla vacía contiene el número
    de minas adyacentes.
    Args:
        miCampo (list of list of int): Matriz del campo de Buscaminas.
    Returns:
        list of list of int: Matriz con el conteo de minas adyacentes.
    '''
    filas = len(miCampo)
    resultado = []

    # Direcciones relativas de las 8 celdas adyacentes
    direcciones = [(-1, -1), (-1, 0), (-1, 1),
                    (0, -1),          (0, 1),
                    (1, -1),  (1, 0),  (1, 1)]

    # Recorremos cada celda del campo
    for i in range(filas):
        fila_resultado = []
        columnas = len(miCampo[i])  # longitud de la fila actual
        for j in range(columnas):
            if miCampo[i][j] == -1:
                fila_resultado.append(-1)
            else:
                contador = 0
                for dx, dy in direcciones:
                    ni, nj = i + dx, j + dy
                    # Verificamos que la fila y columna vecina existen
                    if 0 <= ni < filas and 0 <= nj < len(miCampo[ni]):
                        if miCampo[ni][nj] == -1:
                            contador += 1
                fila_resultado.append(contador)
        resultado.append(fila_resultado)

    return resultado

# -----------------------------
# LECTURA DE DATOS DESDE TECLADO
# -----------------------------

print("Introduce el campo de Buscaminas fila por fila.")
print("Usa 0 para casillas vacías y -1 para minas.")
print("Introduce una línea vacía para terminar.")

campo = []  # Lista para almacenar las filas del campo

while True:
    linea = input("Fila: ")
    if linea.strip() == "":
        break  # Si la línea está vacía se termina la entrada
    # línea en una lista de enteros
    fila = list(map(int, linea.strip().split()))
    campo.append(fila)

# Procesamos el campo con la función
resultado = contandoMinas(campo)

# resultado
print("\nResultado:")
for fila in resultado:
    print(' '.join(str(celda) for celda in fila))
