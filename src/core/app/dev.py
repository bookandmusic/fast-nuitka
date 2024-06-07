from core.app.base import AppSettings


class DevAppSettings(AppSettings):
    """开发环境配置"""

    DEBUG: bool = True
