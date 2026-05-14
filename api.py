"""
API for model inference
"""

import io
import os
from fastapi import FastAPI, File
from fastapi.responses import JSONResponse
from fastapi.exceptions import HTTPException
from PIL import Image
import torch

from src.data.transforms import INFERENCE_TRANSFORMS
from src.modeling.model import HCCLF

MODEL_PATH_DEFAULT = "models/final/model.pt"
MODEL_PATH = os.getenv("MODEL_PATH", MODEL_PATH_DEFAULT)

device = torch.device("cpu")  # Ensure we are using CPU for inference

app = FastAPI()

model = HCCLF()
model.load_state_dict(torch.load(MODEL_PATH, map_location=device))
model.eval()

@app.post("/predict")
def predict(file: bytes = File(...)):
    try:
        image = Image.open(io.BytesIO(file))
        tensor: torch.Tensor = INFERENCE_TRANSFORMS(image)
        tensor = tensor.unsqueeze(0)
        
        with torch.no_grad():
            prediction: torch.Tensor = model(tensor)
        
        return JSONResponse(content={"prediction": prediction.numpy().tolist()[0][0]})
    
    except Exception as e:
        raise HTTPException(detail=str(e), status_code=400)
    
@app.get("/health")
def health():
    return JSONResponse(content={"status": "ok"})