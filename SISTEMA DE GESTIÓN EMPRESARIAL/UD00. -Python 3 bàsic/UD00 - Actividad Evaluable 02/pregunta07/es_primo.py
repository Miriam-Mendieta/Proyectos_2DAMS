#esPrimo.py
import math

def esPrimo(numero):
    """
        Comprueba si un número entero es primo.

        Un número primo es un número natural mayor que 1 que tiene
        únicamente dos divisores distintos y positivos: él mismo y el 1.
        Args:
            n (int): Número a comprobar.    
        Returns:
            bool: True si el número es primo, False en caso contrario.

        >>> esPrimo(7)
        True
        >>> esPrimo(1)
        False
        >>> esPrimo(4)
        False
        >>> esPrimo(11)
        True
        >>> esPrimo(12)
        False
        >>> esPrimo(2)
        True
    """
    if numero <= 1:
        return False
    #  divisores desde 2 hasta la raíz cuadrada del número
    for i in range(2, int(math.sqrt(numero)) + 1):
        if numero % i == 0:
            return False
    return True

if __name__ == "__main__":
    import doctest
    doctest.testmod()