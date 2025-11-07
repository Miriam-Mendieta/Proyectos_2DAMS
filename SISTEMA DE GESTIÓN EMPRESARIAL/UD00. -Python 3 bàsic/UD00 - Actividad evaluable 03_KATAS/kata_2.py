def find_short(s):
    """
        Encuentra la longitud de la palabra más corta en una cadena de texto.

        Arg:
            s (str): Cadena de entrada que contiene una o más palabras separadas por espacios.

        Returns:
            int: Longitud de la palabra más corta.
    """

    # la cadena se divide en una lista de palabras usando el espacio como separador
    palabras = s.split()

    # función min() con una expresión que calcula la longitud de cada palabra
    l = min(len(palabra) for palabra in palabras)
    
    return l # l: longitud de palabra más corta
