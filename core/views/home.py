from django.shortcuts import render_to_response
from api.models import Board, User
from django.core.context_processors import csrf

def home(request):
    return render_to_response(
        "core/home.html",
        {
            "page_title": "Home",
            "boards": Board.objects.all(),
            "users": User.objects.all(),
            "csrf_token": csrf(request)['csrf_token']
        }
    )