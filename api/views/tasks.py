from api.models import *

def task(response, id):
    try:
        t = Task.objects.get(pk=id)
        response.setOk()
        response.data.append(t.fields())
    except Task.DoesNotExist:
        pass
    return response

def taskUsers(response, id):
    if task(response, id).code == 200:
        response.data = [u.fields() for u in User.objects.filter(task__pk=id)]
    return response