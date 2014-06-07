from django.db import models
from category import Category

class Task(models.Model):
    category = models.ForeignKey(Category)
    title = models.CharField(max_length=1000)
    description = models.CharField(max_length=10000, null=True)
    duration = models.IntegerField(null=True)
    time_created = models.DateTimeField()

    class Meta:
        db_table = 'task'
        app_label = 'core'