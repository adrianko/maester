from api.models import *

def get(response, id):
    try:
        t = Task.objects.get(pk=id)
        response.setOk()
        response.data.append(t.fetch())
    except Task.DoesNotExist:
        pass
    return response

def getUsers(response, id):
    if get(response, id).code == 200:
        response.data = [u.fetch() for u in User.objects.filter(task__pk=id)]
    return response

def new(request):
    pass