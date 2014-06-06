from django.shortcuts import render_to_response
from django.http import HttpResponse
from core.models import Board

def home(request):
    return render_to_response("core/home.html", {"boards": Board.objects.all()})

def board(request):
    id = request.path.split('/')[2]
    b = Board.objects.get(pk=id)
    return render_to_response("core/board.html", {"title": b.title, "description": b.description})