from functools import lru_cache
from typing import Dict, Type

from core.app import AppBaseSettings, AppEnvTypes
from core.app.base import AppSettings
from core.app.dev import DevAppSettings
from core.app.prod import ProdAppSettings

environments: Dict[AppEnvTypes, Type[AppSettings]] = {
    AppEnvTypes.DEV: DevAppSettings,
    AppEnvTypes.PROD: ProdAppSettings,
}


@lru_cache
def get_app_settings() -> AppSettings:
    app_env = AppBaseSettings().APPENV
    coreig = environments[app_env]
    return coreig()


settings = get_app_settings()
