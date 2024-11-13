#def name (fname,lname):
#    return fname + ' ' + lname

def name (fname: str | list,lname: str = None):
#def name (fname: str,lname: str):   # Python type checking to make sure a certain type of data type is only allowed for a variable
    #fname.append() fname.capitalize()
    return fname + ' ' + lname


fname = 'bill'
lname = 'Gates'

value = name(fname.capitalize(),lname)    
print(value)