from api.models import *

def user(response, id):
    try:
        u = User.objects.get(pk=id)
        response.setOk()
        response.data.append(u.fields())
    except User.DoesNotExist:
        pass
    return response

def userTasks(response, id):
    ut = Task.objects.filter(user__pk=id)
    response.setOk()
    response.data = [t.fields() for t in ut]
    return response