from api.models import *

def user(response, id):
    try:
        u = User.objects.get(pk=id)
        response.setOk()
        response.data.append(u.fetch())
    except User.DoesNotExist:
        pass
    return response

def userTasks(response, id):
    if user(response, id).code == 200:
        response.data = [t.fetch() for t in Task.objects.filter(users__pk=id)]
    return response