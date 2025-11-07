def digitize(n):
    """
        Convierte un número entero no negativo en una lista de sus dígitos en orden inverso.

        Arg:
            n (int): Número entero no negativo.

        Returns:
            list: Lista de dígitos en orden inverso.
    """

    #  de número a cadena para poder iterar sobre sus dígitos
    cadena = str(n)

    # comprensión de lista para convertir cada carácter en entero
    # reversed() para invertir el orden
    lista_invertida = [int(digito) for digito in reversed(cadena)]

    # Devuelve la lista resultante
    return lista_invertida