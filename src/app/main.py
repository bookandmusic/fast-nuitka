from fastapi import FastAPI, Request
from fastapi.staticfiles import StaticFiles
from conf.settings import settings

app = FastAPI()

app.mount("/static", StaticFiles(directory=settings.STATIC_DIRECTORY), name="static")

@app.get("/")
async def index(request: Request):
    return settings.TEMPLATES.TemplateResponse("index.html", {"request": request})

