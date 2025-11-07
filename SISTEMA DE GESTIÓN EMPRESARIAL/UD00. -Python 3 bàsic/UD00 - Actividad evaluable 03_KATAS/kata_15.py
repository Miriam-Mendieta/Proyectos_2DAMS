def string_to_array(s):
    """
        Divide una cadena de texto en palabras y las convierte en una lista.

        Arg:
            s (str): Cadena de texto con palabras separadas por espacios.

        Return:
            list: Lista de palabras extraídas de la cadena.
            Si la cadena está vacía, devolvemos ['']

        Ejemplo:
            - string_to_array("Robin Singh") → ["Robin", "Singh"]
    """
    #  método split() divide la cadena por espacios, si la cadena esta vacia devuelve ['']
    return s.split() if s else ['']