import os

from core.app.base import AppSettings


class DevAppSettings(AppSettings):
    """开发环境配置"""

    DEBUG: bool = True
    BASE_DIR: str = os.path.join(
        os.path.split(os.path.realpath(__file__))[0], "../../"
    )  # noqa: E501
