# es_palindromo.py

def esPalindromo(numero):
    """
        Devuelve True si el número es palíndromo (capicúa).
        Args:
            n (int): Número a comprobar.    
        Returns:
            bool: True si el número es palíndromo, False en caso contrario.

        >>> esPalindromo(121)
        True
        >>> esPalindromo(123)
        False
        >>> esPalindromo(11)
        True
        >>> esPalindromo(5)
        True
        >>> esPalindromo(1221)
        True
    """
    # Convertimos el número a cadena (string)
    cadena_numero = str(numero)
    # Comparamos la cadena original con su inversa
    return cadena_numero == cadena_numero[::-1]

if __name__ == "__main__":
    import doctest
    doctest.testmod()