from django.shortcuts import render
from django.views.decorators.csrf import csrf_exempt
from django.http import HttpResponse, JsonResponse
from rest_framework.decorators import api_view, permission_classes, authentication_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework_simplejwt.authentication import JWTAuthentication
from rest_framework_simplejwt.tokens import AccessToken
from run.models import Run, Location
from django.contrib.auth.models import User


#Adding concurrent run is still not working
@permission_classes([IsAuthenticated])
@csrf_exempt
def addRun(request):
    startTime= request.GET.get('startTime')
    userId = request.headers['Authorization']
    token = AccessToken(userId.split(' ')[1])
    userId = token.payload['user_id']
    owner = User.objects.get(id=userId)
    endTime = request.GET.get('endTime')
    avgPace = request.GET.get('avgPace')
    r = Run(user=owner, startTime = startTime, endTime = endTime, avgPace = avgPace)
    r.save()
    return HttpResponse(r.id, status=200)


@permission_classes([IsAuthenticated])
@csrf_exempt
def updateConcurrentRun(request):
    concurrentRun = request.GET.get('concurrentRun')
    runToUpdate = request.GET.get('runToUpdate')
    r = Run.objects.get(id=runToUpdate)
    r.concurrentRun = concurrentRun 
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

@permission_classes([IsAuthenticated])
@csrf_exempt
def getHistory(request):
    userId = request.headers['Authorization']
    token = AccessToken(userId.split(' ')[1])
    userId = token.payload['user_id']
    history = Run.objects.filter(user=userId)
   # print(history)
    historyDict = {}
    for run in history:
       attributeArray = {}
       attributeArray['startTime'] = run.startTime.strftime("%Y-%m-%d %H:%M:%S")
       attributeArray['endTime'] = run.endTime.strftime("%Y-%m-%d %H:%M:%S")
       attributeArray['avgPace'] = run.avgPace
       historyDict[run.created_at.strftime("%Y-%m-%d %H:%M:%S")] = attributeArray
    print(historyDict)
    return HttpResponse(historyDict)