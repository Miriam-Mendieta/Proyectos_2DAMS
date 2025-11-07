def sum_two_smallest_numbers(numbers):
    """
        Devuelve la suma de los dos números positivos más bajos de una lista.

        Restricciones:
        - La lista debe tener al menos 4 elementos.
        - Todos los elementos deben ser enteros positivos (> 0).
        - No se aceptan flotantes, ceros ni negativos.

    Arg:
        numbers (list): Lista de enteros positivos.

    Return:
        int: Suma de los dos menores números positivos.
    Raises:
        ValueError: Si la lista tiene menos de 4 elementos o contiene números no válidos.
        TypeError: Si algún elemento no es un entero.
    """

    #  mínimo 4 elementos
    if len(numbers) < 4:
        raise ValueError("La lista debe contener al menos 4 números.")

    # todos deben ser enteros positivos
    for n in numbers:
        if not isinstance(n, int):
            raise TypeError(f"{n} no es un entero.")
        if n <= 0:
            raise ValueError(f"{n} no es un entero positivo mayor que cero.")

    # Ordenamos la lista y sumamos los dos menores
    ordenados = sorted(numbers)
    return ordenados[0] + ordenados[1]
