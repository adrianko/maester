from django.db import models
from category import Category
from user import User

class Task(models.Model):
    category = models.ForeignKey(Category)
    title = models.CharField(max_length=1000)
    description = models.CharField(max_length=10000, null=True)
    users = models.ManyToManyField(User)
    duration = models.IntegerField(null=True)
    time_created = models.DateTimeField()

    def fields(self):
        us = User.objects.filter(task__pk=self.pk)
        users = [u.fields() for u in us]
        return {
            "id": self.pk,
            "category_id": self.category_id,
            "title": self.title,
            "description": self.description,
            "users": users,
            "duration": self.duration,
            "time_created": self.time_created.__str__()
        }

    class Meta:
        db_table = 'task'
        app_label = 'api'