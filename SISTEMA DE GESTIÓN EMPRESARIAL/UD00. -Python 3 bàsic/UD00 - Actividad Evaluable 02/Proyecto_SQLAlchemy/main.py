# main.py
import sys
import os

# Agrega la ruta del directorio actual (Proyecto_SQLAlchemy) al sys.path de Python.
# Esto asegura que pueda encontrar la carpeta 'mi_escuela' como un paquete.

current_dir = os.path.dirname(os.path.abspath(__file__))
if current_dir not in sys.path:
    sys.path.append(current_dir) 

# Importamos las herramientas de la base de datos y los modelos
from mi_escuela.database import Base, engine, SessionLocal
from mi_escuela.escuela import Escuela
from mi_escuela.profesor import Profesor
from mi_escuela.alumno import Alumno
from typing import Optional, List 

# ==============================================================================
# FUNCIONES DE AYUDA PARA LA GESTIÓN DE LA BD
# ==============================================================================

def crear_tablas():
    """Crea todas las tablas definidas por los modelos si no existen."""
    Base.metadata.create_all(bind=engine)

def get_escuela_actual(db) -> Optional[Escuela]:
    """
        Recupera la primera escuela registrada para usarla en la gestión
        Args:
            db: Sesión activa de la base de datos
        Returns:
            Escuela: La primera escuela encontrada o None si no hay ninguna
    """    
    escuela = db.query(Escuela).first()
    if not escuela:
        print("ADVERTENCIA: No se encontró ninguna escuela. Cree una primero.")
    return escuela

def get_profesor_por_dni(db, dni: str) -> Optional[Profesor]:
    """
        Busca un profesor por DNI.
        Args:
            db: Sesión activa de la base de datos
            dni (str): DNI del profesor a buscar    
        Returns:
            Profesor: El objeto Profesor encontrado o None si no existe
    """
    return db.query(Profesor).filter(Profesor.dni == dni.upper()).first()

# ==============================================================================
# LÓGICA DE GESTIÓN DE PROFESORES (CRUD)
# ==============================================================================

# CREATE (Crear) - 
def agregar_profesor(db, escuela_actual: Escuela):
    """
        Agrega un profesor.
        Args:
            db: Sesión activa de la base de datos
            escuela_actual (Escuela): La escuela a la que se asociará el profesor
        Returns:
            None 
    """
    print("\n--- Agregar Profesor ---")
    nombre = input("Nombre del profesor: ")
    dni = input("DNI del profesor: ").upper()
    tipo = input("Tipo (Ciencias/Letras/Mixto): ").capitalize()

    if get_profesor_por_dni(db, dni):
        print(f"ERROR: El profesor con DNI {dni} ya existe.")
        return

    nuevo_profesor = Profesor(nombre=nombre, dni=dni, tipo=tipo, escuela_asociada=escuela_actual)
    
    try:
        db.add(nuevo_profesor)
        db.commit()
        print(f"INFO: Profesor {nombre} agregado con éxito a la base de datos.")
    except Exception as e:
        db.rollback()
        print(f"ERROR al guardar el profesor: {e}")

# READ (Leer) - 
def mostrar_profesores(db, escuela_actual: Escuela):
    """
        Muestra todos los profesores de la escuela.
        Args:
            db: Sesión activa de la base de datos
            escuela_actual (Escuela): La escuela cuyos profesores se mostrarán  
        Returns:
            None
    """
    print("\n--- Listado de Profesores ---")
    profesores: List[Profesor] = db.query(Profesor).filter(
        Profesor.escuela_id == escuela_actual.id
    ).all()
    
    if not profesores:
        print("No hay profesores registrados en esta escuela.")
        return

    for p in profesores:
        print(p)

# UPDATE (Actualizar) - 
def modificar_profesor(db):
    """
        Modifica los atributos de un profesor por DNI.
        Args:
            db: Sesión activa de la base de datos
            Returns:
            None
    """
    print("\n--- Modificar Profesor ---")
    dni = input("DNI del profesor a modificar: ").upper()
    profesor = get_profesor_por_dni(db, dni)
    
    if not profesor:
        print(f"ERROR: Profesor con DNI {dni} no encontrado.")
        return

    try:
        print(f"Modificando a: {profesor.nombre} (Deje en blanco para no modificar)")
        
        nuevo_nombre = input(f"Nuevo nombre ({profesor.nombre}): ")
        if nuevo_nombre:
            profesor.nombre = nuevo_nombre
            
        nuevo_tipo = input(f"Nuevo tipo ({profesor.tipo}): ").capitalize()
        if nuevo_tipo:
            profesor.tipo = nuevo_tipo
        
        db.commit() # La sesión rastrea los cambios y los guarda
        print(f"INFO: Profesor {dni} modificado con éxito.")

    except Exception as e:
        db.rollback()
        print(f"ERROR al modificar el profesor: {e}")

# DELETE (Eliminar) - 
def eliminar_profesor(db):
    """
        Elimina un profesor por DNI y los alumnos asociados (si la BD lo permite).
        Args:
            db: Sesión activa de la base de datos   
        Returns:
            None
    """
    print("\n--- Eliminar Profesor ---")
    dni = input("DNI del profesor a eliminar: ").upper()
    profesor = get_profesor_por_dni(db, dni)
    
    if not profesor:
        print(f"ERROR: Profesor con DNI {dni} no encontrado.")
        return
    
    # Comprobar si tiene alumnos.
    if profesor.alumnos_a_cargo:
        print(f"ADVERTENCIA: El profesor tiene {len(profesor.alumnos_a_cargo)} alumnos asignados.")
        confirm = input("¿Confirmar eliminación? (S/N): ").upper()
        if confirm != 'S':
            print("Operación cancelada.")
            return

    try:
        db.delete(profesor)
        db.commit()
        print(f"INFO: Profesor {dni} eliminado con éxito.")
    except Exception as e:
        db.rollback()
        print(f"ERROR al eliminar el profesor: Asegúrese de que no tenga alumnos asignados si hay restricciones de FK. {e}")


def menu_profesores():
    """Submenú de gestión de profesores."""
    db = SessionLocal() 
    try:
        escuela = get_escuela_actual(db)
        if not escuela: return

        while True:
            print("\n--- Menú de Profesores ---")
            print("1. Agregar Profesor")
            print("2. Mostrar Profesores")
            print("3. Modificar Profesor")
            print("4. Eliminar Profesor")
            print("0. Volver al Menú Principal")
            opcion = input("Seleccione una opción: ")

            if opcion == '1':
                agregar_profesor(db, escuela)
            elif opcion == '2':
                mostrar_profesores(db, escuela)
            elif opcion == '3':
                modificar_profesor(db)
            elif opcion == '4':
                eliminar_profesor(db)
            elif opcion == '0':
                break
            else:
                print("Opción no válida.")
    finally:
        db.close() 

# ==============================================================================
# LÓGICA DE GESTIÓN DE ALUMNOS (CRUD)
# ==============================================================================

# Helper para buscar alumno por NIA
def get_alumno_por_nia(db, nia: str) -> Optional[Alumno]:
    """
        Busca un alumno por NIA.
        Args:
            db: Sesión activa de la base de datos   
            nia (str): NIA del alumno a buscar
            Returns:
            Alumno: El objeto Alumno encontrado o None si no existe
    """
    return db.query(Alumno).filter(Alumno.nia == nia.upper()).first()

# CREATE (Crear) - 
def agregar_alumno(db, escuela_actual: Escuela):
    """
        Agrega un alumno, asociándolo a un profesor.
        Args:
            db: Sesión activa de la base de datos   
            escuela_actual (Escuela): La escuela a la que se asociará el alumno 
        Returns:
            None
    """
    print("\n--- Agregar Alumno ---")
    nombre = input("Nombre del alumno: ")
    nia = input("NIA del alumno: ").upper()
    curso = input("Curso: ")
    dni_profesor = input("DNI del profesor responsable: ").upper()
    
    if get_alumno_por_nia(db, nia):
        print(f"ERROR: El alumno con NIA {nia} ya existe.")
        return
    
    profesor_responsable = get_profesor_por_dni(db, dni_profesor)
    if not profesor_responsable:
        print(f"ERROR: Profesor con DNI {dni_profesor} no encontrado.")
        return
        
    nuevo_alumno = Alumno(
        nombre=nombre, 
        nia=nia, 
        curso=curso, 
        profesor_responsable=profesor_responsable 
    )
    
    try:
        db.add(nuevo_alumno)
        db.commit()
        print(f"INFO: Alumno {nombre} agregado con éxito.")
    except Exception as e:
        db.rollback()
        print(f"ERROR al guardar el alumno: {e}")

# READ (Leer) - 
def mostrar_alumnos(db, escuela_actual: Escuela):
    """
        Muestra todos los alumnos de la escuela.
        Args:
            db: Sesión activa de la base de datos
            escuela_actual (Escuela): La escuela cuyos alumnos se mostrarán
        Returns:
            None 
    """
    print("\n--- Listado de Alumnos ---")
    
    alumnos: List[Alumno] = db.query(Alumno).join(Profesor).filter(
        Profesor.escuela_id == escuela_actual.id
    ).all()
    
    if not alumnos:
        print("No hay alumnos registrados en esta escuela.")
        return

    for a in alumnos:
        print(a)

# UPDATE (Actualizar) - ¡NUEVO!
def modificar_alumno(db):
    """
        Modifica los atributos de un alumno por NIA.
        Args:
            db: Sesión activa de la base de datos
        Returns:
            None
    """
    print("\n--- Modificar Alumno ---")
    nia = input("NIA del alumno a modificar: ").upper()
    alumno = get_alumno_por_nia(db, nia)
    
    if not alumno:
        print(f"ERROR: Alumno con NIA {nia} no encontrado.")
        return

    try:
        print(f"Modificando a: {alumno.nombre} (Deje en blanco para no modificar)")
        
        nuevo_nombre = input(f"Nuevo nombre ({alumno.nombre}): ")
        if nuevo_nombre:
            alumno.nombre = nuevo_nombre
            
        nuevo_curso = input(f"Nuevo curso ({alumno.curso}): ")
        if nuevo_curso:
            alumno.curso = nuevo_curso
            
        nuevo_profesor_dni = input(f"Nuevo DNI del responsable ({alumno.profesor_responsable.dni}): ").upper()
        if nuevo_profesor_dni:
            nuevo_profesor = get_profesor_por_dni(db, nuevo_profesor_dni)
            if nuevo_profesor:
                alumno.profesor_responsable = nuevo_profesor # Asigna la nueva relación
                print(f"INFO: Responsable cambiado a {nuevo_profesor.nombre}.")
            else:
                print(f"ADVERTENCIA: Profesor con DNI {nuevo_profesor_dni} no encontrado. Responsable no modificado.")

        db.commit()
        print(f"INFO: Alumno {nia} modificado con éxito.")

    except Exception as e:
        db.rollback()
        print(f"ERROR al modificar el alumno: {e}")

# DELETE (Eliminar) - 
def eliminar_alumno(db):
    """ORM: Elimina un alumno por NIA."""
    print("\n--- Eliminar Alumno ---")
    nia = input("NIA del alumno a eliminar: ").upper()
    alumno = get_alumno_por_nia(db, nia)
    
    if not alumno:
        print(f"ERROR: Alumno con NIA {nia} no encontrado.")
        return

    try:
        db.delete(alumno)
        db.commit()
        print(f"INFO: Alumno {nia} eliminado con éxito.")
    except Exception as e:
        db.rollback()
        print(f"ERROR al eliminar el alumno: {e}")

def menu_alumnos():
    """Submenú de gestión de alumnos."""
    db = SessionLocal() 
    try:
        escuela = get_escuela_actual(db)
        if not escuela: return
        
        while True:
            print("\n--- Menú de Alumnos ---")
            print("1. Agregar Alumno")
            print("2. Mostrar Alumnos")
            print("3. Modificar Alumno")
            print("4. Eliminar Alumno")
            print("0. Volver al Menú Principal")
            opcion = input("Seleccione una opción: ")

            if opcion == '1':
                mostrar_profesores(db, escuela) 
                agregar_alumno(db, escuela)
            elif opcion == '2':
                mostrar_alumnos(db, escuela)
            elif opcion == '3':
                modificar_alumno(db, escuela)
            elif opcion == '4':
                eliminar_alumno(db, escuela)
            elif opcion == '0':
                break
            else:
                print("Opción no válida.")
    finally:
        db.close() 

# ==============================================================================
# MENÚ PRINCIPAL Y PUNTO DE INICIO
# ==============================================================================

def crear_escuela_inicial(db):
    """Crea una escuela si no existe ninguna (necesaria para asociar profesores)."""
    if db.query(Escuela).first():
        return
        
    print("\n--- Primera Ejecución: Creación de Escuela ---")
    print("Se requiere crear una escuela para empezar la gestión.")
    nombre = input("Nombre de la escuela: ")
    localizacion = input("Localidad: ")
    director = input("Director responsable: ")
    
    nueva_escuela = Escuela(nombre=nombre, localizacion=localizacion, director=director)
    
    try:
        db.add(nueva_escuela)
        db.commit()
        print(f"INFO: Escuela '{nombre}' creada con éxito.")
    except Exception as e:
        db.rollback()
        print(f"ERROR al crear la escuela: {e}")

def menu_principal():
    """El loop principal del programa."""
    
    #Configuración inicial
    crear_tablas() 
    
    # Abrir sesión para chequear/crear la escuela inicial
    db_setup = SessionLocal()
    try:
        crear_escuela_inicial(db_setup)
    finally:
        db_setup.close()

    while True:
        print("\n=== Sistema de Gestión Escolar ===")
        print("1. Gestión de Profesores")
        print("2. Gestión de Alumnos")
        print("0. Salir")
        opcion = input("Seleccione una opción: ")

        if opcion == '1':
            menu_profesores() 
        elif opcion == '2':
            menu_alumnos()
        elif opcion == '0':
            print("Saliendo del programa. ¡Datos guardados en escuela.db!")
            break
        else:
            print("Opción no válida.")


if __name__ == "__main__":
    menu_principal()