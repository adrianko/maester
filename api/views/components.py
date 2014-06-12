from django.conf import settings

def retrieve(file):
    with file(settings.BASE_DIR+"/core/templates/components/"+file+".html") as f:
        s = f.read()
    return s

def task():
    return retrieve("task")