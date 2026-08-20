import sqlite3
import json
import os
from typing import Dict, Any, List, Optional

DB_FILE = os.path.join(os.path.dirname(__file__), "users.db")

def get_db_connection():
    conn = sqlite3.connect(DB_FILE)
    conn.row_factory = sqlite3.Row
    return conn

def init_db():
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT UNIQUE NOT NULL,
            password TEXT NOT NULL,
            first_name TEXT NOT NULL,
            last_name TEXT NOT NULL,
            date_of_birth TEXT NOT NULL,
            gender TEXT NOT NULL,
            palmistry_info TEXT NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    ''')
    conn.commit()
    conn.close()

def save_or_update_user(data: Dict[str, Any]) -> int:
    conn = get_db_connection()
    cursor = conn.cursor()
    
    username = data["username"]
    password = data["password"]
    first_name = data["first_name"]
    last_name = data["last_name"]
    date_of_birth = data["date_of_birth"]
    gender = data["gender"]
    
    # Encode palmistry_info dict to JSON string if needed
    palmistry_info_str = json.dumps(data["palmistry_info"], ensure_ascii=False)
    
    # Check if user already exists
    cursor.execute("SELECT id FROM users WHERE username = ?", (username,))
    row = cursor.fetchone()
    
    if row:
        user_id = row["id"]
        cursor.execute('''
            UPDATE users 
            SET password = ?, first_name = ?, last_name = ?, date_of_birth = ?, gender = ?, palmistry_info = ?, updated_at = CURRENT_TIMESTAMP
            WHERE id = ?
        ''', (password, first_name, last_name, date_of_birth, gender, palmistry_info_str, user_id))
    else:
        cursor.execute('''
            INSERT INTO users (username, password, first_name, last_name, date_of_birth, gender, palmistry_info)
            VALUES (?, ?, ?, ?, ?, ?, ?)
        ''', (username, password, first_name, last_name, date_of_birth, gender, palmistry_info_str))
        user_id = cursor.lastrowid
        
    conn.commit()
    conn.close()
    return user_id

def get_all_users() -> List[Dict[str, Any]]:
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT id, username, first_name, last_name, date_of_birth, gender, palmistry_info, created_at, updated_at FROM users")
    rows = cursor.fetchall()
    
    users = []
    for row in rows:
        user_dict = dict(row)
        try:
            user_dict["palmistry_info"] = json.loads(user_dict["palmistry_info"])
        except Exception:
            pass
        users.append(user_dict)
        
    conn.close()
    return users

def get_user_by_username(username: str) -> Optional[Dict[str, Any]]:
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT id, username, first_name, last_name, date_of_birth, gender, palmistry_info, created_at, updated_at FROM users WHERE username = ?", (username,))
    row = cursor.fetchone()
    conn.close()
    
    if row:
        user_dict = dict(row)
        try:
            user_dict["palmistry_info"] = json.loads(user_dict["palmistry_info"])
        except Exception:
            pass
        return user_dict
    return None

def authenticate_user(username: str, password: str) -> Optional[Dict[str, Any]]:
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT id, username, password, first_name, last_name, date_of_birth, gender, palmistry_info, created_at, updated_at FROM users WHERE username = ?", (username,))
    row = cursor.fetchone()
    conn.close()
    
    if row and row["password"] == password:
        user_dict = dict(row)
        try:
            user_dict["palmistry_info"] = json.loads(user_dict["palmistry_info"])
        except Exception:
            pass
        return user_dict
    return None

