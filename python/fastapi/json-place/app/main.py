from fastapi import FastAPI, HTTPException
import httpx

app = FastAPI()

# Ruta de la API externa que deseas consultar
EXTERNAL_API_URL = "https://jsonplaceholder.typicode.com/posts/1"  # Puedes cambiar esta URL

@app.get("/proxy")
async def proxy_api():
    """
    Endpoint que consulta una API externa y devuelve su respuesta.
    """
    try:
        # Hacer la solicitud a la API externa
        async with httpx.AsyncClient() as client:
            response = await client.get(EXTERNAL_API_URL)
        
        # Validar el estado de la respuesta
        if response.status_code != 200:
            raise HTTPException(status_code=response.status_code, detail="Error al consultar la API externa")
        
        # Devolver la respuesta JSON de la API externa
        return response.json()
    
    except Exception as e:
        # Manejar errores
        raise HTTPException(status_code=500, detail=f"Error interno del servidor: {e}")

