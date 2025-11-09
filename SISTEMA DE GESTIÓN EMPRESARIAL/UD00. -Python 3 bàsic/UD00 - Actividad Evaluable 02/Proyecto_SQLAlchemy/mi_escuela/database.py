# mi_escuela/database.py

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base

# 1. Definir la URL de la Base de Datos
# Usamos SQLite y especificamos el nombre del archivo.
DATABASE_URL = "sqlite:///escuela.db"

# 2. Crear el Motor (Engine) de la BD
# El 'Engine' es el punto de inicio para la base de datos.
engine = create_engine(DATABASE_URL, echo=True) # 'echo=True' muestra las sentencias SQL generadas

# 3. Crear la Base Declarativa (ORM Base)
# Esta clase Base será heredada por todas nuestras clases de modelo.
Base = declarative_base()

# 4. Crear el Constructor de Sesiones
# La 'Session' es el área de trabajo donde se guardan, consultan y modifican objetos.
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

def get_db():
    """Función generadora para obtener y cerrar la sesión de la base de datos."""
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()