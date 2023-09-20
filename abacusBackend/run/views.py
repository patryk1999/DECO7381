from django.shortcuts import render
from django.views.decorators.csrf import csrf_exempt
from django.http import HttpResponse, JsonResponse
from rest_framework.decorators import api_view, permission_classes, authentication_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework_simplejwt.authentication import JWTAuthentication
from rest_framework_simplejwt.tokens import AccessToken
from run.models import Run, Location
from django.contrib.auth.models import User

@permission_classes([IsAuthenticated])
@csrf_exempt
def addRun(request):
    startTime= request.GET.get('startTime')
    userId = request.headers['Authorization']
    token = AccessToken(userId.split(' ')[1])
    userId = token.payload['user_id']
    owner = User.objects.get(id=userId)
    r = Run(user=owner, startTime = startTime)
    r.save()
    return HttpResponse(status=200)


@permission_classes([IsAuthenticated])
@csrf_exempt
def addLocation(request):
    latitude = request.GET.get('latitude')
    longitude = request.GET.get('longitude')
    runID = request.GET.get('runID')
    runObj = Run.objects.get(pk=runID)
    l = Location(runId = runObj,latitude=latitude, longitude=longitude)
    l.save()
    return HttpResponse(status=200)
