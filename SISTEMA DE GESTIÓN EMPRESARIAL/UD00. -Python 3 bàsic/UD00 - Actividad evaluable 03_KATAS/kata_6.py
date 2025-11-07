import math

def litres(time: float) -> int:
    """
        Calcula cuántos litros de agua beberá Nathan en función del tiempo que ha estado montando en bicicleta.

        Arg:
            time (float): Tiempo en horas que Nathan ha estado montando en bicicleta.

        Return:
            int: Litros de agua que beberá, redondeado hacia abajo.
            Se calcula como 0.5 litros por cada hora de ciclismo.
    
        Ejemplos:
            - litres(3) → 1
            - litres(6.7) → 3
            - litres(11.8) → 5
    """
    # Se multiplica el tiempo por 0.5 y redondeamos hacia abajo
    return math.floor(time * 0.5) #La función math.floor(x) forma parte del módulo math 
                                    # y devuelve el mayor entero menor o igual a x.