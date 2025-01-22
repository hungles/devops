from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    KAFKA_BROKER: str
    KAFKA_GROUP_ID: str
    KAFKA_TOPIC: str
    RSYSLOG_SERVER: str
    RSYSLOG_PORT: str
    class Config:
        env_file = ".env"

settings = Settings()