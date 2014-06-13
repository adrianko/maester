from api.models import *
import components
from datetime import datetime
from json import loads

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
        duration_units = {"h" : 3600, "d": 3600*24, "w": 3600*24*7, "m": 3600*24*7*28}
        du = data.get("data[duration_unit]")
        duration = 0
        if du in duration_units:
            duration = float(data.get("data[duration]"))*duration_units[du]

        t = Task(
            title=data.get("data[title]"),
            description=data.get("data[desc]"),
            category=Category.objects.get(pk=data.get("data[category]")),
            order=data.get("data[order]"),
            duration=duration,
            time_created=datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        )
        t.save()

        response = {"success": True, "id": t.fetch()["id"]}

        for x in loads(data.get("data[users]")):
            x = int(x)
            if x is not 0:
                try:
                    t.users.add(User.objects.get(pk=x))
                    t.save()
                except User.DoesNotExist:
                    pass

        if data["component"] == "1":
            response["components"] = components.task()
    return response