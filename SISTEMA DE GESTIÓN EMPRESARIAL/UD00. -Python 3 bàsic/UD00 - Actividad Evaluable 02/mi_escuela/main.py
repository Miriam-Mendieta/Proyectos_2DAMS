# mi_escuela/main.py

from typing import Dict
import os
import sys

from .escuela import Escuela
from .profesor import Profesor
from .alumno import Alumno


# Función auxiliar para limpiar la consola
def limpiar_pantalla(menu_name: str):
    """Limpia la consola e imprime el nombre del menú activo."""
    os.system('cls' if os.name == 'nt' else 'clear')
    print(f"--- {menu_name} ---")

# Lista para almacenar todas las escuelas creadas
escuelas = [] 

# --- Lógica del Menú Principal ---
def menu_principal(escuela_actual: Escuela = None):
    while True:
        limpiar_pantalla("Menú Principal")
        
        if escuela_actual:
            print(f"ESCUELA ACTUAL: {escuela_actual.nombre} | Profesores: {len(escuela_actual.profesores)} | Alumnos: {len(escuela_actual.alumnos)}\n")
            print("--- Menú de Gestión de Escuela ---")
            print("1. Gestión de Profesores")
            print("2. Gestión de Alumnos")
            print("3. Mostrar Información Completa de la Escuela")
            print("4. Listar Escuelas Creadas")
            print("---")
            print("9. Crear/Cambiar a otra Escuela")
            print("0. Salir del Programa")
        else: 
            # Menú si no hay escuela activa
            print("Aún no hay una escuela activa.")
            print("1. Crear una nueva Escuela")
            print("0. Salir del Programa")
        
        opcion = input("\nSelecciona una opción: ")
        
        if escuela_actual:
            if opcion == '1':
                menu_profesores(escuela_actual)
            elif opcion == '2':
                menu_alumnos(escuela_actual)
            elif opcion == '3':
                mostrar_informacion_escuela(escuela_actual)
            elif opcion == '4':
                nueva_escuela = listar_escuelas()  # Llama a la función para listar escuelas
                if nueva_escuela:
                    escuela_actual = nueva_escuela  # Cambia a la nueva escuela seleccionada
            elif opcion == '9':
                escuela_actual = crear_o_cambiar_escuela()
            elif opcion == '0':
                print("\nSaliendo del programa. ¡Hasta pronto!")
                sys.exit()
            else:
                input("Opción no válida. Presiona Enter para continuar...")
        else:
            if opcion == '1':
                escuela_actual = crear_o_cambiar_escuela()
            elif opcion == '0':
                print("\nSaliendo del programa. ¡Hasta pronto!")
                sys.exit()
            else:
                input("Opción no válida. Presiona Enter para continuar...")

# --- Lógica de Creación de Escuela ---
def crear_o_cambiar_escuela():
    """
    Solicita los datos para crear una nueva instancia de Escuela.
    """
    print("\n--- Creación de Nueva Escuela ---")
    nombre = input("Nombre de la Escuela: ")
    localidad = input("Localidad: ")
    responsable = input("Nombre del Director/Responsable: ")
    
    nueva_escuela = Escuela(nombre, localidad, responsable)
    escuelas.append(nueva_escuela)  # Agrega la nueva escuela a la lista
    print(f"\n¡Escuela '{nombre}' creada con éxito!")
    input("Presiona Enter para ir al menú principal...")
    return nueva_escuela

# --- Función para Listar Escuelas ---
def listar_escuelas():
    """
    Muestra un listado de todas las escuelas creadas y permite seleccionar una escuela.
    """
    print("\n--- Listado de Escuelas ---")
    if not escuelas:
        print("No hay escuelas registradas.")
        return
    
    for i, escuela in enumerate(escuelas):
        print(f"{i + 1}. {escuela.nombre} | Localidad: {escuela.localidad} | Responsable: {escuela.responsable}")

    # Permitir al usuario seleccionar una escuela
    seleccion = input("\nSelecciona el número de la escuela a la que deseas cambiar (o presiona Enter para volver): ")

    if seleccion.isdigit() and 1 <= int(seleccion) <= len(escuelas):
        escuela_seleccionada = escuelas[int(seleccion) - 1]
        print(f"\nCambiando a la escuela: {escuela_seleccionada.nombre}")
        return escuela_seleccionada  # Devuelve la escuela seleccionada
    else:
        print("Selección no válida. Regresando al menú principal...")
        return None  # Regresa None si no se elige correctamente

# --- Lógicas de Gestión de Profesores ---

def menu_profesores(escuela: Escuela):
    """
    Muestra el menú de gestión de profesores.
    """
    while True:
        limpiar_pantalla("Gestión de Profesores") 
        print(f"GESTIÓN DE PROFESORES en {escuela.nombre}")
        print("1. Añadir Profesor")
        print("2. Eliminar Profesor")
        print("3. Listar todos los Profesores")
        print("4. Modificar Profesor") 
        print("0. Volver al Menú Principal")
        
        opcion = input("\nSelecciona una opción: ")
        
        if opcion == '1':
            agregar_profesor(escuela)
        elif opcion == '2':
            eliminar_profesor(escuela)
        elif opcion == '3':
            listar_profesores(escuela)
        elif opcion == '4':
            modificar_profesor(escuela)
        elif opcion == '0':
            return
        else:
            input("Opción no válida. Presiona Enter para continuar...")

def agregar_profesor(escuela: Escuela):
    """
    Solicita los datos y añade un objeto Profesor.
    """
    print("\n--- Añadir Nuevo Profesor ---")
    nombre = input("Nombre del profesor: ")
    # DNI como clave única
    dni = input("DNI del profesor (Clave Única): ").upper() 
    while True:
        tipo = input("Tipo (Ciencias, Letras, Mixto): ").capitalize()
        if tipo in ['Ciencias', 'Letras', 'Mixto']:
            break
        else:
            print("Tipo no válido. Debe ser 'Ciencias', 'Letras' o 'Mixto'.")

    nuevo_profesor = Profesor(nombre, dni, tipo) 
    escuela.agregar_profesor(nuevo_profesor)
    input("Presiona Enter para continuar...")

def eliminar_profesor(escuela: Escuela):
    """
    Solicita el DNI y elimina un objeto Profesor.
    """
    print("\n--- Eliminar Profesor ---")
    dni = input("DNI del profesor a eliminar: ").upper()
    escuela.eliminar_profesor(dni) 
    input("Presiona Enter para continuar...")

def modificar_profesor(escuela: Escuela):
    """
    Solicita el DNI del profesor y los datos a modificar.
    """
    print("\n--- Modificar Profesor ---")
    dni = input("DNI del profesor a modificar: ").upper()
    
    if dni not in escuela.profesores:
        print("ERROR: Profesor no encontrado. Volviendo al menú.")
        input("Presiona Enter para continuar...")
        return
    
    profesor_actual = escuela.profesores[dni]
    print(f"\nModificando a {profesor_actual.nombre} (Deje en blanco para no modificar)")
    nuevo_nombre = input("Nuevo Nombre: ")
    nuevo_tipo = input(f"Nuevo Tipo (Actual: {profesor_actual.tipo}): ")
    
    # Llama al método de Escuela
    escuela.modificar_profesor(dni, nuevo_nombre or None, nuevo_tipo or None)
    
    input("Presiona Enter para continuar...")

def listar_profesores(escuela: Escuela):
    """
    Muestra la lista de todos los profesores.
    """
    print(f"\n--- Listado de Profesores ({len(escuela.profesores)}) en {escuela.nombre} ---")
    if not escuela.profesores:
        print("No hay profesores registrados.")
    else:
        # .values() para obtener los objetos Profesor
        for p in escuela.profesores.values():
            print(f"- {p}")
    input("\nPresiona Enter para continuar...")

# --- Lógicas de Gestión de Alumnos ---

def menu_alumnos(escuela: Escuela):
    """
    Muestra el menú de gestión de alumnos.
    """
    while True:
        limpiar_pantalla("Gestión de Alumnos")
        print(f"GESTIÓN DE ALUMNOS en {escuela.nombre}")
        print("1. Añadir Alumno")
        print("2. Eliminar Alumno")
        print("3. Listar todos los Alumnos")
        print("4. Modificar Alumno")
        print("0. Volver al Menú Principal")
        
        opcion = input("\nSelecciona una opción: ")
        
        if opcion == '1':
            agregar_alumno(escuela)
        elif opcion == '2':
            eliminar_alumno(escuela)
        elif opcion == '3':
            listar_alumnos(escuela)
        elif opcion == '4':
            modificar_alumno(escuela)
        elif opcion == '0':
            return
        else:
            input("Opción no válida. Presiona Enter para continuar...")

def agregar_alumno(escuela: Escuela):
    """
    Solicita los datos del alumno (incluyendo NIA y profesor responsable) 
    y añade un objeto Alumno a la escuela.
    """
    print("\n--- Añadir Nuevo Alumno ---")
    
    if not escuela.profesores:
        print("ERROR: Debes añadir profesores antes de poder asignar un responsable a un alumno.")
        input("Presiona Enter para continuar...")
        return

    nombre_alumno = input("Nombre del alumno: ")
    nia_alumno = input("NIA del alumno (Clave Única): ").upper()
    curso = input("Curso del alumno: ")
    
    # Asignación de profesor responsable
    print("\nProfesores disponibles (Referencia por DNI):")
    for dni, prof in escuela.profesores.items():
        print(f"  [{dni}] {prof.nombre} ({prof.tipo})")
        
    dni_responsable = input("DNI del profesor responsable: ").upper()
    
    if dni_responsable in escuela.profesores:
        profesor_obj = escuela.profesores[dni_responsable]
        
        nuevo_alumno = Alumno(nombre_alumno, nia_alumno, curso, profesor_obj)
        
        escuela.agregar_alumno(nuevo_alumno)
    else:
        print(f"ERROR: El profesor con DNI '{dni_responsable}' no existe. Alumno no añadido.")
        
    input("Presiona Enter para continuar...")

def eliminar_alumno(escuela: Escuela):
    """
    Solicita el NIA y elimina un objeto Alumno.
    """
    print("\n--- Eliminar Alumno ---")
    nia = input("NIA del alumno a eliminar: ").upper()
    escuela.eliminar_alumno(nia)
    input("Presiona Enter para continuar...")

def modificar_alumno(escuela: Escuela):
    print("\n--- Modificar Alumno ---")
    nia = input("NIA del alumno a modificar: ").upper()

    if nia not in escuela.alumnos:
        print(f"ERROR: Alumno con NIA/DNI {nia} no encontrado.")
        return

    alumno_actual = escuela.alumnos[nia]
    print(f"Modificando a {alumno_actual.nombre} (Deje en blanco para no modificar)")

    nuevo_nombre = input(f"Nuevo Nombre (Actual: {alumno_actual.nombre}): ")
    nuevo_curso = input(f"Nuevo Curso (Actual: {alumno_actual.curso}): ")
    nuevo_profesor_dni = input("Nuevo DNI/NIE del profesor responsable (Deje en blanco para no modificar): ")

    # Llamada a la función de la clase Escuela
    escuela.modificar_alumno(
        nia=nia,
        nuevo_nombre=nuevo_nombre or None,
        nuevo_curso=nuevo_curso or None,
        nuevo_profesor_dni=nuevo_profesor_dni or None
    )


def listar_alumnos(escuela: Escuela):
    print(f"\n--- Listado de Alumnos ({len(escuela.alumnos)}) en {escuela.nombre} ---")
    if escuela.alumnos:
        for alum in escuela.alumnos.values():
            print(f"- Nombre: {alum.nombre}, NIA: {alum.nia}, Curso: {alum.curso}, Responsable: {alum.profesor_responsable.nombre}")
    else:
        print("No hay alumnos registrados.")


# --- Función para mostrar información completa ---

def mostrar_informacion_escuela(escuela: Escuela):
    """
    Muestra un resumen completo de la escuela.
    """
    limpiar_pantalla("Información Completa de la Escuela")
    print("========================================")
    print(f"DATOS DE LA ESCUELA: {escuela.nombre}")
    print("========================================")
    print(f"Localidad: {escuela.localidad}")
    print(f"Director/Responsable: {escuela.responsable}")
    print("\nPROFESORES:")
    listar_profesores(escuela)
    print("\nALUMNOS:")
    listar_alumnos(escuela)
    
    input("\nPresiona Enter para volver al menú principal...")


# --- Inicialización del Programa ---

if __name__ == "__main__":
    menu_principal()

    #en consola python -m mi_escuela.main
