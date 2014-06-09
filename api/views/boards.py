from api.models import *

def board(response, id):
    try:
        b = Board.objects.get(pk=id)
        response.code = 200
        response.data.append(b.fields())
    except Board.DoesNotExist:
        pass
    return response

def boardCategories(response, id):
    bc = Category.objects.filter(board_id=id)
    response.code = 200
    response.data = [c.fields() for c in bc]
    return response