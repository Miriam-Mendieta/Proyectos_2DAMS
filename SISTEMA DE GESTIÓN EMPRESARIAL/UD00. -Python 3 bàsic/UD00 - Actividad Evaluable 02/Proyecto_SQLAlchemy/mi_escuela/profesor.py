# mi_escuela/profesor.py

from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship

# Importamos la Base del ORM
from .database import Base

class Profesor(Base):
    """
        Define el mapeo a la tabla 'profesores'.
        Un profesor pertenece a una Escuela (ForeignKey).
        Un profesor tiene muchos Alumnos (relationship).
    """
    __tablename__ = 'profesores'
    
    # Columnas de la tabla:
    id = Column(Integer, primary_key=True, index=True) 
    dni = Column(String, unique=True, index=True, nullable=False)
    nombre = Column(String, nullable=False)
    tipo = Column(String, nullable=False)

    # CLAVE FORÁNEA a la tabla ESCUELAS: Mucho a Uno
    # Cada profesor DEBE estar asociado a un ID de escuela válido.
    escuela_id = Column(Integer, ForeignKey('escuelas.id'), nullable=False)

    # Relaciones ORM:
    # Relación con la clase Escuela (Muchos Profesores a Una Escuela)
    escuela_asociada = relationship("Escuela", back_populates="profesores")
    
    # Relación con la clase Alumno (Un Profesor a Muchos Alumnos)
    alumnos_a_cargo = relationship("Alumno", back_populates="profesor_responsable")


    # El constructor se simplifica para crear objetos ORM
    def __init__(self, nombre: str, dni: str, tipo: str, escuela_asociada: object = None):
        self.nombre = nombre
        self.dni = dni.upper() 
        self.tipo = tipo.capitalize()
        if escuela_asociada:
            # Asigna la relación
            self.escuela_asociada = escuela_asociada


    def __str__(self):
        # Muestra el nombre de la escuela a través de la relación
        escuela_nombre = self.escuela_asociada.nombre if hasattr(self, 'escuela_asociada') else "N/A"
        return f"Profesor: {self.nombre} (DNI: {self.dni}), Tipo: {self.tipo}, Escuela: {escuela_nombre}"