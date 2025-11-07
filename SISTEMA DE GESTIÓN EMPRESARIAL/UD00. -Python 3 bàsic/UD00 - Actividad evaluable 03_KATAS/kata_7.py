def invert(lst):
    """
        Devuelve el inverso aditivo de cada número en la lista.

        Arg
            lst (int): Lista de números enteros.
  
        Return:
            list (int): Nueva lista donde cada número ha sido invertido (positivo a negativo y viceversa).

        Ejemplos:
            - invert([1, 2, 3, 4, 5]) → [-1, -2, -3, -4, -5]
            - invert([1, -2, 3, -4, 5]) → [-1, 2, -3, 4, -5]
            - invert([]) → []
    """
    # comprensión de listas para crear una nueva lista
    # Se multiplica cada elemento por -1 para invertir su signo
    return [-x for x in lst]