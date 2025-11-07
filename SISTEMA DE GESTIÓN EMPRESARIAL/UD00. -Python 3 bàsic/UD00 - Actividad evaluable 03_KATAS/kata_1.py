def remove_char(s):
    """
        Elimina el primer y el último carácter de una cadena de texto.
    
    Arg:
        s (str): Cadena de entrada. Se garantiza que tiene al menos 2 caracteres.
    
    Returns:
        str: Cadena sin el primer y el último carácter. Si la longitud es 2, retorna cadena vacía.
    """

    # Se verigica si la longitud de la cadena es exactamente 2
    if len(s) == 2:
        # Si tiene solo dos caracteres, se devuelve una cadena vacía
        return ''
    
    # slicing para eliminar el primer y último carácter
    # s[1:-1] toma desde el segundo carácter (índice 1) hasta el penúltimo (índice -1 excluido)
    return s[1:-1]
