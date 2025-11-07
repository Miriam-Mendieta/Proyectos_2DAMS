def get_quarter(month: int) -> int:
    """
    Devuelve el trimestre del año al que pertenece un mes dado.

    Arg:
        month (int): Número entero entre 1 y 12 que representa el mes del año.

    Returns:
        int: Número entero entre 1 y 4 que indica el trimestre correspondiente.
            - 1: Primer trimestre (enero a marzo)
            - 2: Segundo trimestre (abril a junio)
            - 3: Tercer trimestre (julio a septiembre)
            - 4: Cuarto trimestre (octubre a diciembre)

    Raises:
            ValueError: Si el mes no está en el rango de 1 a 12.
    """
    if month < 1 or month > 12:
        raise ValueError("El mes debe estar entre 1 y 12")

    #primer trimestre: meses 1, 2, 3
    if month <= 3:
        return 1
    #segundo trimestre: meses 4, 5, 6
    elif month <= 6:
        return 2
    #tercer trimestre: meses 7, 8, 9
    elif month <= 9:
        return 3
        
    #cuarto trimestre: meses 10, 11, 12
    else:
        return 4