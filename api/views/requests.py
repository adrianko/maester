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
    return HttpResponse(dumps(response.dataDump(), indent=4), content_type="application/json")

def set(request):
    pass