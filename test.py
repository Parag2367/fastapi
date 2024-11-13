from fastapi import FastAPI
from typing import Optional
from pydantic import BaseModel

app = FastAPI()


@app.get('/')
def index():
    return {'index': 'root page'}


#@app.get('/blog/{id}')
#def show(id):
    # fetch blogs with id = id
#    return {'data': id}


@app.get('/blog/unpublished')
def present():
    return {'data': ' all the unpublished data'}


@app.get('/blog/{id}')
def show(id: int):
    # fetch blogs with id = id
    return {'data': id}



@app.get('/blog/{id}/comments')
def comments(id):
    # fetch comments of blog with id = id
    return {'data': {1,2}}



# query parameters

@app.get('/blog')     #way of passing query parameter in url  http://127.0.0.1:8000/blog?limit=50  ,  http://127.0.0.1:8000/blog?limit=50&published=True , http://127.0.0.1:8000/blog?limit=50&published=False 
def show(limit = 10,published : bool = True, sort : Optional[str] = None):         ## added default value and used Optional method which i have imported from typing
    
    # fetch blogs with id = id
    if published:
        return {'data' : f'{limit} published number of blogs'}
    else:
        return {'data' : f'{limit} unpublished number of blogs'}
    
    

class Blog(BaseModel):
    title : str
    author : str
    published : Optional[str]

  
@app.post('/blog')
def blogpost(req : Blog):
    return {'data': f'blog named {req.title} by {req.author} is created'}