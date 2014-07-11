from api.models import *
import components

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
        background = data.get("background")
        if background[0] == "#":
            background = background[1:]

        b = Board(
            title=data.get("title"),
            description=data.get("description"),
            background=background
        )
        b.save()
        response = {"success": True, "request": data, "id": b.fetch()["id"], "background": background}
        if data["component"] == "1":
            response["components"] = components.boarditem()
    return response

def remove(data):
    if data == {}:
        response = {"success": False, "request": data}
    else:
        id = data.get("id")
        try:
            b = Board.objects.get(pk=id)
            cs = Category.objects.filter(board_id=b)
            for c in cs:
                Task.objects.filter(category_id=c).delete()
                c.delete()
            b.delete()
        except Board.DoesNotExist:
            pass
        response = {"success": True}
    return response

def update(data):
    if data == {}:
        response = {"success": False, "request": data}
    else:
        id = data.get("id")
        title = data.get("title")
        description = data.get("description")
        background = data.get("background")
        if background[0] == "#":
            background = background[1:]
        try:
            b = Board.objects.get(pk=id)
            b.title = title
            b.description = description
            b.background = background
            b.save(update_fields=["title", "description", "background"])
        except Board.DoesNotExist:
            pass
        response = {"success": True, "request": data}
    return response