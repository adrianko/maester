from django.db import models
from category import Category
from user import User

class Task(models.Model):
    category = models.ForeignKey(Category)
    title = models.CharField(max_length=1000)
    description = models.CharField(max_length=10000, null=True)
    users = models.ManyToManyField(User, null=True)
    order = models.IntegerField()
    duration = models.IntegerField(null=True)
    time_created = models.IntegerField()

    def fetch(self):
        return {
            "id": self.pk,
            "category_id": self.category_id,
            "title": self.title,
            "description": self.description,
            "users": [u.fetch() for u in User.objects.filter(task__pk=self.pk)],
            "order": self.order,
            "duration": self.duration,
            "time_created": self.time_created
        }

    class Meta:
        db_table = 'task'
        app_label = 'api'