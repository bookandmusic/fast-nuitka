import os

from fastapi.templating import Jinja2Templates
from conf.app import AppBaseSettings


class AppSettings(AppBaseSettings):
    """公共配置参数"""
    BASE_DIR: str = os.path.join(os.path.split(os.path.realpath(__file__))[0], "../../")
    TEMPLATES_DIR: str = os.path.join(BASE_DIR, "templates")
    STATIC_DIRECTORY:str = os.path.join(BASE_DIR, "static")
    TEMPLATES: Jinja2Templates = Jinja2Templates(directory=TEMPLATES_DIR)