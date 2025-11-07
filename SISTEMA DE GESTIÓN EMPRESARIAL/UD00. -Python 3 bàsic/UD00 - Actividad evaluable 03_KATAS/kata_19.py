def descending_order(num):
    """
        Recibe un número entero no negativo y devuelve el número formado
        por sus dígitos en orden descendente.

        Restricciones:
            - El número debe ser un entero.
            - Debe ser no negativo (≥ 0).

        Arg:
            num (int): Número entero no negativo.

        Return:
            int: Número con los dígitos ordenados de mayor a menor.

        Raises:
            TypeError: Si el número no es un entero.
            ValueError: Si el número es negativo.
    """

    # Validaciones
    if not isinstance(num, int):
        raise TypeError(f"{num} no es un entero.")
    if num < 0:
        raise ValueError(f"{num} no se admiten números menores a cero.")

    # Convertimos el número a cadena, ordenamos los dígitos en reversa y unimos
    return int(''.join(sorted(str(num), reverse=True)))
