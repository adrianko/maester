from api.models import *

def task(response, id):
    try:
        t = Task.objects.get(pk=id)
        response.code = 200
        response.data.append(t.fields())
    except Task.DoesNotExist:
        pass
    return response

def taskUsers(response, id):
    us = User.objects.filter(task__pk=id)
    response.code = 200
    response.data = [u.fields() for u in us]
    return response