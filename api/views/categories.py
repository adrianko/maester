from api.models import *

def category(response, id):
    try:
        c = Category.objects.get(pk=id)
        response.setOk()
        response.data.append(c.fetch())
    except Category.DoesNotExist:
        pass
    return response

def categoryTasks(response, id):
    if category(response, id).code == 200:
        response.data = [t.fetch() for t in Task.objects.filter(category_id=id)]
    return response