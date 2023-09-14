from django.shortcuts import render
from django.views.decorators.csrf import csrf_exempt
from django.http import HttpResponse, JsonResponse
from rest_framework.decorators import api_view, permission_classes, authentication_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework_simplejwt.authentication import JWTAuthentication
from rest_framework_simplejwt.tokens import AccessToken
from run.models import Run
from django.contrib.auth.models import User

@permission_classes([IsAuthenticated])
@csrf_exempt
def addRun(request):
    print("LMAO WHY NOT WORK")
    startTime= request.GET.get('startTime')
    print("starttime not work")
    userId = request.headers['Authorization']
    token = AccessToken(userId.split(' ')[1])
    userId = token.payload['user_id']
    owner = User.objects.get(id=userId)
    r = Run(user=owner, startTime = startTime)
    r.save()
    return HttpResponse()

