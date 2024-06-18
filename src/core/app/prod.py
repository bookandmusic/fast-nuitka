from core.app.base import AppSettings


class ProdAppSettings(AppSettings):
    BASE_DIR: str = "/app"
