from django.http import HttpResponse
from json import dumps
from response import Response
import boards, categories, tasks, users

def parse(request):
    params = request.path.split('/')
    response = Response()
    if len(params) <= 2:
        response.setMoreInfo()
    else:
        if params[2] == "get":
            response = get(response, params)
        elif params[2] == "set":
            response = set(response, request, params)
        else:
            response.setMoreInfo()

    return HttpResponse(
        dumps(response.serialize(), indent=4),
        content_type="application/json"
    )

#parse get request
def get(response, params):
    if len(params) >= 5:
        item = params[3]
        id = params[4]
        if item == "board":
            if len(params) == 6 and params[5] == "categories":
                response = boards.getCategories(response, id)
            elif len(params) == 5:
                response = boards.get(response, id)
            else:
                response.setInvalid()
        elif item == "category":
            if len(params) == 6 and params[5] == "tasks":
                response = categories.getTasks(response, id)
            elif len(params) == 5:
                response = categories.get(response, id)
            else:
                response.setInvalid()
        elif item == "task":
            if len(params) == 6 and params[5] == "users":
                response = tasks.getUsers(response, id)
            elif len(params) == 5:
                response = tasks.get(response, id)
            else:
                response.setInvalid()
        elif item == "user":
            if len(params) == 6 and params[5] == "tasks":
                response = users.getTasks(response, id)
            elif len(params) == 5:
                response = users.get(response, id)
            else:
                response.setInvalid()
        else:
            response.setInvalid()
    else:
        response.setMoreInfo()
    return response

def set(response, request, params):
    if len(params) >= 5:
        item = params[3]
        action = params[4]
        response.data = {"success": False}
        if item == "board":
            if action == "new":
                response.data = boards.create(request.POST)
            elif action == "update":
                response.data = boards.update(request.POST)
            elif action == "delete":
                response.data = boards.remove(request.POST)
        elif item == "category":
            if action == "new":
                response.data = categories.create(request.POST)
            elif action == "update":
                response.data = categories.update(request.POST)
            elif action == "delete":
                response.data = categories.remove(request.POST)
            elif action == "order":
                response.data = categories.setOrder(request.POST)
        elif item == "task":
            if action == "new":
                response.data = tasks.create(request.POST)
            elif action == "update":
                response.data = tasks.update(request.POST)
            elif action == "delete":
                response.data = tasks.remove(request.POST)
            elif action == "order":
                response.data = tasks.setOrder(request.POST)
        elif item == "user":
            if action == "new":
                response.data = users.create(request.POST)
            elif action == "update":
                response.setOk()
                response.msg = "set update user"
            elif action == "delete":
                response.setOk()
                response.msg = "set delete user"
        response.setOk() if response.data["success"] is True else response.setInvalid()
    else:
        response.setMoreInfo()
    return response