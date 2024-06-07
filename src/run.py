from typing import Optional

from fastapi import FastAPI
from gunicorn.app.base import BaseApplication  # type: ignore

from app.main import app
from core.gunicorn import gunicorn_options


class StandaloneApplication(BaseApplication):
    def __init__(self, app: FastAPI, options: Optional[dict] = None):
        self.options = options or {}
        self.application = app
        super().__init__()

    def load_config(self):
        for key, value in self.options.items():
            if key.lower() in self.cfg.settings and value is not None:
                self.cfg.set(key.lower(), value)

    def load(self):
        return self.application


if __name__ == "__main__":
    standalone_app = StandaloneApplication(app, options=gunicorn_options)
    standalone_app.run()
