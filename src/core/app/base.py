import os

from pydantic import ValidationInfo, field_validator
from pydantic_settings import BaseSettings


class AppSettings(BaseSettings):
    """公共配置参数"""

    DEBUG: bool = False
    BASE_DIR: str = ""
    TEMPLATES_DIR: str = ""
    STATIC_DIR: str = ""

    @field_validator("TEMPLATES_DIR")
    def get_templates_dir(cls, v: str, info: ValidationInfo) -> str:
        if v:
            return v
        return os.path.join(info.data["BASE_DIR"], "templates")

    @field_validator("STATIC_DIR")
    def get_static_dir(cls, v: str, info: ValidationInfo) -> str:
        if v:
            return v
        return os.path.join(info.data["BASE_DIR"], "static")
