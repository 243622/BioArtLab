How to migrate:

run:
alembic init alembic

then:
change the target_metadata inside the env.py file inside the alembic folder like this:

on top import the Base:
from models import Base

then at target_metadata set it to:
target_metadata = Base.metadata

inside alembic.ini set the sqlalchemy.url to the database url like the one used in database.py:
sqlalchemy.url = mysql+pymysql://root@localhost:3308/lab_planner

then:
run alembic revision -m "first migrations"
then alembic upgrade head
then alembic revision --autogenerate -m "first migrations"
then once again alembic upgrade head

Should be done

to run the application run:
uvicorn index:app --reload


If specific migration needs to be runned. Follow the above called steps, only change the 'head' to the migration indentifier in alembic upgrade.


