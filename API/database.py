from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.ext.declarative import declarative_base

URL_DATABASE = 'mysql+pymysql://root@localhost:3308/lab_planner'

engine = create_engine(
    URL_DATABASE,
    pool_size=40,       # Maximum number of connections in the pool
    max_overflow=0,     # Disables overflow (ensures only pool_size connections exist)
    pool_pre_ping=True, # Tests the connection before using it
    pool_recycle=3600   # Recycles connections after 1 hour (avoiding stale connections)
)
SessionLocal = sessionmaker(autocommit = False, autoflush = False, bind = engine)

Base = declarative_base()
