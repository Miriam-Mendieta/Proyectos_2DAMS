from functools import reduce  # Importa la función reduce para aplicar operaciones acumulativas sobre listas

# Bucle principal que solicita entrada hasta que sea válida
while True:
    entrada = input("Introduce números separados por espacio: ")

    # Verifica que la entrada no esté vacía ni contenga solo espacios
    if not entrada.strip(): #eliminar los espacios en blanco al principio y final de una cadena.
        print("La entrada está vacía. Inténtalo de nuevo.\n")
        continue

    # Intento de conversión de la entrada en una lista de enteros
    try:
        elementos = entrada.split()  # Divide la cadena por espacios
        numeros = [int(x) for x in elementos]  # Convierte cada elemento a entero
    except ValueError:
        # Si algún elemento no es convertible a entero, se lanza una excepción
        print("Error: Todos los elementos deben ser números enteros separados por espacios.\n")
        continue

    # Filtrado: Selecciona solo los números mayores o iguales a 10
    mayores_que_diez = list(filter(lambda x: x >= 10, numeros))

    # Verifica que haya al menos un número válido para operar
    if not mayores_que_diez:
        print("No hay números mayores o iguales a 10. Inténtalo de nuevo.\n")
        continue

    # Si todas las validaciones se superan, se sale del bucle
    break

# Multiplica todos los elementos filtrados
producto = reduce(lambda x, y: x * y, mayores_que_diez)

# Salida de resultados
print("Lista original:", numeros) 
print("Filtrados (>=10):", mayores_que_diez)  
print("Multiplicacion de los nº >=10:", producto) 

# Ejemplo de ejecución:
# Introduce números separados por espacio: 5 12 3 20 8
# Lista original: [5, 12, 3, 20, 8]
# Filtrados (>=10): [12, 20]
# Multiplicacion de los nº >=10: 240

# Ejemplo de ejecución:
# Introduce números separados por espacio: 4 7 2
# No hay números mayores o iguales a 10. Inténtalo de nuevo.

# Ejemplo de ejecución:
# Introduce números separados por espacio: 15 abc 25
# Error: Todos los elementos deben ser números enteros separados por espacios.
