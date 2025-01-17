from fastapi import FastAPI

app = FastAPI()

# Datos de ejemplo
anomalies = [
    {"id": 1, "name": "Anomalía A", "description": "Descripción de la anomalía A"},
    {"id": 2, "name": "Anomalía B", "description": "Descripción de la anomalía B"},
    {"id": 3, "name": "Anomalía C", "description": "Descripción de la anomalía C"}
]

@app.get("/")
def read_root():
    return {"message": "Bienvenido a la API REST con FastAPI!"}

@app.get("/api/anomalies")
def get_anomalies():
    return anomalies

@app.get("/api/anomalies/{anomaly_id}")
def get_anomaly(anomaly_id: int):
    anomaly = next((anomaly for anomaly in anomalies if anomaly["id"] == anomaly_id), None)
    if anomaly is None:
        return {"error": "Anomalía no encontrada"}
    return anomaly