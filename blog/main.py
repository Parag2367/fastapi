from fastapi import FastAPI , Depends , status , Response , HTTPException # Depends is added for database session #added status for status code # added
# added Response to give us custom status_code incase of error , etc
# HTTPException can also be used to give status code as this is similar to Response
# from pydantic import BaseModel  moved it to schemas.py
from . import schemas # this (.) is for same directory  

from . import models

from .database import engine , SessionLocal
from sqlalchemy.orm import Session    # this is for db instance

models.Base.metadata.create_all(engine)    # most important line for database connection


app = FastAPI()

def get_db():    # created this function for database
    db =SessionLocal()
    try:
        yield db
    finally:
        db.close()

#class Blog(BaseModel):
#    title: str
#    body: str         Moved it to schemas.py

#@app.post('/blog')
#def create (request: schemas.Blog):
#    return request


@app.post('/blog', status_code=201)#status_code = status.HTTP_201_CREATED)        # this section is for database storage functionality added a status code which overwrites already given code when we execute, also have shown two ways of giving status code
def create (request: schemas.Blog, db: Session = Depends(get_db)):
    new_blog = models.Blog(title = request.title, body = request.body)
    db.add(new_blog)
    db.commit()
    db.refresh(new_blog)
    
    return new_blog

@app.get('/blog')                # this section is for getting blogs / data
def all(db : Session = Depends(get_db)):
    blogs = db.query(models.Blog).all()
    return blogs

@app.get('/blog/{id}',status_code = 200)
def show(id, response : Response, db: Session =Depends(get_db)):
    blogs = db.query(models.Blog).filter(models.Blog.id == id).first()
    if not blogs:
        raise HTTPException(status_code = status.HTTP_404_NOT_FOUND, detail = f'Blog with id {id} is not in database')  # way to use HTTPException using raise
        #response.status_code = status.HTTP_404_NOT_FOUND
        #return {'detail': f'Blog with id {id} is not in database'}
    return blogs