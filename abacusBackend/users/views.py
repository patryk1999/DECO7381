import json
from django.http import HttpResponse
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from django.contrib.auth.models import User
from users.models import Friendship
from django.views.decorators.csrf import csrf_exempt

# Create your views here.

#@api_view(['GET'])
@permission_classes([IsAuthenticated])
def test(request):
    return HttpResponse("I am Ok")

#@permission_classes([IsAuthenticated])
@csrf_exempt
def makeFriends(request):
    # username_1 = request[username_1]
    # username_2 = request[username_2]

    body_unicode = request.body.decode('utf-8')
    body = json.loads(body_unicode)
    username_1 = body['username_1']
    username_2 = body['username_2']

    user_1 = User.objects.get(username= username_1)
    user_2 = User.objects.get(username= username_2)
    f = Friendship(user1 = user_1, user2 = user_2)
    f.save()

    return HttpResponse("I am Ok")