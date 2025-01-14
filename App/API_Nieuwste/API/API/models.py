from sqlalchemy import Boolean, Column, Integer, String, DECIMAL, Text, Date, ForeignKey, SmallInteger, DateTime
from database import Base
from sqlalchemy.orm import relationship, DeclarativeBase
from uuid import UUID


# Static columns

class Base(DeclarativeBase):
    pass


class User(Base):
    __tablename__ = 'users'
    userId = Column(Integer, primary_key=True, autoincrement=True)
    username = Column(String(100))
    password = Column(String(100))
    function = Column(SmallInteger)

class Task(Base):
    __tablename__ = 'tasks'
    taskId = Column(Integer, primary_key=True, autoincrement=True)
    title = Column(String(100))
    description = Column(Text)
    priority = Column(SmallInteger)
    taskType = Column(Integer, ForeignKey('tasktypes.taskTypeId'))
    finished = Column(SmallInteger)
    createdDate = Column(DateTime, nullable = True)
    doneDate = Column(DateTime)
    deadline = Column(DateTime, nullable=True)
    stockId = Column(Integer, ForeignKey('stocks.stockId'), nullable=True)
    quantity = Column(Integer, nullable=True)
    daily = Column(SmallInteger, nullable=True)
    rapportId = Column(Integer, ForeignKey("rapports.rapportId"))
    animalTypeId = Column(Integer, ForeignKey("animaltypes.animalTypeId"))
    class Config:
        orm_mode = True


class Animal(Base):
    __tablename__ = 'animals'
    animalId = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String(100), nullable=True)
    animalTypeId = Column(Integer, ForeignKey('animaltypes.animalTypeId'))
    birthDate = Column(Date)
    sicknesses = Column(Text, nullable=True)
    description = Column(Text, nullable=True)

class Stock(Base):
    __tablename__ = 'stocks'
    stockId = Column(Integer, primary_key=True, autoincrement=True)
    quantity = Column(Integer)
    foodTypeId = Column(Integer, ForeignKey('foodtypes.foodTypeId'))
    minimumQuantity = Column(Integer)

class Rapport(Base):
    __tablename__ = 'rapports'
    rapportId = Column(Integer, primary_key=True, autoincrement=True)
    title = Column(String(100))
    description = Column(Text)
    photos = Column(Text)
    exceptionalities = Column(Text)
    date = Column(Date)
    userId = Column(Integer, ForeignKey("users.userId"))

class Message(Base):
    __tablename__ = 'messages'
    messageId = Column(Integer, primary_key=True, autoincrement=True)
    title = Column(String(100))
    description = Column(Text)

class FoodType(Base):
    __tablename__ = 'foodtypes'
    foodTypeId = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String(100), nullable=True)

class AnimalType(Base):
    __tablename__ = 'animaltypes'
    animalTypeId = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String(100))

class TaskType(Base):
    __tablename__ = 'tasktypes'
    taskTypeId = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String(100))

# Many-Many relations

class UsersTasks(Base):
    __tablename__ = 'users_tasks'
    userTasksId = Column(Integer, primary_key=True, autoincrement=True)
    userId = Column(Integer, ForeignKey('users.userId'))
    taskId = Column(Integer, ForeignKey('tasks.taskId'))
    daily = Column(Integer)
    createdDate = Column(Date)

class FoodTypesAnimals(Base):
    __tablename__ = 'foodtypes_animals'
    foodTypesAnimalsId = Column(Integer, primary_key=True, autoincrement=True)
    foodTypeId = Column(Integer, ForeignKey('foodtypes.foodTypeId'))
    animalTypeId = Column(Integer, ForeignKey('animaltypes.animalTypeId'))

class UsersMessages(Base):
    __tablename__ = 'users_messages'
    usersMessagesId = Column(Integer, primary_key=True, autoincrement=True)
    userId = Column(Integer, ForeignKey('users.userId'))
    messageId = Column(Integer, ForeignKey('messages.messageId'))

