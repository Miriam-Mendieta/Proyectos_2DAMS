# mi_escuela/alumno.py

from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship
from .database import Base


class Alumno(Base):
    """
        Define el mapeo a la tabla 'alumnos'.
        Un alumno pertenece a un Profesor (ForeignKey).
    """
    __tablename__ = 'alumnos'

    # Columnas de la tabla:
    id = Column(Integer, primary_key=True, index=True)
    # NIA del alumno
    nia = Column(String, unique=True, index=True, nullable=False) 
    nombre = Column(String, nullable=False)
    curso = Column(String, nullable=False)
    
    # CLAVE FORÁNEA a la tabla PROFESORES: Mucho a Uno
    # Cada alumno DEBE estar asociado a un ID de profesor válido.
    profesor_id = Column(Integer, ForeignKey('profesores.id'), nullable=False)

    # Relación ORM:
    # Relación con la clase Profesor (Muchos Alumnos a Un Profesor)
    # Esto permite acceder al objeto Profesor desde el objeto Alumno.
    profesor_responsable = relationship("Profesor", back_populates="alumnos_a_cargo")

    
    # El constructor se simplifica para crear objetos ORM
    def __init__(self, nombre: str, nia: str, curso: str, profesor_responsable: object = None):
        self.nombre = nombre
        self.nia = dni_nia.upper()
        self.curso = curso
        if profesor_responsable:
            # Asigna la relación
            self.profesor_responsable = profesor_responsable


    def __str__(self):
        # Muestra el nombre del profesor responsable a través de la relación
        resp_nombre = self.profesor_responsable.nombre if hasattr(self, 'profesor_responsable') else "N/A"
        return f"Alumno: {self.nombre} (ID: {self.id}), NIA: {self.nia}, Curso: {self.curso} (Resp: {resp_nombre})"