from django.conf import settings

def task():
    with file(settings.BASE_DIR+"/core/templates/components/task.html") as f:
        s = f.read()
    return s