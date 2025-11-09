import re # módulo de expresiones regulares

def numeroPatrones(texto):
    '''
        Cuenta el número total de ocurrencias de los patrones "00", "101", "ABC" y "HO" en el texto dado,
        incluyendo coincidencias superpuestas y sin distinguir entre mayúsculas y minúsculas.
        Args:
            texto (str): La cadena de texto en la que se buscarán los patrones.
        Returns:
            int: El número total de ocurrencias encontradas de los patrones especificados.
    '''
    # Convertimos el texto a mayúsculas para ignorar diferencias de mayúsculas/minúsculas
    texto = texto.upper()

    # Lista de patrones a buscar
    patrones = ["00", "101", "ABC", "HO"]

    total = 0

    # Para cada patrón, usamos una expresión regular con lookahead para encontrar coincidencias superpuestas
    for patron in patrones:
        # (?=...) es una construcción de lookahead que permite encontrar posiciones donde comienza el patrón sin consumir caracteres
        coincidencias = re.findall(f"(?={patron})", texto)
        total += len(coincidencias)

    return total

# --- Programa principal ---
cadena = input("Introduce una cadena de texto: ")
resultado = numeroPatrones(cadena)
print("Número total de patrones encontrados:", resultado)
