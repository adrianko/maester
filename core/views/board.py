from django.shortcuts import render_to_response, get_object_or_404
from django.http.response import HttpResponseNotFound
from core.models import Board

def board(request):
    id = int(request.path.split('/')[2])
    b = get_object_or_404(Board, pk=id)
    return render_to_response("core/board.html", {"title": b.title, "description": b.description})
