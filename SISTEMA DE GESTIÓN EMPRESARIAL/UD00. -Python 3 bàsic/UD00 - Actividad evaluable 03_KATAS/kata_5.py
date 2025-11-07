def square_digits(num: int) -> int:
    """
        Eleva al cuadrado cada dígito de un número entero y concatena los resultados.

        Arg:
            num (int): Número entero positivo.

        Return:
            int: Número formado por la concatenación de los cuadrados de cada dígito.
    
        Ejemplos:
                - square_digits(9119) → 811181
                - square_digits(765) → 493625
    """
    # Convertimos el número a cadena para poder recorrer cada dígito
    num_str = str(num)

    # Lista para almacenar los cuadrados como cadenas
    squared_str_list = []

    # Recorremos cada carácter (dígito) en la cadena
    for digit in num_str:
        # Convertimos el carácter a entero, lo elevamos al cuadrado y lo convertimos de nuevo a cadena
        squared_digit = str(int(digit) ** 2)
        # Lo añadimos a la lista
        squared_str_list.append(squared_digit)

    # Unimos todos los cuadrados en una sola cadena
    result_str = ''.join(squared_str_list)

    # Convertimos el resultado final a entero y lo devolvemos
    return int(result_str)

