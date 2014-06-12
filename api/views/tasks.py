from api.models import *
import components
from datetime import datetime

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

def create(data):
    if data == {}:
        response = {"success": False, "request": data}
    else:
        #description, users, duration
        t = Task.objects.create(
            title=data.get("data[title]"),
            category=Category.objects.get(pk=data.get("data[category]")),
            order=data.get("data[order]"),
            time_created=datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        )
        response = {"success": True, "id": t.fetch()["id"]}
        if data["component"] == "1":
            response["components"] = components.task()
    return response