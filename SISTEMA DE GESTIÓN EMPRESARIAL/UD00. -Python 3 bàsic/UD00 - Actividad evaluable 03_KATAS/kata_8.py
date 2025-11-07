def count_positives_sum_negatives(arr):
    """
        Devuelve una lista con:
            - La cantidad de números positivos.
            - La suma de los números negativos.
        Si la lista está vacía o es None, devuelve [].
        Arg:
            arr (list int): Lista de números enteros.
        Return:
            list: [cantidad_de_positivos, suma_de_negativos]
    """
# Verifica si la lista está vacía o es None (nula).Si es así, devuelve una lista vacía como resultado.
if not arr:
    return []

# Se crea una nueva lista con los elementos positivos de arr usando comprensión de listas. Luego calcula cuántos hay con len().
positivos = len([x for x in arr if x > 0])

# nueva lista con los elementos negativos de arr usando comprensión de listas. Luego suma todos esos elementos con sum().
suma_negativos = sum([x for x in arr if x < 0])

# Devuelve una lista con dos elementos: cantidad de positivos y la suma de los negativos.
return [positivos, suma_negativos]