from api.models import *

def board(response, id):
    try:
        b = Board.objects.get(pk=id)
        response.code = 200
        response.data.append({
            "id": b.id,
            "title": b.title,
            "description": b.description
        })
    except Board.DoesNotExist:
        pass
    return response

def boardCategories(response, id):
    bc = Category.objects.filter(board_id=id)
    response.code = 200
    for c in bc:
        response.data.append({
            "id": c.id,
            "title": c.title,
            "description": c.description
        })
    return response

def category(response, id):
    try:
        c = Category.objects.get(pk=id)
        response.code = 200
        response.data.append({
            "id": c.id,
            "title": c.title,
            "description": c.description
        })
    except Category.DoesNotExist:
        pass
    return response

def categoryTasks(response, id):
    ct = Task.objects.filter(category_id=id)
    response.code = 200
    for c in ct:
        t = User.objects.filter(task__pk=c.pk)
        users = [x.username for x in t]
        response.data.append({
            "id": c.id,
            "title": c.title,
            "description": c.description,
            "users": users
        })
    return response

def task(response, id):
    pass

def taskUsers(response, id):
    pass

def userTasks(response, id):
    pass