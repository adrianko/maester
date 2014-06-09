from api.models import *

def task(response, id):
    try:
        t = Task.objects.get(pk=id)
        response.setOk()
        response.data.append(t.fetch())
    except Task.DoesNotExist:
        pass
    return response

def taskUsers(response, id):
    if task(response, id).code == 200:
        response.data = [u.fetch() for u in User.objects.filter(task__pk=id)]
    return response