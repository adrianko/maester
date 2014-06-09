from django.db import models

class Board(models.Model):
    title = models.CharField(max_length=500)
    description = models.CharField(max_length=500, null=True)

    def fetch(self):
        return {"id": self.pk, "title": self.title, "description": self.description}

    class Meta:
        db_table = 'board'
        app_label = 'api'