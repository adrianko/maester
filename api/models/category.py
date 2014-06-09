from django.db import models
from board import Board

class Category(models.Model):
    board = models.ForeignKey(Board)
    title = models.CharField(max_length=255)
    description = models.CharField(max_length=500, null=True)

    def fields(self):
        return {"id": self.pk, "board_id": self.board_id, "title": self.title, "description": self.description}

    class Meta:
        db_table = 'category'
        app_label = 'api'