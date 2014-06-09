from django.shortcuts import render_to_response
from django.http.response import HttpResponseNotFound, Http404
from api.models import Board

def board(request):
    id = int(request.path.split('/')[2])
    try:
        b = Board.objects.get(pk=id).fields()
        b["page_title"] = "Board: "+b["title"]
        return render_to_response("core/board.html", b)
    except Board.DoesNotExist:
        raise Http404
