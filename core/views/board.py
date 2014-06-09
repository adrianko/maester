from django.shortcuts import render_to_response
from django.http.response import HttpResponseNotFound
from api.models import Board

def board(request):
    id = int(request.path.split('/')[2])
    try:
        b = Board.objects.get(pk=id)
        return render_to_response("core/board.html", {"title": b.title, "description": b.description})
    except Board.DoesNotExist:
        return HttpResponseNotFound("Not Found")
