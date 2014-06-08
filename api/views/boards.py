from api.models import *

def board(response, id):
    try:
        b = Board.objects.get(pk=id)
        response.code = 200
        response.data.append({
            "id": b.pk,
            "title": b.title,
            "description": b.description
        })
    except Board.DoesNotExist:
        pass
    return response

def boardCategories(response, id):
    bc = Category.objects.filter(board_id=id)
    response.code = 200
    for c in bc:
        response.data.append({
            "id": c.pk,
            "title": c.title,
            "description": c.description
        })
    return response