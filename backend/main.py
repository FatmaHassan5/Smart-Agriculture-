import os
import joblib
import numpy as np
import pandas as pd
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field

MODELS_DIR = os.path.join(os.path.dirname(__file__), "models")

clf_model = joblib.load(os.path.join(MODELS_DIR, "yield_classifier.pkl"))
reg_model = joblib.load(os.path.join(MODELS_DIR, "yield_regressor.pkl"))
le_state = joblib.load(os.path.join(MODELS_DIR, "le_state.pkl"))
le_crop = joblib.load(os.path.join(MODELS_DIR, "le_crop.pkl"))
feature_columns = joblib.load(os.path.join(MODELS_DIR, "feature_columns.pkl"))
crop_avg_yield_map = joblib.load(os.path.join(MODELS_DIR, "crop_avg_yield_map.pkl"))
overall_mean_yield = joblib.load(os.path.join(MODELS_DIR, "overall_mean_yield.pkl"))

VALID_SEASONS = ["Autumn", "Kharif", "Rabi", "Summer", "Whole Year", "Winter"]

app = FastAPI(title="Crop Yield Prediction API")

# Allow the Flutter app (mobile/web/desktop) to call this API from any origin.
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


class PredictionRequest(BaseModel):
    state: str
    crop: str
    season: str
    n: float = Field(..., ge=0, description="Nitrogen")
    p: float = Field(..., ge=0, description="Phosphorus")
    k: float = Field(..., ge=0, description="Potassium")
    ph: float = Field(..., ge=0, le=14, description="Soil pH")
    temperature: float
    rainfall: float
    humidity: float
    fertilizer_per_area: float = Field(..., ge=0, description="Fertilizer kg/hectare")
    pesticide_per_area: float = Field(..., ge=0, description="Pesticide kg/hectare")


class PredictionResponse(BaseModel):
    yield_category: str
    expected_yield: float


@app.get("/")
def root():
    return {"status": "ok", "message": "Crop Yield Prediction API is running"}


@app.get("/options")
def get_options():
    """Returns the valid dropdown values the Flutter app should show."""
    return {
        "states": sorted(le_state.classes_.tolist()),
        "crops": sorted(le_crop.classes_.tolist()),
        "seasons": VALID_SEASONS,
    }


@app.post("/predict", response_model=PredictionResponse)
def predict(req: PredictionRequest):
    if req.state not in le_state.classes_:
        raise HTTPException(status_code=400, detail=f"Unknown state: {req.state}")
    if req.crop not in le_crop.classes_:
        raise HTTPException(status_code=400, detail=f"Unknown crop: {req.crop}")
    if req.season not in VALID_SEASONS:
        raise HTTPException(status_code=400, detail=f"Unknown season: {req.season}")

    crop_encoded = int(le_crop.transform([req.crop])[0])

    input_data = {
        "state": int(le_state.transform([req.state])[0]),
        "crop": crop_encoded,
        "crop_avg_yield": crop_avg_yield_map.get(crop_encoded, overall_mean_yield),
        "n": req.n,
        "p": req.p,
        "k": req.k,
        "ph": req.ph,
        "avg_temp_c": req.temperature,
        "total_rainfall_mm": req.rainfall,
        "avg_humidity_percent": req.humidity,
        "fertilizer_per_area": req.fertilizer_per_area,
        "pesticide_per_area": req.pesticide_per_area,
        "npk_total": req.n + req.p + req.k,
        "season_Kharif": 1 if req.season == "Kharif" else 0,
        "season_Rabi": 1 if req.season == "Rabi" else 0,
        "season_Summer": 1 if req.season == "Summer" else 0,
        "season_Whole Year": 1 if req.season == "Whole Year" else 0,
        "season_Winter": 1 if req.season == "Winter" else 0,
    }

    input_df = pd.DataFrame([input_data])
    input_df = input_df.reindex(columns=feature_columns, fill_value=0)

    yield_category = clf_model.predict(input_df)[0]
    expected_yield_log = reg_model.predict(input_df)[0]
    expected_yield = float(np.expm1(expected_yield_log))

    return PredictionResponse(
        yield_category=str(yield_category),
        expected_yield=round(expected_yield, 2),
    )
