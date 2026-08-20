import sqlite3
import json
import os
from typing import Dict, Any, List, Optional
from fastapi import APIRouter, HTTPException, status
from pydantic import BaseModel, Field

DB_FILE = os.path.join(os.path.dirname(__file__), "users.db")

router = APIRouter(prefix="/api", tags=["Wizard Readings"])

def get_db_connection():
    conn = sqlite3.connect(DB_FILE)
    conn.row_factory = sqlite3.Row
    return conn

def init_readings_db():
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS wizard_readings (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT NOT NULL,
            selections TEXT NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    ''')
    conn.commit()
    conn.close()

def save_wizard_reading_db(username: str, selections: Dict[str, Any]) -> int:
    conn = get_db_connection()
    cursor = conn.cursor()
    selections_str = json.dumps(selections, ensure_ascii=False)
    
    cursor.execute('''
        INSERT INTO wizard_readings (username, selections)
        VALUES (?, ?)
    ''', (username, selections_str))
    
    reading_id = cursor.lastrowid
    conn.commit()
    conn.close()
    return reading_id

def get_user_readings_db(username: str) -> List[Dict[str, Any]]:
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute('''
        SELECT id, username, selections, created_at 
        FROM wizard_readings 
        WHERE username = ? 
        ORDER BY created_at DESC
    ''', (username,))
    rows = cursor.fetchall()
    
    readings = []
    for row in rows:
        r_dict = dict(row)
        try:
            r_dict["selections"] = json.loads(r_dict["selections"])
        except Exception:
            pass
        readings.append(r_dict)
        
    conn.close()
    return readings

class WizardReadingSchema(BaseModel):
    username: str = Field(..., min_length=1, example="user123")
    selections: Dict[str, Any] = Field(
        ..., 
        example={"handShape": "earth", "activeHand": "right_active", "heartLine": "long_curved"}
    )

@router.post("/wizard_readings", status_code=status.HTTP_201_CREATED)
def save_wizard_reading(reading_data: WizardReadingSchema):
    try:
        reading_id = save_wizard_reading_db(
            username=reading_data.username, 
            selections=reading_data.selections
        )
        return {
            "status": "success",
            "message": "Palmistry wizard reading saved successfully",
            "reading_id": reading_id,
            "username": reading_data.username
        }
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to save wizard reading: {str(e)}"
        )

@router.get("/wizard_readings/{username}", response_model=List[Dict[str, Any]])
def get_wizard_readings(username: str):
    return get_user_readings_db(username)
