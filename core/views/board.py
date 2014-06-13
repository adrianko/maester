from django.shortcuts import render_to_response
from django.http.response import Http404
from api.models import Board, Category, Task, User

def board(request):
    id = int(request.path.split('/')[2])
    try:
        b = Board.objects.get(pk=id).fetch()
        b["page_title"] = "Board: "+b["title"]
        b["categories"] = [c.fetch() for c in Category.objects.filter(board_id=id).order_by("order")]
        for c in b["categories"]:
            c["tasks"] = [t.fetch() for t in Task.objects.filter(category_id=c["id"]).order_by("order")]
        b["users"] = [u.fetch() for u in User.objects.all()]
        return render_to_response("core/board.html", b)
    except Board.DoesNotExist:
        raise Http404
