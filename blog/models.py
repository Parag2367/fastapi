from sqlalchemy import Column, Integer, String
from . database import Base          # importing Base from database


class Blog(Base):                                     # this section connects model to database file
    __tablename__ = 'blogs'
    id = Column(Integer, primary_key = True, index = True)
    title = Column(String)
    body = Column(String)
    