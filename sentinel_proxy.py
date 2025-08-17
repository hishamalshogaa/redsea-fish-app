import os, math, random
from datetime import datetime
from typing import Optional
import requests
from fastapi import FastAPI, HTTPException, Response
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(title="Satellite Proxy & Reef API", version="0.2.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

def _proxy_tile(template_env_key: str, z: int, x: int, y: int, token_env_key: Optional[str] = None):
    template = os.getenv(template_env_key)
    if not template:
        raise HTTPException(status_code=500, detail=f'Missing {template_env_key} in environment')
    url = template.format(z=z, x=x, y=y)
    headers = {}
    token = os.getenv(token_env_key or '')
    if token:
        headers['Authorization'] = f'Bearer {token}'
    r = requests.get(url, headers=headers, timeout=20)
    if r.status_code != 200:
        raise HTTPException(status_code=r.status_code, detail=f'Upstream error for {template_env_key}')
    return Response(content=r.content, media_type='image/png')

@app.get('/tiles/{z}/{x}/{y}.png')
def satellite_tiles(z: int, x: int, y: int):
    return _proxy_tile('SENTINEL_XYZ_TEMPLATE', z, x, y, 'SAT_API_TOKEN')

@app.get('/chl/{z}/{x}/{y}.png')
def chl_tiles(z: int, x: int, y: int):
    return _proxy_tile('CHL_XYZ_TEMPLATE', z, x, y, 'CHL_API_TOKEN')

@app.get('/sst/{z}/{x}/{y}.png')
def sst_tiles(z: int, x: int, y: int):
    return _proxy_tile('SST_XYZ_TEMPLATE', z, x, y, 'SST_API_TOKEN')

@app.get('/turbidity/{z}/{x}/{y}.png')
def turbidity_tiles(z: int, x: int, y: int):
    return _proxy_tile('TURBIDITY_XYZ_TEMPLATE', z, x, y, 'TURBIDITY_API_TOKEN')

@app.get('/api/v1/satellite/reef-coverage')
def reef_coverage(reef_id: Optional[str] = None):
    # Placeholder deterministic value from reef_id
    val = 0.65 if not reef_id else (abs(hash(reef_id)) % 35) / 100.0 + 0.5
    val = min(1.0, max(0.0, val))
    return {
      'reef_id': reef_id or 'unknown',
      'health_index': round(val, 2),
      'updated_at': datetime.utcnow().isoformat() + 'Z',
      'source': 'Sentinel-derived (mock)'
    }

@app.post('/api/v1/predict')
def predict(payload: dict):
    # Mock heuristic model combining chl, sst, turbidity and reef health
    lat = float(payload.get('lat', 0.0))
    lon = float(payload.get('lon', 0.0))
    date = payload.get('date')
    # Fake features from coords (deterministic-ish for demo)
    base = (math.sin(lat) * math.cos(lon) + 1) / 2  # 0..1
    chl = 0.6 * base + 0.2  # assume moderate productivity
    sst = 0.7 * base + 0.2
    turb = 0.3 * base + 0.1
    reef_health = 0.5 + 0.5 * math.sin((lat + lon) / 10.0)
    presence = 0.4*chl + 0.3*(1-abs(sst-0.7)) + 0.2*(1-turb) + 0.1*reef_health
    presence = max(0.0, min(1.0, presence))

    species = [
      {'name':'ناجل','prob': 0.35*presence + 0.1},
      {'name':'حمرور','prob': 0.30*presence + 0.1},
      {'name':'شعري','prob': 0.25*presence + 0.1},
      {'name':'بياض','prob': 0.20*presence + 0.1},
    ]
    # Normalize
    total = sum(s['prob'] for s in species)
    for s in species:
      s['prob'] = s['prob'] / total

    return {
      'lat': lat, 'lon': lon, 'date': date,
      'presence_prob': round(presence, 3),
      'reef_health': round(reef_health, 2),
      'top_species': sorted(species, key=lambda x: x['prob'], reverse=True)[:3]
    }
