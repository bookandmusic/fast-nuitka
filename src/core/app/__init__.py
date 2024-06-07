from enum import Enum

from pydantic_settings import BaseSettings


class AppEnvTypes(Enum):
    PROD: str = "prod"
    DEV: str = "dev"
    TEST: str = "test"


class AppBaseSettings(BaseSettings):
    APPENV: AppEnvTypes = AppEnvTypes.DEV

    class Config:
        env_file = ".env"
