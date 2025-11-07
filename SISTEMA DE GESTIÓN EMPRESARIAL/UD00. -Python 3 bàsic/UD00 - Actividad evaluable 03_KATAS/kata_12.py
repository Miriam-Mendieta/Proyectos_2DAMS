def no_space(x):
    """
        Elimina todos los espacios de una cadena dada.

        Arg:
            x (str): Cadena de texto que puede contener espacios.

        Return:
            str: Nueva cadena sin espacios.

        Ejemplos:
            - no_space("8 j 8   mBliB8g  imjB8B8  jl  B") → "8j8mBliB8gimjB8B8jlB"
            - no_space("abc def") → "abcdef"
            - no_space("  a b c  ") → "abc"
    """
    # split() divide la cadena en palabras (elimina todos los espacios)
    # join() las une sin espacios entre ellas
    return ''.join(x.split())