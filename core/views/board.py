from django.shortcuts import render_to_response
from core.models import Board

def board(request):
    id = int(request.path.split('/')[2])
    b = Board.objects.get(pk=id)
    return render_to_response("core/board.html", {"title": b.title, "description": b.description})