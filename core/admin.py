from django.contrib import admin
#dev
from .models import Board,Category,Task
admin.site.register(Board)
admin.site.register(Category)
admin.site.register(Task)