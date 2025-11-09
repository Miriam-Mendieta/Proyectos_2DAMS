# mi_escuela/profesor.py
from typing import Dict
class Profesor:
    """
    Clase que representa un profesor.

    Atributos:
        nombre (str): El nombre del profesor.
        dni (str): Identificador único (DNI) del profesor.
        tipo (str): El tipo de profesor (ciencias, letras, mixto).
    """

    #constructor
    def __init__(self, nombre,dni,tipo): #self es una referencia a la instancia actual de la clase.
        """
        Inicializa un objeto de tipo Profesor.

        Args:
            nombre (str): Nombre del profesor.
            dni (str): Identificador único (DNI) del profesor. 
            tipo (str): Tipo de asignatura que imparte.
        """
        self.nombre = nombre
        self.dni = dni.upper() # DNI como clave
        self.tipo = tipo.upper()


    def __str__(self):
        """
            Devuelve una representación en forma de cadena del profesor
        """
        return f"Profesor: {self.nombre}, DNI: {self.dni}, Tipo: {self.tipo}"
    
    def to_dict(self) -> dict:
        '''
            Devuelve un diccionario con la información del profesor
        '''
        return {"nombre": self.nombre, "DNI": self.dni, "tipo": self.tipo}