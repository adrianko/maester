from django.db import models

class User(models.Model):
    username = models.CharField(max_length=255)
    email = models.CharField(max_length=255)

    def fetch(self):
        return {"id": self.pk, "username": self.username, "email": self.email}

    class Meta:
        db_table = 'user'
        app_label = 'api'