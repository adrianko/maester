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

def create(data):
    if data == {}:
        response = {"success": False, "request": data}
    else:
        b = Board(
            title=data.get("title"),
            description=""
        )
        b.save()
        response = {"success": True, "request": data, "id": b.fetch()["id"]}
    return response