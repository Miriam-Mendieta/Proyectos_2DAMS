# Programa principal
"""
Bloque que permite ejecutar código de prueba o ejemplos solo cuando el archivo se ejecuta directamente, 
evitando su ejecución al importar como módulo.
"""
if __name__ == "__main__":
    # Sumar dos números
    resultado_suma = sumar(3, 5)
    print("La suma de 3 y 5 es:", resultado_suma)

    # Modificar la lista original
    lista_original = [1, 2, 3, 4]
    print("Lista antes de doblar valores:", lista_original)
    doblar_valores(lista_original)
    print("Lista después de doblar valores:", lista_original)

    # Crear una nueva lista con valores doblados
    lista_a_doblar = [1, 2, 3, 4]
    nueva_lista = duplicar_valores(lista_a_doblar)
    print("Lista original:", lista_a_doblar)
    print("Nueva lista con valores doblados:", nueva_lista)
