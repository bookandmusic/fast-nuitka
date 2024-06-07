from fastapi import FastAPI, Request
from fastapi.staticfiles import StaticFiles

from core.conf import settings

app = FastAPI()

app.mount(
    "/static", StaticFiles(directory=settings.STATIC_DIRECTORY), name="static"
)  # noqa: E501


@app.get("/")
async def index(request: Request):
    return settings.TEMPLATES.TemplateResponse(
        "index.html", {"request": request}
    )  # noqa: E501
