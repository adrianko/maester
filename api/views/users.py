from api.models import *
import hashlib, urllib2
from django.conf import settings

def get(response, id):
    try:
        u = User.objects.get(pk=id)
        response.setOk()
        response.data.append(u.fetch())
    except User.DoesNotExist:
        pass
    return response

def getTasks(response, id):
    if get(response, id).code == 200:
        response.data = [t.fetch() for t in Task.objects.filter(users__pk=id)]
    return response

def getGravatar(id):
    try:
        default = settings.BASE_DIR+"/static/img/default-avatar.jpg"
        email = User.objects.get(pk=id).fetch()["email"]
        email_hash = hashlib.md5(email.lower()).hexdigest()
        url = "http://www.gravatar.com/avatar/"+email_hash+"?d="+default+"&s="+str(50)
        try:
            file = urllib2.urlopen(url)
            local = open(settings.BASE_DIR+"/cache/img/"+email_hash+".jpg", "w+")
            local.write(file.read())
            local.close()
        except urllib2.URLError:
            pass
    except User.DoesNotExist:
        pass

def create(data):
    username = data.get("username")
    email = data.get("email")
    users = User.objects.filter(username=username).count()
    emails = User.objects.filter(email=email).count()
    if users == 0 and emails == 0:
        u = User(
            username=username,
            email=email
        )
        u.save()
        response = {"success": True}
    else:
        response = {"success": False, "request": data}
    return response