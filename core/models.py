from django.db import models

class Board(models.Model):
    title = models.CharField(max_length=500)
    description = models.CharField(max_length=500, null=True)

class Category(models.Model):
    board = models.ForeignKey(Board)
    title = models.CharField(max_length=255)
    description = models.CharField(max_length=500, null=True)

class Task(models.Model):
    category = models.ForeignKey(Category)
    title = models.CharField(max_length=1000)
    description = models.CharField(max_length=10000, null=True)
    duration = models.IntegerField(null=True)
    time_created = models.DateTimeField()