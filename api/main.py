"""CoCo HTTP API for web app: list canonicals/builds, generate samples, run transforms, serve artifacts."""
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from api.routers import artifacts, config as config_router, samples, transform, validate

app = FastAPI(
    title="CoCo Canonical API",
    description="List canonicals/builds, generate sample XML, run XSLT transforms, list and download schemas/transforms and samples.",
    version="0.1.0",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(config_router.router, tags=["config"])
app.include_router(samples.router, prefix="/samples", tags=["samples"])
app.include_router(transform.router, prefix="/transform", tags=["transform"])
app.include_router(artifacts.router, tags=["artifacts"])
app.include_router(validate.router, prefix="/validate", tags=["validate"])


@app.get("/")
def root():
    return {"service": "CoCo Canonical API", "docs": "/docs"}
