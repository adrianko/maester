from api.models import *

def task(response, id):
    try:
        t = Task.objects.get(pk=id)
        u = User.objects.filter(task__pk=t.pk)
        users = [x.username for x in u]
        response.code = 200
        response.data.append({
            "id": t.pk,
            "title": t.title,
            "description": t.description,
            "users": users,
            "duration": t.duration,
            "time_created": t.time_created.__str__()
        })
    except Task.DoesNotExist:
        pass
    return response

def taskUsers(response, id):
    us = User.objects.filter(task__pk=id)
    response.code = 200
    for u in us:
        response.data.append({
            "id": u.pk,
            "username": u.username
        })
    return response