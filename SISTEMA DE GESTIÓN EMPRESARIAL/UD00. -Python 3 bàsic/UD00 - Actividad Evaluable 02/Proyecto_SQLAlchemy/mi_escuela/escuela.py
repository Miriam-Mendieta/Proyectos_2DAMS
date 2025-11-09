# mi_escuela/escuela.py (CÓDIGO ORM)

from sqlalchemy import Column, Integer, String
from sqlalchemy.orm import relationship
from .database import Base

class Escuela(Base):
    """
    Clase que mapea la tabla 'escuelas' para la persistencia de datos.
    Ya no almacena profesores y alumnos en memoria, solo define la estructura
    de la tabla y sus relaciones.
    """
    # Mapeo a la tabla 'escuelas'
    __tablename__ = 'escuelas'
    
    # Columnas:
    id = Column(Integer, primary_key=True, index=True) 
    nombre = Column(String, nullable=False)
    localizacion = Column(String, nullable=False) # Ahora se llama "localizacion" en lugar de "localidad"
    director = Column(String, nullable=False)     # Ahora se llama "director" en lugar de "responsable"

    # Relación: Una Escuela puede tener múltiples Profesores
    # El Profesor contendrá la Clave Foránea a esta tabla (escuela_id).
    profesores = relationship("Profesor", back_populates="escuela_asociada")

    def __init__(self, nombre: str, localizacion: str, director: str):
        '''
        Inicializa una nueva instancia de Escuela.
        '''
        # constructor simple para crear objetos en Python
        self.nombre = nombre
        self.localizacion = localizacion
        self.director = director

    def __str__(self):
        '''
            Representación en cadena del objeto Escuela.
        '''
        return f"Escuela: {self.nombre} (ID: {self.id}), Director: {self.director}, Localidad: {self.localizacion}"