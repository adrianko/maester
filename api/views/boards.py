from api.models import *

def board(response, id):
    try:
        b = Board.objects.get(pk=id)
        response.setOk()
        response.data.append(b.fetch())
    except Board.DoesNotExist:
        pass
    return response

def boardCategories(response, id):
    if board(response, id).code == 200:
        response.data = [c.fetch() for c in Category.objects.filter(board_id=id)]
    return response