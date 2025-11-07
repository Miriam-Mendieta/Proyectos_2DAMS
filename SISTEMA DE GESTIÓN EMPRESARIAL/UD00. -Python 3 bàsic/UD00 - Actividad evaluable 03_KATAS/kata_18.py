def is_triangle(a, b, c):
    """
        Determina si tres lados pueden formar un triángulo válido.

        Requisitos:
            - Los tres valores deben ser enteros positivos (> 0).
            - Deben cumplir la desigualdad triangular:
                a + b > c, a + c > b, b + c > a

        Arg:
            a, b, c (int): Longitudes de los lados.

        Return:
            bool: True si forman un triángulo válido, False en caso contrario.

        Raises:
            TypeError: Si algún lado no es un entero.
    """

    # Validación: todos deben ser enteros positivos
    for lado in (a, b, c):
        if not isinstance(lado, int):
            raise TypeError(f"{lado} no es un entero.")
        if lado <= 0:
            return False

    # Verificamos la desigualdad triangular
    return (a + b > c) and (a + c > b) and (b + c > a)
