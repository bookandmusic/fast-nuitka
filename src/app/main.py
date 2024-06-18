from fastapi import FastAPI, Request
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates

from core.conf import settings

app = FastAPI()

app.mount(
    "/static", StaticFiles(directory=settings.STATIC_DIR), name="static"
)  # noqa: E501

templates = Jinja2Templates(directory=settings.TEMPLATES_DIR)


@app.get("/")
async def index(request: Request):
    return templates.TemplateResponse("index.html", {"request": request})  # noqa: E501
