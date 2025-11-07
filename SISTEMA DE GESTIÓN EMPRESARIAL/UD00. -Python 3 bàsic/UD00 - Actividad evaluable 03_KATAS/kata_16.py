def get_middle(s):
    """
        Devuelve el carácter central de una cadena si su longitud es impar,
        o los dos caracteres centrales si es par.

        Arg:
            s (str): Cadena de texto no vacía.

        Return:
            str: Carácter(es) centrales de la cadena.
    """
    longitud = len(s)
    mitad = longitud // 2

    # Si la longitud es par, devuelve los dos caracteres centrales
    if longitud % 2 == 0:
        return s[mitad - 1 : mitad + 1]
    else:
        # Si es impar, devuelve solo el carácter central
        return s[mitad]
