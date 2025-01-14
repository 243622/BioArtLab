#*TODO Maak de API
#!TODO FIX
#?TODO Vraag
import uuid
from os import access
from pydantic import BaseModel
from sqlalchemy import DateTime, asc, desc
import schedule
import time

import models
import schemes
from database import engine, SessionLocal
from sqlalchemy.orm import Session
from starlette.middleware.cors import CORSMiddleware
from datetime import datetime, timedelta, timezone, date
from typing import Annotated, Union, List
from fastapi import Depends, FastAPI, HTTPException, status, File, UploadFile
from fastapi.responses import FileResponse
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
import jwt
from jwt.exceptions import InvalidTokenError
from passlib.context import CryptContext
import base64
import io
import random
import requests

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins="*",
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

models.Base.metadata.create_all(bind=engine)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

#DB
db_dependency = Annotated[Session, Depends(get_db)]

#Hash Bcrypt
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

#O2Auth
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")


#Login needed
SECRET_KEY = '09d25e094faa6ca2556c818166b7a9563b93f7099f6f0f4caa6cf63b88e8d3e7'
ALGORITHM = 'HS256'
ACCESS_TOKEN_EXPIRE_MINUTES = 3

#Token

class Token(BaseModel):
    access_token: str
    token_type: str

class TokenData(BaseModel):
    username: Union[str, None] = None

class UserInDB(BaseModel):
    hashed_password: str


#! Login
def verify_password(plain_password, hashed_password):
    return pwd_context.verify(plain_password, hashed_password)


def get_password_hash(password):
    return pwd_context.hash(password)


def get_user(db: db_dependency, username: str):
    return db.query(models.User).filter(models.User.username == username).first()


def authenticate_user(db: Session, username: str, password: str):
    user = get_user(db, username)
    if not user:
        return False
    if not verify_password(password, user.password):
        return False
    return user


def create_access_token(data: dict, expires_delta: timedelta | None = None):
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.now(timezone.utc) + expires_delta
    else:
        expire = datetime.now(timezone.utc) + timedelta(minutes=15)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt


async def get_current_user(token: Annotated[str, Depends(oauth2_scheme)]):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        username: str = payload.get("sub")
        if username is None:
            raise credentials_exception
        token_data = TokenData(username=username)
    except InvalidTokenError:
        raise credentials_exception
    db = SessionLocal()
    user = get_user(db, username=token_data.username)
    db.close()
    if user is None:
        raise credentials_exception
    return user


async def get_current_active_user(
    current_user: Annotated[schemes.UserBase, Depends(get_current_user)],
):
    if current_user.disabled:
        raise HTTPException(status_code=400, detail="Inactive user")
    return current_user


@app.post("/login", status_code=status.HTTP_200_OK)
async def login_for_access_token(
    user: schemes.UserBase,
) -> Token:
    db = SessionLocal()
    user = authenticate_user(db, user.username, user.password)
    db.close()
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data={"sub": user.username}, expires_delta=access_token_expires
    )
    return Token(access_token=access_token, token_type="bearer")

@app.get('/user/{username}', status_code=status.HTTP_200_OK)
async def get_user_by_username(db: db_dependency, username: str):
    return db.query(models.User).filter(models.User.username == username).first()

@app.get('/refresh/{username}', status_code=status.HTTP_200_OK)
async def refresh_token(db: db_dependency,username: str):
     user = get_user(db, username)
     if user:
         access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
         access_token = create_access_token(
             data={"sub": user.username}, expires_delta=access_token_expires
         )
         return {"access_token": access_token}


#* gebruik voor authentication - current_user: UserInDB = Depends(get_current_user)

#! User endpoints
@app.get('/users', status_code=status.HTTP_200_OK)
async def get_all_users(db: db_dependency, limit: Union[int, None] = None, offset: Union[int, None] = None,  ):
    return db.query(models.User).limit(limit).offset(offset).all()

@app.get('/userbyid/{user_id}', status_code=status.HTTP_200_OK)
async def get_user_by_id(db: db_dependency, user_id: int):
    return db.query(models.User).filter(models.User.userId == user_id).first()

@app.post('/user/', status_code=status.HTTP_201_CREATED)
async def create_user(user: schemes.UserBase, db: db_dependency):
    db_user = models.User(**user.model_dump())
    db_user.password = pwd_context.hash(db_user.password)
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user

@app.delete('/user/{user_id}', status_code=status.HTTP_200_OK)
async def delete_user(db: db_dependency, user_id: int):
    db.query(models.User).filter(models.User.userId == user_id).delete()
    db.commit()
    return True

@app.patch('/user/{user_id}', status_code=status.HTTP_200_OK)
async def update_user(user_id: int, user: schemes.UserBase, db: db_dependency):
    try:
        db_user = db.query(models.User).filter(models.User.userId == user_id).first()

        update_data = user.dict()
        for key, value in update_data.items():
            setattr(db_user, key, value)
        if db_user.password:
            db_user.password = pwd_context.hash(db_user.password)
        db.add(db_user)
        db.commit()
        db.refresh(db_user)
        return db_user

    except Exception as f:
        return print(f)

#! Task Endpoints
# Als met objecten wordt gewerkt hoeft += niet gebruikt te worden. Je kan gewoon functies bij de variabelen voegen en worden ze alsnog uitgevoerd allemaal
@app.get('/tasks', status_code=status.HTTP_200_OK)
async def get_all_tasks(db: db_dependency, limit: Union[int, None] = None, offset: Union[int, None] = None, done: Union[int, None] = None, task_type: Union[int, None] = None, priority: Union[int, None] = None):
    query = db.query(models.Task)

    if done == 0 | 1:
        query = query.filter(models.Task.finished == done)

    if task_type:
        query = query.filter(models.Task.taskType == task_type)

    if limit:
        query = query.limit(limit)

    if offset:
        query = query.offset(offset)

    if priority == 1:
        query = query.order_by(desc(models.Task.priority))

    return query.order_by(desc(models.Task.createdDate)).all()




@app.get('/task/{task_id}', status_code=status.HTTP_200_OK)
async def get_task_by_id(db: db_dependency, task_id: int):
    return db.query(models.Task).filter(models.Task.taskId == task_id).first()

@app.post('/task/', status_code=status.HTTP_201_CREATED)
async def create_task(db: db_dependency, task: schemes.TaskBase):
    task.createdDate = datetime.now()
    db_task = models.Task(**task.model_dump())
    db.add(db_task)
    db.commit()
    db.refresh(db_task)
    return db_task

@app.delete('/tasks/{task_id}', status_code=status.HTTP_200_OK)
async def delete_task(db:db_dependency, task_id: int):
    db.query(models.Task).filter(models.Task.taskId == task_id).delete()
    db.commit()
    return True


from fastapi import HTTPException


@app.patch('/task/{task_id}', status_code=status.HTTP_200_OK)
async def edit_task(db: db_dependency, task_id: int, task: schemes.TaskBase):
    try:
        db_task = db.query(models.Task).filter(models.Task.taskId == task_id).first()

        if not db_task:
            raise HTTPException(status_code=404, detail="Task not found")

        update_data = task.dict(exclude_unset=True)  # Only include fields explicitly set in the request
        for key, value in update_data.items():
            if value is not None:  # Avoid overwriting with None
                setattr(db_task, key, value)

        db.add(db_task)
        db.commit()
        db.refresh(db_task)
        return db_task

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


#! Animal endpoints
#? Verander de volgende endpoints naar Animal endpoints
@app.get('/animals', status_code=status.HTTP_200_OK)
async def get_all_animals(db: db_dependency, limit: Union[int, None] = None, offset: Union[int, None] = None, animal_type: Union[int, None] = None):
    query = db.query(models.Animal)

    if animal_type:
        query = query.filter(models.Animal.animalTypeId == animal_type)

    if limit:
        query = query.limit(limit)

    if offset:
        query = query.offset(offset)

    return query.all()

@app.get('/animal/{animal_id}', status_code=status.HTTP_200_OK)
async def get_animal_by_id(db: db_dependency, animal_id: int):
    return db.query(models.Animal).filter(models.Animal.animalId == animal_id).first()
@app.post('/animal/', status_code=status.HTTP_201_CREATED)
async def create_animal(db: db_dependency, animal: schemes.AnimalBase):
    db_animal = models.Animal(**animal.model_dump())
    db.add(db_animal)
    db.commit()
    db.refresh(db_animal)
    return db_animal

@app.delete('/animal/{animal_id}', status_code=status.HTTP_200_OK)
async def delete_animal(db:db_dependency, animal_id: int):
    db.query(models.Animal).filter(models.Animal.animalId == animal_id).delete()
    db.commit()
    return True

@app.patch('/animal/{animal_id}', status_code=status.HTTP_200_OK)
async def edit_animal(db: db_dependency, animal_id: int, animal: schemes.AnimalBase):
    try:
        db_animal = db.query(models.Animal).filter(models.Animal.animalId == animal_id).first()
        update_data = animal.dict()
        for key, value in update_data.items():
            setattr(db_animal, key, value)
        db.add(db_animal)
        db.commit()
        db.refresh(db_animal)
        return db_animal

    except Exception as f:
        return print(f)

#TODO Maak de rest van de endpoints na animals

#! Stocks endpoints

@app.get('/stocks', status_code=status.HTTP_200_OK)
async def get_stocks(db: db_dependency, limit: Union[int, None] = None, offset: Union[int, None] = None):
    query = db.query(models.Stock)

    if limit:
        query = query.limit(limit)

    if offset:
        query = query.offset(offset)

    return query.all()

@app.get('/stock/{stock_id}', status_code=status.HTTP_200_OK)
async def get_stock_by_id(db: db_dependency, stock_id: int):
    return db.query(models.Stock).filter(models.Stock.stockId == stock_id).first()

@app.post('/stock/', status_code=status.HTTP_201_CREATED)
async def create_stock(db: db_dependency, stock: schemes.StockBase):
    db_stock = models.Stock(**stock.model_dump())
    db.add(db_stock)
    db.commit()
    db.refresh(db_stock)
    return db_stock

@app.delete('/stock/{stock_id}', status_code=status.HTTP_200_OK)
async def delete_stock(db: db_dependency, stock_id: int):
    db.query(models.Stock).filter(models.Stock.stockId == stock_id).delete()
    db.commit()
    return True

@app.patch('/stock/{stock_id}', status_code=status.HTTP_200_OK)
async def edit_animal(db: db_dependency, stock_id: int, stock: schemes.StockBase):
    try:
        db_stock = db.query(models.Stock).filter(models.Stock.stockId == stock_id).first()
        update_data = stock.dict()
        for key, value in update_data.items():
            setattr(db_stock, key, value)
        db.add(db_stock)
        db.commit()
        db.refresh(db_stock)
        return db_stock

    except Exception as f:
        return print(f)

#! Foodtype endpoints

@app.get('/foodtypes', status_code=status.HTTP_200_OK)
async def get_foodtypes(db: db_dependency, limit: Union[int, None] = None, offset: Union[int, None] = None):
    query = db.query(models.FoodType)

    if limit:
        query = query.limit(limit)

    if offset:
        query = query.offset(offset)

    return query.all()

@app.get('/foodtype/{foodtype_id}', status_code=status.HTTP_200_OK)
async def get_foodtype_by_id(db: db_dependency, foodtype_id: int):
    return db.query(models.FoodType).filter(models.FoodType.foodTypeId == foodtype_id).first()

@app.post('/foodtype/', status_code=status.HTTP_201_CREATED)
async def create_foodtype(db: db_dependency, foodtype: schemes.FoodTypeBase):
    db_foodtype = models.FoodType(**foodtype.model_dump())
    db.add(db_foodtype)
    db.commit()
    db.refresh(db_foodtype)
    return db_foodtype

@app.delete('/foodtype/{foodtype_id}', status_code=status.HTTP_200_OK)
async def delete_foodtype(db: db_dependency, foodtype_id: int):
    db.query(models.FoodType).filter(models.FoodType.foodTypeId == foodtype_id).delete()
    db.commit()
    return True

@app.patch('/foodtype/{foodtype_id}', status_code=status.HTTP_200_OK)
async def edit_foodtype(db: db_dependency, foodtype_id: int, foodtype: schemes.FoodTypeBase):
    try:
        db_foodtype = db.query(models.FoodType).filter(models.FoodType.foodTypeId == foodtype_id).first()
        update_data = foodtype.dict()
        for key, value in update_data.items():
            setattr(db_foodtype, key, value)
        db.add(db_foodtype)
        db.commit()
        db.refresh(db_foodtype)
        return db_foodtype

    except Exception as f:
        return print(f)

#! Rapport endpoints

@app.get('/rapports', status_code=status.HTTP_200_OK)
async def get_rapport(db: db_dependency, limit: Union[int, None] = None, offset: Union[int, None] = None):
    query = db.query(models.Rapport)

    if limit:
        query = query.limit(limit)

    if offset:
        query = query.offset(offset)

    return query.all()

@app.get('/rapport/{rapport_id}', status_code=status.HTTP_200_OK)
async def get_rapport_by_id(db: db_dependency, rapport_id: int):
    return db.query(models.Rapport).filter(models.Rapport.rapportId == rapport_id).first()

@app.post('/rapport/', status_code=status.HTTP_201_CREATED)
async def create_rapport(db: db_dependency, rapport: schemes.RapportBase):
    db_rapport = models.Rapport(**rapport.model_dump())
    db.add(db_rapport)
    db.commit()
    db.refresh(db_rapport)
    return db_rapport

@app.delete('/rapport/{rapport_id}', status_code=status.HTTP_200_OK)
async def delete_rapport(db: db_dependency, rapport_id: int):
    db.query(models.Rapport).filter(models.Rapport.rapportId == rapport_id).delete()
    db.commit()
    return True

@app.patch('/rapport/{rapport_id}', status_code=status.HTTP_200_OK)
async def edit_rapport(db: db_dependency, rapport_id: int, rapport: schemes.RapportBase):
    try:
        db_rapport = db.query(models.Rapport).filter(models.Rapport.rapportId == rapport_id).first()
        update_data = rapport.dict()
        for key, value in update_data.items():
            setattr(db_rapport, key, value)
        db.add(db_rapport)
        db.commit()
        db.refresh(db_rapport)
        return db_rapport

    except Exception as f:
        return print(f)
@app.get('/animaltypes', status_code=status.HTTP_200_OK)
async def get_animaltypes(db: db_dependency, limit: Union[int, None] = None, offset: Union[int, None] = None):
    query = db.query(models.AnimalType)

    if limit:
        query = query.limit(limit)

    if offset:
        query = query.offset(offset)

    return query.all()

@app.get('/animaltype/{animaltype_id}', status_code=status.HTTP_200_OK)
async def get_animaltype_by_id(db: db_dependency, animaltype_id: int):
    return db.query(models.AnimalType).filter(models.AnimalType.animalTypeId == animaltype_id).first()

@app.post('/animaltype/', status_code=status.HTTP_201_CREATED)
async def create_animaltype(db: db_dependency, animaltype: schemes.AnimalTypeBase):
    db_animaltype = models.AnimalType(**animaltype.model_dump())
    db.add(db_animaltype)
    db.commit()
    db.refresh(db_animaltype)
    return db_animaltype

@app.delete('/animaltype/{animaltype_id}', status_code=status.HTTP_200_OK)
async def delete_animaltype(db: db_dependency, animaltype_id: int):
    db.query(models.AnimalType).filter(models.AnimalType.animalTypeId == animaltype_id).delete()
    db.commit()
    return True

@app.patch('/animaltype/{animaltype_id}', status_code=status.HTTP_200_OK)
async def edit_animaltype(db: db_dependency, animaltype_id: int, animaltype: schemes.AnimalTypeBase):
    try:
        db_animaltype = db.query(models.AnimalType).filter(models.AnimalType.animalTypeId == animaltype_id).first()
        update_data = animaltype.dict()
        for key, value in update_data.items():
            setattr(db_animaltype, key, value)
        db.add(db_animaltype)
        db.commit()
        db.refresh(db_animaltype)
        return db_animaltype

    except Exception as f:
        return print(f)

@app.get('/tasktypes', status_code=status.HTTP_200_OK)
async def get_tasktypes(db: db_dependency, limit: Union[int, None] = None, offset: Union[int, None] = None):
    query = db.query(models.TaskType)

    if limit:
        query = query.limit(limit)

    if offset:
        query = query.offset(offset)

    return query.all()

@app.get('/tasktype/{tasktype_id}', status_code=status.HTTP_200_OK)
async def get_tasktype_by_id(db: db_dependency, tasktype_id: int):
    return db.query(models.TaskType).filter(models.TaskType.taskTypeId == tasktype_id).first()

@app.post('/tasktype/', status_code=status.HTTP_201_CREATED)
async def create_tasktype(db: db_dependency, tasktype: schemes.TaskTypeBase):
    db_tasktype = models.TaskType(**tasktype.model_dump())
    db.add(db_tasktype)
    db.commit()
    db.refresh(db_tasktype)
    return db_tasktype

@app.delete('/tasktype/{tasktype_id}', status_code=status.HTTP_200_OK)
async def delete_tasktype(db: db_dependency, tasktype_id: int):
    db.query(models.TaskType).filter(models.TaskType.taskTypeId == tasktype_id).delete()
    db.commit()
    return True

@app.patch('/tasktype/{tasktype_id}', status_code=status.HTTP_200_OK)
async def edit_tasktype(db: db_dependency, tasktype_id: int, tasktype: schemes.TaskTypeBase):
    try:
        db_tasktype = db.query(models.TaskType).filter(models.TaskType.taskTypeId == tasktype_id).first()
        update_data = tasktype.dict()
        for key, value in update_data.items():
            setattr(db_tasktype, key, value)
        db.add(db_tasktype)
        db.commit()
        db.refresh(db_tasktype)
        return db_tasktype

    except Exception as f:
        return print(f)

@app.get('/messages', status_code=status.HTTP_200_OK)
async def get_messages(db: db_dependency, limit: Union[int, None] = None, offset: Union[int, None] = None):
    query = db.query(models.Message)

    if limit:
        query = query.limit(limit)

    if offset:
        query = query.offset(offset)

    return query.all()

@app.get('/message/{message_id}', status_code=status.HTTP_200_OK)
async def get_message_by_id(db: db_dependency, message_id: int):
    return db.query(models.Message).filter(models.Message.messageId == message_id).first()

@app.post('/message/', status_code=status.HTTP_201_CREATED)
async def create_message(db: db_dependency, message: schemes.MessageBase):
    db_message = models.Message(**message.model_dump())
    db.add(db_message)
    db.commit()
    db.refresh(db_message)
    return db_message

@app.delete('/message/{message_id}', status_code=status.HTTP_200_OK)
async def delete_message(db: db_dependency, message_id: int):
    db.query(models.Message).filter(models.Message.messageId == message_id).delete()
    db.commit()
    return True

@app.patch('/message/{message_id}', status_code=status.HTTP_200_OK)
async def edit_message(db: db_dependency, message_id: int, message: schemes.MessageBase):
    try:
        db_message = db.query(models.Message).filter(models.Message.messageId == message_id).first()
        update_data = message.dict()
        for key, value in update_data.items():
            setattr(db_message, key, value)
        db.add(db_message)
        db.commit()
        db.refresh(db_message)
        return db_message

    except Exception as f:
        return print(f)

#Many to many

@app.get('/usertasks/{user_id}', status_code=status.HTTP_200_OK)
async def get_tasks_user(db: db_dependency, user_id: int):
    return db.query(models.UsersTasks).filter(models.UsersTasks.userId == user_id).all()

@app.get('/tasksusers/{task_id}', status_code=status.HTTP_200_OK)
async def get_users_task(db: db_dependency, task_id: int):
    return db.query(models.UsersTasks).filter(models.UsersTasks.taskId == task_id).all()

@app.post('/usertasks/', status_code=status.HTTP_201_CREATED)
async def create_user_task(db: db_dependency, usertask: schemes.UsersTasksBase):
    db_usertask = models.UsersTasks(**usertask.model_dump())
    db.add(db_usertask)
    db.commit()
    db.refresh(db_usertask)
    return db_usertask

@app.delete('/usertasks/{usertask_id}', status_code=status.HTTP_200_OK)
async def delete_usertask(db: db_dependency, usertask_id: int):
    db.query(models.UsersTasks).filter(models.UsersTasks.userTasksId == usertask_id).delete()
    db.commit()
    return True
@app.patch('/usertasks/{usertask_id}', status_code=status.HTTP_200_OK)
async def edit_usertask(db: db_dependency, usertask_id: int, usertask: schemes.UsersTasksBase):
    try:
        db_usertask = db.query(models.UsersTasks).filter(models.UsersTasks.userTasksId == usertask_id).first()
        update_data = usertask.dict()
        for key, value in update_data.items():
            setattr(db_usertask, key, value)
        db.add(db_usertask)
        db.commit()
        db.refresh(db_usertask)
        return db_usertask

    except Exception as f:
        return print(f)


#! Foodtypes

@app.get('/foodtypeanimal/{animaltype_id}', status_code=status.HTTP_200_OK)
async def get_foodtype_animal(db: db_dependency, animaltype_id: int):
    return db.query(models.FoodTypesAnimals).filter(models.FoodTypesAnimals.animalTypeId == animaltype_id).all()


@app.get('/animalfoodtype/{foodtype_id}', status_code=status.HTTP_200_OK)
async def get_animaltype_foodtype(db: db_dependency, foodtype_id: int):
    return db.query(models.FoodTypesAnimals).filter(models.FoodTypesAnimals.foodTypeId == foodtype_id).all()


@app.post('/foodtypeanimal/', status_code=status.HTTP_201_CREATED)
async def create_foodtype(db: db_dependency, foodtypeanimal: schemes.FoodTypesAnimalsBase):
    db_foodtypeanimal = models.FoodTypesAnimals(**foodtypeanimal.model_dump())
    db.add(db_foodtypeanimal)
    db.commit()
    db.refresh(db_foodtypeanimal)
    return db_foodtypeanimal


@app.delete('/foodtypeanimal/{foodtypeanimal_id}', status_code=status.HTTP_200_OK)
async def delete_foodtype(db: db_dependency, foodtypeanimal_id: int):
    db.query(models.FoodTypesAnimals).filter(models.FoodTypesAnimals.foodTypesAnimalsId == foodtypeanimal_id).delete()
    db.commit()
    return True

@app.patch('/foodtypeanimal/{foodtypeanimal_id}', status_code=status.HTTP_200_OK)
async def edit_foodtype(db: db_dependency, foodtypeanimal_id: int, foodtypeanimal: schemes.FoodTypesAnimalsBase):
    try:
        db_foodtypeanimal = db.query(models.FoodTypesAnimals).filter(models.FoodTypesAnimals.foodTypesAnimalsId == foodtypeanimal_id).first()
        update_data = foodtypeanimal.dict()
        for key, value in update_data.items():
            setattr(db_foodtypeanimal, key, value)
        db.add(db_foodtypeanimal)
        db.commit()
        db.refresh(db_foodtypeanimal)
        return db_foodtypeanimal

    except Exception as f:
        return print(f)

#! Usermessages

@app.get('/usermessage/{user_id}', status_code=status.HTTP_200_OK)
async def get_messages_user(db: db_dependency, user_id: int):
    return db.query(models.UsersMessages).filter(models.UsersMessages.userId == user_id).all()


@app.get('/messageuser/{message_id}', status_code=status.HTTP_200_OK)
async def get_user_message(db: db_dependency, message_id: int):
    return db.query(models.UsersMessages).filter(models.UsersMessages.messageId == message_id).all()


@app.post('/usermessage/', status_code=status.HTTP_201_CREATED)
async def create_usermessage(db: db_dependency, usermessage: schemes.UsersMessagesBase):
    db_usermessage = models.UsersMessages(**usermessage.model_dump())
    db.add(db_usermessage)
    db.commit()
    db.refresh(db_usermessage)
    return db_usermessage


@app.delete('/usermessage/{usermessage_id}', status_code=status.HTTP_200_OK)
async def delete_usermessage(db: db_dependency, usermessage_id: int):
    db.query(models.UsersMessages).filter(models.UsersMessages.usersMessagesId == usermessage_id).delete()
    db.commit()
    return True

@app.patch('/usermessage/{usermessage_id}', status_code=status.HTTP_200_OK)
async def edit_usermessage(db: db_dependency, usermessage_id: int, usermessage: schemes.UsersMessagesBase):
    try:
        db_usermessage = db.query(models.UsersMessages).filter(models.UsersMessages.usersMessagesId == usermessage_id).first()
        update_data = usermessage.dict()
        for key, value in update_data.items():
            setattr(db_usermessage, key, value)
        db.add(db_usermessage)
        db.commit()
        db.refresh(db_usermessage)
        return db_usermessage

    except Exception as f:
        return print(f)


#! Image

@app.post('/rapport/image/{rapport_id}', status_code=status.HTTP_200_OK)
async def add_foto(rapport_id: int, db: db_dependency, files: List[UploadFile] = File(...)):
    rapport_to_upload = db.query(models.Rapport).filter(models.Rapport.rapportId == rapport_id).first()

    if not rapport_to_upload:
        raise HTTPException(status_code=404, detail="rapport not found")

    file_names = []
    for file in files:
        if not file:
            continue

        file.filename = f"{uuid.uuid4()}"
        contents = await file.read()

        file_path = f"images/{file.filename}"
        with open(file_path, "wb") as f:
            f.write(contents)

        file_names.append(file.filename)

    if rapport_to_upload.photos:
        rapport_to_upload.photos += f",{','.join(file_names)}"
    else:
        rapport_to_upload.photos = ",".join(file_names)

    db.add(rapport_to_upload)
    db.commit()
    db.refresh(rapport_to_upload)

    return {"filenames": file_names, "message": "Files uploaded successfully!"}

@app.get('/rapport/{rapport_id}/image', status_code=status.HTTP_200_OK)
async def get_image_user(rapport_id: int, db: db_dependency):
    rapport = db.query(models.Rapport).filter(models.Rapport.rapportId == rapport_id).first()

    if not rapport or not rapport.photos:
        raise HTTPException(status_code=404, detail="No photos found for this rapport")

    fotos = rapport.photos.split(",")
    file_paths = [f'images/{foto}' for foto in fotos]

    return {"files": file_paths}


