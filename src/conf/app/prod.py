from conf.app.base import AppSettings


class ProdAppSettings(AppSettings):
    DEBUG:bool = True