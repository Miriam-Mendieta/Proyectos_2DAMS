def points(games):
    """
        Calcula el total de puntos obtenidos por un equipo en el campeonato
        usando una expresión compacta con sum() y comprensión de listas.
        Arg:
            games (list str): Lista de resultados de los partidos en formato "x:y".
        Return:
            int: Total de puntos obtenidos.
    """
    return sum(
        3 if x > y else 1 if x == y else 0
        for x, y in (map(int, game.split(':')) for game in games)
    )