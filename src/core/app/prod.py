from core.app.base import AppSettings


class ProdAppSettings(AppSettings):
    DEBUG: bool = False
