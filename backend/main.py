from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import os
import psycopg2
from psycopg2.extras import RealDictCursor
from prometheus_client import Counter, generate_latest, CONTENT_TYPE_LATEST
from starlette.responses import Response
import json

# ----- Config -----
DB_HOST = os.getenv("POSTGRES_HOST", "postgres")
DB_NAME = os.getenv("POSTGRES_DB", "appdb")
DB_USER = os.getenv("POSTGRES_USER", "appuser")
DB_PASS = os.getenv("POSTGRES_PASSWORD", "changeme")
DB_PORT = int(os.getenv("POSTGRES_PORT", "5432"))

# ----- App -----
app = FastAPI(title="FullStack API")
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ----- Metrics -----
pred_requests = Counter("pred_requests_total", "Total prediction requests")
pred_ok = Counter("pred_ok_total", "Successful predictions")

# ----- DB helper -----
def get_conn():
    return psycopg2.connect(
        host=DB_HOST, database=DB_NAME, user=DB_USER, password=DB_PASS, port=DB_PORT
    )

# Ensure table exists at startup
TABLE_SQL = """
CREATE TABLE IF NOT EXISTS api_logs (
    id SERIAL PRIMARY KEY,
    ts TIMESTAMP DEFAULT NOW(),
    payload JSONB,
    result JSONB
);
"""

@app.on_event("startup")
def on_startup():
    try:
        with get_conn() as conn, conn.cursor() as cur:
            cur.execute(TABLE_SQL)
    except Exception as e:
        # Don't crash app if DB not ready yet; liveness/readiness will handle retries
        print("DB init error:", e)

# ----- Schemas -----
class PredictRequest(BaseModel):
    # Example: [[5.1, 3.5, 1.4, 0.2]]
    features: list[list[float]]

# ----- Routes -----
@app.get("/health")
def health():
    return {"status": "ok"}

@app.get("/metrics")
def metrics():
    return Response(generate_latest(), media_type=CONTENT_TYPE_LATEST)

@app.post("/api/predict")
def predict(req: PredictRequest):
    pred_requests.inc()
    try:
        # For demo: just return sum of features per row
        results = [sum(row) for row in req.features]

        # Store in DB
        with get_conn() as conn, conn.cursor() as cur:
            cur.execute(
                "INSERT INTO api_logs (payload, result) VALUES (%s, %s)",
                [json.dumps(req.dict()), json.dumps(results)],
            )

        pred_ok.inc()
        return {"predictions": results}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/api/logs")
def get_logs(limit: int = 10):
    try:
        with get_conn() as conn, conn.cursor(cursor_factory=RealDictCursor) as cur:
            cur.execute(
                "SELECT id, ts, payload, result FROM api_logs ORDER BY id DESC LIMIT %s",
                [limit],
            )
            rows = cur.fetchall()
        return {"logs": rows}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

