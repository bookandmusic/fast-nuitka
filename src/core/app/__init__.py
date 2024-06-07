from enum import Enum

from pydantic_settings import BaseSettings


class AppEnvTypes(Enum):
    PROD: str = "prod"
    DEV: str = "dev"


class AppBaseSettings(BaseSettings):
    APPENV: AppEnvTypes = AppEnvTypes.PROD

    class Config:
        env_file = ".env"
