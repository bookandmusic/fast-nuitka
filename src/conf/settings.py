from functools import lru_cache
from typing import Dict, Type

from conf.app import AppBaseSettings, AppEnvTypes
from conf.app.base import AppSettings
from conf.app.dev import DevAppSettings
from conf.app.prod import ProdAppSettings



environments: Dict[AppEnvTypes, Type[AppSettings]] = {
    AppEnvTypes.DEV: DevAppSettings,
    AppEnvTypes.PROD: ProdAppSettings,
}


@lru_cache
def get_app_settings() -> AppSettings:
    app_env = AppBaseSettings().APPENV
    config = environments[app_env]
    return config()


settings = get_app_settings()