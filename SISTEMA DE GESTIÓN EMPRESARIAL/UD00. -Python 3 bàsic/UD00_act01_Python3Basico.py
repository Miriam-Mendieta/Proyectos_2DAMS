import copy

#---------------------------------- ACTIVIDAD 01 ----------------------------------#
#Clonar una lista 
#Método de Slicing ([:])-----------------------------------------

original = [1, 2, 3, 4]
clonada = original[:]  # Copia por slicing
# se imprimen los  resultados
print(f"Original: {original}")   # Imprime la lista original.
print("Lista clonada:", clonada) # Imprime la lista clonada inicial.
print("..............................................")

# Se modifica clonada para probar la independencia
clonada.append(40)# Modifica solo la lista 'clonada' al añadir el elemento 40.
print(f"Original: {original}")# Imprime 'original'. Demuestra que NO fue modificada.
print(f"Lista clonada modificada: {clonada}")# Imprime 'clonada' y se muestra el nuevo elemento.
print()

#Método .copy()----------------------------------------------------

lista_original = ['a', 'b', 'c']

# Clonación usando el método .copy()
lista_clonada = lista_original.copy()

#Modificar clonada
lista_clonada[0] = 'z'

# se imprimen resultados
print(f"Lista Original: {lista_original}")
print(f"Lista Clonada: {lista_clonada}")
print()

#Método list() (constructor)------------------------------------------
lista_original = [5, 15, 25]

#Clonación usando la función list()
lista_constructor = list(lista_original)# Se usa la función constructora list() para crear una nueva lista a partir de 'lista_original'.

#Verificación
lista_constructor.pop()  # Elimina el último elemento (25) de 'lista_constructor'.

#se imprimen resultados
print(f"Lista Original: {lista_original}")
print(f"Lista por Constructor: {lista_constructor}")
print()

#Copias superficiales en listas anidadas--------------------------------------
lista_original = [1, 2, [3, 4]]#lista anidada: contiene tres elementos: dos enteros (1, 2) y una lista interna [3, 4].
lista_copia = lista_original.copy()#Se realiza una copia superficial usando .copy() para duplicar lista_original.NO copia la sublista. En su lugar, copia la referencia (la dirección de memoria) donde se encuen-tra esa sublista.

lista_copia[2][0] = 999 #se accede al primer elemento de la sublista ([3, 4]) dentro de lista_copia y lo cambiamos a 999.

print("Original:", lista_original)  # [1, 2, [999, 4]]
print("Copia:", lista_copia)        # [1, 2, [999, 4]]
print()

#---------------------------------- ACTIVIDAD 02 ----------------------------------#


# 1. Lista original con una lista anidada 
lista_original = [1, 2, [3, 4]]
print(f"Original: {lista_original} (ID: {id(lista_original)})")

# ----------------------------------------------------
# 2. Copia Profunda 
# ----------------------------------------------------
# Creamos una copia completamente independiente.
lista_profunda = copy.deepcopy(lista_original)
print(f"Profunda: {lista_profunda} (ID: {id(lista_profunda)})")

# Modificamos el elemento ANIDADO en la copia profunda
lista_profunda[2][0] = 999  # Cambiamos el '3' por '999' en la sublista

print("\n--- Después de modificar la Copia Profunda ---")
print(f"Profunda: {lista_profunda}")
print(f"Original: {lista_original}")

print("\n" + "="*50 + "\n")

# ----------------------------------------------------
# 3. Copia Superficial (Para ver la diferncia)
# ----------------------------------------------------
# Usamos un slice para una copia superficial
lista_superficial = lista_original[:]
print(f"Superficial: {lista_superficial}")

# Modificamos el elemento ANIDADO en la copia superficial
lista_superficial[2][0] = 777  # Cambiamos el '3' por '777' en la sublista

print("\n--- Después de modificar la Copia Superficial ---")
print(f"Superficial: {lista_superficial}")
print(f"Original: {lista_original}")
print()

#---------------------------------- ACTIVIDAD 03 ----------------------------------#
#Agregar un Elemento a una Lista: 

#append()
# lista inicial 
mi_lista = ["manzana", "banana", "cereza"]

# se imprime los elementos y su longitud
print(f"Lista original: {mi_lista}")
print(f"Elementos: {len(mi_lista)}") #longitud de la lista

nuevo_elemento = "uva"
mi_lista.append(nuevo_elemento) #se añade un nuevo elemento al final y se imprime
print(mi_lista)
print(f"Elementos: {len(mi_lista)}") #longitud de la lista despúes de append()

print()

#insert()
print()

#extend()
# Lista actual (la que será extendida)
lista_principal = [10, 20, 30]
print(f"Lista principal (antes): {lista_principal}")
#  Iterable con los elementos a añadir)
elementos_a_añadir = [40, 50, 60]
print(elementos_a_añadir)
lista_principal.extend(elementos_a_añadir)# aplana o fusiona los contenidos de un iterable dentro de la lista actual.
print(f"Lista principal (después): {lista_principal}")
print()

#con el Operador +
# listas que queremos combinar
lista_animales = ["perro", "gato"]
lista_aves = ["loro", "canario"]
lista_peces = ["pez dorado"]

#Se usa el operador + para combinarlas, se  crea una nueva lista 'lista_completa'
lista_completa = lista_animales + lista_aves + lista_peces

#  resultado
print(f"Lista 1 (Animales): {lista_animales}")
print(f"Lista 2 (Aves): {lista_aves}")
print(f"Lista 3 (Peces): {lista_peces}")
print("\n--- Después de usar el operador + ---")
print(f"Lista Combinada: {lista_completa}")
print()

mi_lista = ['A']
nueva_lista = mi_lista + ['B', 'C']
print(nueva_lista)  

print()



#---------------------------------- ACTIVIDAD 04 ----------------------------------#
#---------------------------------- ACTIVIDAD 05 ----------------------------------#
#---------------------------------- ACTIVIDAD 06 ----------------------------------#

