from api.models import *

def category(response, id):
    try:
        c = Category.objects.get(pk=id)
        response.code = 200
        response.data.append({
            "id": c.pk,
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
            "id": c.pk,
            "title": c.title,
            "description": c.description,
            "users": users,
            "duration": c.duration,
            "time_created": c.time_created.__str__()
        })
    return response