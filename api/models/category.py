from django.db import models
from board import Board


class Category(models.Model):
    board = models.ForeignKey(Board)
    title = models.CharField(max_length=255)
    description = models.CharField(max_length=500, null=True)

    class Meta:
        db_table = 'category'
        app_label = 'api'