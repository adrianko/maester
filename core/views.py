from django.shortcuts import render_to_response
from django.http import HttpResponse
from core.models import Board

def home(request):
    return render_to_response("core/home.html", {"boards": Board.objects.all()})

def board(request):
    id = request.path.split('/')[2]
    return HttpResponse("<h1>"+Board.objects.get(pk=id).title+"</h1>")