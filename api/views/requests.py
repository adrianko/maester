from django.http import HttpResponse
from json import dumps
import boards
import categories
import tasks
import users

#response class
class Response:
    def __init__(self):
        self.code = 404
        self.msg = ""
        self.data = []

    def serialize(self):
        return self.__dict__

def parse(request):
    params = request.path.split('/')
    response = Response()
    if len(params) <= 2:
        return moreInfoMsg()
    else:
        if params[2] == "get":
            response = get(response, params)
        elif params[2] == "set":
            response = set(response, params)
        else:
            response = moreInfoMsg(response)

    return HttpResponse(dumps(response.serialize(), indent=4), content_type="application/json")

def moreInfoMsg(response):
    response.code = 400
    response.msg = "More information required"
    return response

#parse get request
def get(response, params):
    if len(params) >= 5:
        item = params[3]
        id = params[4]
        if item == "board":
            if len(params) == 6 and params[5] == "categories":
                response = boards.boardCategories(response, id)
            else:
                response = boards.board(response, id)
        elif item == "category":
            if len(params) == 6 and params[5] == "tasks":
                response = categories.categoryTasks(response, id)
            else:
                response = categories.category(response, id)
        elif item == "task":
            if len(params) == 6 and params[5] == "users":
                response = tasks.taskUsers(response, id)
            else:
                response = tasks.task(response, id)
        elif item == "user":
            if len(params) == 6 and params[5] == "tasks":
                response = users.userTasks(response, id)
            else:
                response = users.user(response, id)
        else:
            pass
    else:
        response = moreInfoMsg(response)
    return response

def set(response, params):
    return response