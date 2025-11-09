# mi_escuela/alumno.py

# Usamos un punto para importar desde el módulo hermano 'profesor'
from .profesor import Profesor
from typing import Dict
class Alumno:
    def __init__(self, nombre, nia,curso, profesor_responsable):
        self.nombre = nombre
        self.nia = nia
        self.curso = curso
        self.profesor_responsable = profesor_responsable  # instancia de Profesor

    def __str__(self):
        return f"Alumno: {self.nombre}, NIA: {self.nia}, Curso: {self.curso}, Responsable: {self.profesor_responsable.nombre}"
    
    def to_dict(self) -> dict:
        return {
            "nombre": self.nombre,
            "nia": self.nia,
            "curso": self.curso,
            "profesor_responsable": self.profesor_responsable.nombre
        }