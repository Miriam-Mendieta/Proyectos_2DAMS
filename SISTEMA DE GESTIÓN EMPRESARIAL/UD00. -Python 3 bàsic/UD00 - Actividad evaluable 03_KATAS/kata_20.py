def binary_array_to_number(arr):
    """
        Convierte un array de unos y ceros en su valor entero equivalente.

        Arg:
            arr (list): Lista de bits (0s y 1s).
        Return:
            int: Valor entero correspondiente al número binario.
        Raises:
            ValueError: Si algún elemento no es 0 o 1.
    """

    # Validación: todos deben ser 0 o 1
    for bit in arr:
        if bit not in (0, 1):
            raise ValueError(f"{bit} no es un bit válido (solo 0 o 1).")

    resultado = 0
    for bit in arr:
        resultado = resultado * 2 + bit
    return resultado
