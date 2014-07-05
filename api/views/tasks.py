from api.models import *
import components
from time import time
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
        duration_units = {"h" : 3600, "d": 3600*24, "w": 3600*24*7, "m": 3600*24*7*4}
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
            time_created=int(time())
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

def setOrder(data):
    if data == {}:
        response = {"success": False, "request": data}
    else:
        order = loads(data.get("order"))
        for category, list in order.iteritems():
            for x in range(0, len(list)):
                try:
                    t = Task.objects.get(pk=int(list[x]))
                    t.order = (x+1)
                    t.category_id = int(category)
                    t.save(update_fields=["order", "category_id"])
                except Task.DoesNotExist:
                    pass
        response = {"success": True}
    return response

def update(data):
    if data == {}:
        response = {"success": False, "request": data}
    else:
        id = data.get("id")
        field = data.get("field")
        value = data.get("value")
        try:
            t = Task.objects.get(pk=id)
            if field == "title":
                t.title = value
            elif field == "description":
                t.description = value
            elif field == "duration":
                duration_units = {"h" : 3600, "d": 3600*24, "w": 3600*24*7, "m": 3600*24*7*4}
                d = data.get("value")
                duration, du = d[:-1], d[-1]
                if du in duration_units:
                    duration = float(duration)*duration_units[du]
                t.duration = duration
            t.save()
        except Task.DoesNotExist:
            pass
        response = {"success": True}
    return response

def remove(data):
    if data == {}:
        response = {"success": False, "request": data}
    else:
        id = data.get("id")
        try:
            t = Task.objects.get(pk=id)
            t.delete()
        except Task.DoesNotExist:
            pass
        response = {"success": True, "request": data}
    return response