import uvicorn
from fastapi import FastAPI, HTTPException, status
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field
from typing import Dict, Any, Optional, List
import database
import readings

app = FastAPI(
    title="Palmistry User Info API",
    description="Backend API for saving and syncing palmistry user account and reading info",
    version="1.0.0"
)

# Include routes from readings module
app.include_router(readings.router)

# Enable CORS for Flutter web / desktop / emulator requests
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Initialize database tables on startup
@app.on_event("startup")
def startup_event():
    database.init_db()
    readings.init_readings_db()


class LoginSchema(BaseModel):
    username: str = Field(..., min_length=1, example="user123")
    password: str = Field(..., min_length=1, example="pass123")

class UserInfoSchema(BaseModel):
    username: str = Field(..., min_length=2, example="user123")
    password: str = Field(..., min_length=3, example="pass123")
    first_name: str = Field(..., example="Ali")
    last_name: str = Field(..., example="Rezai")
    date_of_birth: str = Field(..., example="1995-04-15")
    gender: str = Field(..., example="Male")
    palmistry_info: Dict[str, Any] = Field(
        default_factory=dict, 
        example={"dominant_hand": "Right", "hand_size": "Medium", "active_lines": ["line_life", "line_head"]}
    )

@app.post("/api/login", status_code=status.HTTP_200_OK)
def login_user(credentials: LoginSchema):
    user = database.authenticate_user(credentials.username, credentials.password)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="نام کاربری یا رمز عبور اشتباه است"
        )
    
    # Retrieve user historical readings
    user_readings = readings.get_user_readings_db(credentials.username)
    
    return {
        "status": "success",
        "message": "ورود با موفقیت انجام شد",
        "user": user,
        "readings": user_readings
    }


@app.get("/health")
def health_check():
    return {"status": "ok", "message": "Palmistry Backend Server is running"}

@app.post("/api/user_info", status_code=status.HTTP_200_OK)
def save_user_info(user_data: UserInfoSchema):
    try:
        user_dict = user_data.dict()
        user_id = database.save_or_update_user(user_dict)
        return {
            "status": "success",
            "message": "User information saved successfully",
            "user_id": user_id,
            "username": user_data.username
        }
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to save user info: {str(e)}"
        )

@app.get("/api/users", response_model=List[Dict[str, Any]])
def list_users():
    return database.get_all_users()

@app.get("/api/user_info/{username}")
def get_user(username: str):
    user = database.get_user_by_username(username)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"User '{username}' not found"
        )
    return user

if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
