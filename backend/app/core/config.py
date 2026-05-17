from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    # Настройки базы данных
    DATABASE_URL: str = "postgresql+psycopg2://user:password@db:5432/stereometry_db"

    # Настройки Ollama
    OLLAMA_URL: str = "http://ollama:11434/api/chat"
    OLLAMA_MODEL: str = "gemma4:31b-cloud"
    OLLAMA_TEMPERATURE: float = 0.1
    OLLAMA_SEED: int = 42

    class Config:
        env_file = ".env"
        extra = "ignore"

settings = Settings()
