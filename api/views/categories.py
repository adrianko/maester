from api.models import *

def category(response, id):
    try:
        c = Category.objects.get(pk=id)
        response.setOk()
        response.data.append(c.fields())
    except Category.DoesNotExist:
        pass
    return response

def categoryTasks(response, id):
    if category(response, id).code == 200:
        response.data = [t.fields() for t in Task.objects.filter(category_id=id)]
    return response