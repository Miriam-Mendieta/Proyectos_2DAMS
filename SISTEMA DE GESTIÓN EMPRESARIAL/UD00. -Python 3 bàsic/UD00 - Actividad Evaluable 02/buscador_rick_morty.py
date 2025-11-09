import sys
import requests

def obtener_personajes_por_especie(especie):
    '''
    Obtiene los nombres de los personajes de Rick y Morty
    que pertenecen a una especie específica.

    Args:
        especie (str): La especie de los personajes a buscar.

    Returns:
        list: Lista de nombres de personajes.
    Raises:
        requests.exceptions.RequestException: Si ocurre un error en la solicitud HTTP.
    '''
    url = f"https://rickandmortyapi.com/api/character/?species={especie}"
    personajes = []

    try:
        respuesta = requests.get(url)
        respuesta.raise_for_status()
        data = respuesta.json()

        if 'results' in data:
            for personaje in data['results']:
                personajes.append(personaje['name'])

    except requests.exceptions.RequestException as e:
        print(f"Error al realizar la solicitud: {e}")

    return personajes

def main():
    """
    Función principal que solicita la especie al usuario e inicia la búsqueda.
    """
    print()
    print("----------------------------------------------------------------------")
    print("  Bienvenido al Buscador de Personajes de Rick and Morty por Especie  ")
    print("----------------------------------------------------------------------")

    especie_busqueda = input("Ingresa la especie de personaje que deseas buscar (ej: Human, Alien, Mythological Creature): ").strip()

    if not especie_busqueda:
        print("Debes ingresar una especie para realizar la búsqueda. Saliendo del programa.")
        sys.exit(1)

    personajes = obtener_personajes_por_especie(especie_busqueda)

    if personajes:
        print(f"\nPersonajes de la especie '{especie_busqueda}':")
        for nombre in personajes:
            print(f"- {nombre}")
    else:
        print(f"No se encontraron personajes de la especie '{especie_busqueda}'.")

    print("\n----------------------------------------------------------------------")
    print("Búsqueda finalizada.")

if __name__ == "__main__":
    main()
