def is_divisible(n, x, y):
    """
        Verifica si el número n es divisible por x y por y.

        Arg:
            n (int): Número principal.
            x (int): Primer divisor.
            y (int): Segundo divisor.

        Return: 
            bool: True si n es divisible por x y por y, False en caso contrario.

        Ejemplos:
            - is_divisible(3, 1, 3) → True
            - is_divisible(12, 2, 6) → True
            - is_divisible(100, 5, 3) → False
            - is_divisible(12, 7, 5) → False
    """
    # Usse usa  el operador módulo (%) para verificar divisibilidad
    return n % x == 0 and n % y == 0