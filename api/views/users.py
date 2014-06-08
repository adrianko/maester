from api.models import *

def user(response, id):
    try:
        u = User.objects.get(pk=id)
        response.code = 200
        response.data.append({
            "id": u.pk,
            "username": u.username
        })
    except User.DoesNotExist:
        pass
    return response

def userTasks(response, id):
    ut = Task.objects.filter(user__pk=id)
    response.code = 200
    for t in ut:
        u = User.objects.filter(task__pk=t.pk)
        users = [x.username for x in u]
        response.data.append({
            "id": t.pk,
            "title": t.title,
            "description": t.description,
            "users": users,
            "duration": t.duration,
            "time_created": t.time_created.__str__()
        })
    return response