# mi_escuela/escuela.py

from typing import Dict
from .profesor import Profesor 
from .alumno import Alumno

class Escuela:
    """
        Representa y gestiona una escuela, sus profesores y sus alumnos.
    """
   
    def __init__(self, nombre: str, localidad: str, responsable: str):
        """
            Inicializa una nueva instancia de Escuela.

            Args:
                nombre (str): Nombre de la escuela.
                localidad (str): Localidad donde se encuentra la escuela.
                responsable (str): Nombre del responsable de la escuela.
        """
        self.nombre = nombre
        self.localidad = localidad
        self.responsable = responsable
        self.profesores: Dict[str, Profesor] = {} # Clave: DNI
        self.alumnos: Dict[str, Alumno] = {}     # CLAVE:  NIA

     # --- Métodos de Gestión de Profesores ---
    def agregar_profesor(self, profesor: Profesor) -> bool:
        """
            Agrega un profesor, usando su DNI como clave única.
        """
        dni = profesor.dni.upper() 

        if dni in self.profesores: 
            print(f"ERROR: El profesor con DNI {dni} ya existe.")
            return False
            
        
        self.profesores[dni] = profesor 
        print(f"INFO: Profesor {profesor.nombre} agregado con éxito (DNI: {dni}).")
        return True

    def eliminar_profesor(self, dni_profesor: str) -> bool:
        """
            Elimina un profesor por su DNI
        """
        dni_profesor = dni_profesor.upper()
        
        if dni_profesor not in self.profesores: 
            print(f"ERROR: Profesor con DNI: {dni_profesor} no encontrado.")
            return False

        del self.profesores[dni_profesor] 
        print(f"INFO: Profesor con DNI {dni_profesor} eliminado con éxito.") 
        return True

    def modificar_profesor(self, dni: str, nuevo_nombre: str = None, nuevo_tipo: str = None) -> bool:
        """
            Modifica los atributos (nombre y/o tipo) de un profesor por su DNI.
        """
        dni = dni.upper()
        if dni not in self.profesores: 
            print(f"ERROR: Profesor con DNI {dni} no encontrado para modificar.")
            return False

        profesor = self.profesores[dni]

        if nuevo_nombre:
            profesor.nombre = nuevo_nombre
        if nuevo_tipo:
            profesor.tipo = nuevo_tipo.upper()
        
        print(f"INFO: Profesor con DNI {dni} modificado con éxito.")
        return True

    def mostrar_profesores(self):
        """
            Muestra todos los profesores registrados en la escuela.
        """
        for p in self.profesores.values():
            print(p)


    # --- Métodos de Gestión de Alumnos ---
    
    def agregar_alumno(self, alumno: Alumno) -> bool: 
        """
        Agrega un alumno, usando su NIA como clave única.
        """
      
        nia = alumno.nia.upper() 

        if nia in self.alumnos: # se comprueba si ya existe por NIA
            print(f"ERROR: El alumno con NIA/DNI {nia} ya existe.")
            return False
            
        
        self.alumnos[nia] = alumno 
        print(f"INFO: Alumno {alumno.nombre} agregado con éxito (NIA: {nia}).")
        return True

    def eliminar_alumno(self, nia_alumno: str) -> bool:
        """
        Elimina un alumno por su NIA
        """
        nia_alumno = nia_alumno.upper()
        
        if nia_alumno not in self.alumnos: 
            print(f"ERROR: Alumno con NIA: {nia_alumno} no encontrado.")
            return False

        del self.alumnos[nia_alumno] 
        print(f"INFO: Alumno con NIA {nia_alumno} eliminado con éxito.") 
        return True

    def modificar_alumno(self, nia: str, nuevo_nombre: str = None, nuevo_curso: str = None, nuevo_profesor_dni: str = None) -> bool:
        """
            Modifica los atributos (nombre, curso y/o responsable) de un alumno por su NIA.
        """
        nia = nia.upper()
        if nia not in self.alumnos:
            print(f"ERROR: Alumno con NIA/DNI {nia} no encontrado para modificar.")
            return False

        alumno = self.alumnos[nia]

        if nuevo_nombre:
            alumno.nombre = nuevo_nombre
        if nuevo_curso:
            alumno.curso = nuevo_curso
    
        if nuevo_profesor_dni:
            nuevo_profesor_dni = nuevo_profesor_dni.upper()
        if nuevo_profesor_dni in self.profesores:
            alumno.profesor_responsable = self.profesores[nuevo_profesor_dni]
        else:
            print(f"ERROR: El profesor con DNI {nuevo_profesor_dni} no existe. Responsable no modificado.")
            return False 

        print(f"INFO: Alumno con NIA {nia} modificado con éxito.")
        return True



    def mostrar_alumnos(self):
        """
            Muestra todos los alumnos registrados en la escuela.
        """
        for a in self.alumnos.values():
            print(a)