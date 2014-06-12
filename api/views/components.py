from django.conf import settings

def retrieve(filename):
    with file(settings.BASE_DIR+"/core/templates/components/"+filename+".html") as f:
        s = f.read()
    return s

def task():
    return retrieve("task")