from django.conf.urls import patterns, include, url
from django.contrib import admin

admin.autodiscover()

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'maester.views.home', name='home'),
    # url(r'^blog/', include('blog.urls')),

    #dev only
    url(r'^admin/', include(admin.site.urls)),

    url(r'^$', 'core.views.home'),
    url(r'^board/[0-9]+$', 'core.views.board'),
    url(r'^api/[0-9a-zA-Z\/_-]+$', 'api.views.response'),
)