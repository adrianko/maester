from django.conf.urls import include, url

urlpatterns = [
    url(r'^api', include('api.urls')),
    url(r'^board/[0-9]+$', 'core.views.board'),
    url(r'^$', 'core.views.home')
]