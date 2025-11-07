def fake_bin(x):
    """
        Reemplaza cada dígito en la cadena:
            - Si el dígito es menor que 5 → se convierte en '0'
            - Si el dígito es 5 o mayor → se convierte en '1'

        Arg:
            x (str): Cadena de dígitos (por ejemplo, "45385593107843568")

        Return:
            str: Cadena transformada con '0's y '1's según la regla.
    """
    resultado = ''  # Inicializamos la cadena resultado

    for caracter in x:
        # Convertimos el carácter a entero para poder compararlo
        if int(caracter) < 5:
            resultado += '0'
        else:
            resultado += '1'

    return resultado  # Devolvemos la cadena transformada
