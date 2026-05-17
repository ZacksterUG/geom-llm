from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from app.core.config import settings

# Создаем движок SQLAlchemy
engine = create_engine(settings.DATABASE_URL, pool_pre_ping=True)

# Создаем фабрику сессий
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

def get_db():
    """Генератор сессий для зависимостей FastAPI."""
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
