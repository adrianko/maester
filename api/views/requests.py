from django.http import HttpResponse
from json import dumps
from boards import *

#response class
class Response:
    def __init__(self):
        self.code = 404
        self.data = []

    def dataDump(self):
        return self.__dict__

#parse get request
def get(request):
    params = request.path.split('/')
    response = Response()
    item = params[3]
    id = params[4]
    if item == "board":
        if len(params) == 6 and params[5] == "categories":
            response = boardCategories(response, id)
        else:
            response = board(response, id)
    elif item == "category":
        if len(params) == 6 and params[5] == "tasks":
            response = categoryTasks(response, id)
        else:
            response = category(response, id)
    elif item == "task":
        if len(params) == 6 and params[5] == 'users':
            response = taskUsers(response, id)
        else:
            response = task(response, id)
    else:
        pass
    return HttpResponse(dumps(response.dataDump()), content_type="application/json")

def set(request):
    pass