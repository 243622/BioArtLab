from fastapi.testclient import TestClient
from index import (app)
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from datetime import timedelta
from jose import jwt

client = TestClient(app)

user_id = 0
access_token = ''
access_token_type = ''

# Test creating a new user
def test_create_user():
    global user_id
    response = client.post("/user/", json={"username": "testuser", "password": "testpass"})
    assert response.status_code == 201
    assert "userId" in response.json()
    data = response.json()
    user_id = data['userId']
# Test login endpoint
def test_login_for_access_token():
    global access_token, access_token_type
    response = client.post("/login", json={"username": "testuser", "password": "testpass"})
    assert response.status_code == 200
    assert "access_token" in response.json()
    data = response.json()
    access_token = data['access_token']
    access_token_type = data['token_type']

# Test token refresh endpoint
def test_refresh_token():
    response = client.get("/refresh/testuser")
    assert response.status_code == 200
    assert "access_token" in response.json()

# Test fetching all users
def test_get_all_users():
    response = client.get("/users")
    assert response.status_code == 200
    assert isinstance(response.json(), list)

# Test fetching a user by ID
def test_get_user_by_id():
    response = client.get(f"/user/{user_id}")
    assert response.status_code == 200
    assert "userId" in response.json()


# Test deleting a user
def test_delete_user():
    response = client.delete("/user/1")
    assert response.status_code == 200
    assert response.json() == True

# Test updating a user
def test_update_user():
    global user_id
    response = client.patch(f"/user/{user_id}", json={"username": "updateduser"})
    assert response.status_code == 200
    assert "userId" in response.json()

# Test fetching all tasks
def test_get_all_tasks():
    response = client.get("/tasks")
    assert response.status_code == 200
    assert isinstance(response.json(), list)

# Test creating a new task
def test_create_task():
    response = client.post("/task/", json={"taskName": "New Task", "taskType": 1})
    assert response.status_code == 201
    assert "taskId" in response.json()

# Test fetching all animals
def test_get_all_animals():
    response = client.get("/animals")
    assert response.status_code == 200
    assert isinstance(response.json(), list)

# Test creating a new animal
def test_create_animal():
    response = client.post("/animal/", json={"animalName": "New Animal", "animalTypeId": 1})
    assert response.status_code == 201
    assert "animalId" in response.json()
# Stocks endpoints
def test_get_stocks():
    response = client.get("/stocks")
    assert response.status_code == 200

def test_get_stock_by_id():
    response = client.get("/stock/1")
    assert response.status_code == 200

def test_create_stock():
    data = {"name": "Corn", "quantity": 100, "unit": "kg"}
    response = client.post("/stock/", json=data)
    assert response.status_code == 201

def test_delete_stock():
    response = client.delete("/stock/1")
    assert response.status_code == 200

def test_edit_stock():
    data = {"name": "Wheat", "quantity": 50}
    response = client.patch("/stock/1", json=data)
    assert response.status_code == 200

# Foodtype endpoints
def test_get_foodtypes():
    response = client.get("/foodtype")
    assert response.status_code == 200

def test_get_foodtype_by_id():
    response = client.get("/foodtype/1")
    assert response.status_code == 200

def test_create_foodtype():
    data = {"name": "Hay"}
    response = client.post("/foodtype/", json=data)
    assert response.status_code == 201

def test_delete_foodtype():
    response = client.delete("/foodtype/1")
    assert response.status_code == 200

def test_edit_foodtype():
    data = {"name": "Grass"}
    response = client.patch("/foodtype/1", json=data)
    assert response.status_code == 200

# Rapport endpoints
def test_get_rapports():
    response = client.get("/rapports")
    assert response.status_code == 200

def test_get_rapport_by_id():
    response = client.get("/rapport/1")
    assert response.status_code == 200

def test_create_rapport():
    data = {"title": "Daily Report", "content": "All tasks completed."}
    response = client.post("/rapport/", json=data)
    assert response.status_code == 201

def test_delete_rapport():
    response = client.delete("/rapport/1")
    assert response.status_code == 200

def test_edit_rapport():
    data = {"title": "Updated Daily Report"}
    response = client.patch("/rapport/1", json=data)
    assert response.status_code == 200

# Animaltype endpoints
def test_get_animaltypes():
    response = client.get("/animaltypes")
    assert response.status_code == 200

def test_get_animaltype_by_id():
    response = client.get("/animaltype/1")
    assert response.status_code == 200

def test_create_animaltype():
    data = {"name": "Mammal"}
    response = client.post("/animaltype/", json=data)
    assert response.status_code == 201

def test_delete_animaltype():
    response = client.delete("/animaltype/1")
    assert response.status_code == 200

def test_edit_animaltype():
    data = {"name": "Bird"}
    response = client.patch("/animaltype/1", json=data)
    assert response.status_code == 200

# Tasktype endpoints
def test_get_tasktypes():
    response = client.get("/tasktypes")
    assert response.status_code == 200

def test_get_tasktype_by_id():
    response = client.get("/tasktype/1")
    assert response.status_code == 200

def test_create_tasktype():
    data = {"name": "Cleaning"}
    response = client.post("/tasktype/", json=data)
    assert response.status_code == 201

def test_delete_tasktype():
    response = client.delete("/tasktype/1")
    assert response.status_code == 200

def test_edit_tasktype():
    data = {"name": "Feeding"}
    response = client.patch("/tasktype/1", json=data)
    assert response.status_code == 200

# Messages endpoints
def test_get_messages():
    response = client.get("/messages")
    assert response.status_code == 200

def test_get_message_by_id():
    response = client.get("/message/1")
    assert response.status_code == 200

def test_create_message():
    data = {"content": "Hello World"}
    response = client.post("/message/", json=data)
    assert response.status_code == 201

def test_delete_message():
    response = client.delete("/message/1")
    assert response.status_code == 200

def test_edit_message():
    data = {"content": "Updated Hello World"}
    response = client.patch("/message/1", json=data)
    assert response.status_code == 200

