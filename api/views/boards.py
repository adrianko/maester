from api.models import *

def get(response, id):
    try:
        b = Board.objects.get(pk=id)
        response.setOk()
        response.data.append(b.fetch())
    except Board.DoesNotExist:
        pass
    return response

def getCategories(response, id):
    if get(response, id).code == 200:
        response.data = [c.fetch() for c in Category.objects.filter(board_id=id)]
    return response