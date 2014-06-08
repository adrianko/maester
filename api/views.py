from django.shortcuts import render
from django.http import HttpResponse
from json import dumps as jdumps
from api.models import Board

def response(request):
    response = {}
    #do stuff

    return HttpResponse(jdumps(response), content_type="application/json")
