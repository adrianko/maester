from django.db import models

class Board(models.Model):
    title = models.CharField(max_length=500)
    description = models.CharField(max_length=500, null=True)

    class Meta:
        db_table = 'board'
        app_label = 'api'