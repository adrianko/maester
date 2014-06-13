from django.conf.urls import url

urlpatterns = [
    url(r'^', 'api.views.parse'),
]