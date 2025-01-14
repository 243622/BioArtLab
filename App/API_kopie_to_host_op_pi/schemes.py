from datetime import datetime
from typing import Annotated,Union

from pydantic import BaseModel


# Statische BaseModellen
class UserBase(BaseModel):
    username: Union[str, None] = None
    password: Union[str, None] = None
    function: Union[int, None] = 0

class TaskBase(BaseModel):
    title: Union[str, None] = None
    description: Union[str, None] = None
    priority: Union[int, None] = None
    taskType: Union[int, None] = None
    finished: Union[int, None] = None
    createdDate: Union[datetime, None] = None
    doneDate: Union[datetime, None] = None
    deadline: Union[datetime, None] = None
    stockId: Union[int, None] = None
    quantity: Union[int, None] = None

class AnimalBase(BaseModel):
    name: Union[str, None] = None
    animalTypeId: Union[int, None] = None
    birthDate: Union[datetime, None] = None
    sicknesses: Union[str, None] = None
    description: Union[str, None] = None

class StockBase(BaseModel):
    quantity: Union[int, None] = None
    foodTypeId: Union[int, None] = None
    minimumQuantity: Union[int, None] = None

class RapportBase(BaseModel):
    title: Union[str, None] = None
    description: Union[str, None] = None
    photos: Union[str, None] = None
    exceptionalities: Union[str, None] = None
    date: Union[datetime, None] = None
    taskId: Union[int, None] = None

class MessageBase(BaseModel):
    title: Union[str, None] = None
    description: Union[str, None] = None

class FoodTypeBase(BaseModel):
    name: Union[str, None] = None

class AnimalTypeBase(BaseModel):
    name: Union[str, None] = None

class TaskTypeBase(BaseModel):
    name: Union[str, None] = None

# Many-Many BaseModellen

class UsersTasksBase(BaseModel):
    userId: Union[int, None] = None
    taskId: Union[int, None] = None

class FoodTypesAnimalsBase(BaseModel):
    foodTypeId: Union[int, None] = None
    animalTypeId: Union[int, None] = None

class UsersMessagesBase(BaseModel):
    userId: Union[int, None] = None
    messageId: Union[int, None] = None





