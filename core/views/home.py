from django.shortcuts import render_to_response
from requests.models import Board

def home(request):
    return render_to_response("core/home.html", {"boards": Board.objects.all()})