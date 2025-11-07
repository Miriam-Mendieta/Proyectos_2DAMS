def basic_op(operator, value1, value2):
    """
    Realiza una operación matemática básica entre dos valores.
    Captura errores como división por cero o operador inválido.
    Arg:
        operator (str): Operador matemático ('+', '-', '*', '/').
        value1 (float o int): Primer operando.
        value2 (float o int): Segundo operando.

    Return:
        float o int: Resultado de aplicar la operación entre value1 y value2.

    Raises:
        ValueError: Si el operador no es válido.
        ZeroDivisionError: Si se intenta dividir por cero.
    Ejemplos:
        - basic_op('+', 4, 7) → 11
        - basic_op('-', 15, 18) → -3
        - basic_op('*', 5, 5) → 25
        - basic_op('/', 49, 7) → 7.0
    """
    try:
        operaciones = {
            '+': lambda x, y: x + y,
            '-': lambda x, y: x - y,
            '*': lambda x, y: x * y,
            '/': lambda x, y: x / y
        }

        if operator not in operaciones:
            raise ValueError("Operador no válido. Usa '+', '-', '*' o '/'.")

        return operaciones[operator](value1, value2)

    except ZeroDivisionError:
        return "Error: No se puede dividir por cero."
    except ValueError as ve:
        return f"Error: {ve}"