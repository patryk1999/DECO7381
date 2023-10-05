import json
from django.http import HttpResponse, JsonResponse
from rest_framework.decorators import api_view, permission_classes, authentication_classes
from rest_framework.permissions import IsAuthenticated
from django.contrib.auth.models import User
from users.models import Friendship
from django.views.decorators.csrf import csrf_exempt
from rest_framework_simplejwt.authentication import JWTAuthentication
from rest_framework_simplejwt.tokens import AccessToken
from django.db.models import Q

# Create your views here.


@permission_classes([IsAuthenticated])
@csrf_exempt
def makeFriends(request):
    body_unicode = request.body.decode('utf-8')
    body = json.loads(body_unicode)
    username_1 = body['username_1']
    username_2 = body['username_2']

    user_1 = User.objects.get(username= username_1)
    user_2 = User.objects.get(username= username_2)
    f = Friendship(user1 = user_1, user2 = user_2)
    f.save()

    return HttpResponse(status=200)

@permission_classes([IsAuthenticated])
@csrf_exempt
def getAllUsers(request):
 
    listOfUsers = {}
    allUsers = User.objects.all()
    for user in allUsers:
        user_info = [user.first_name, user.last_name, user.email, user.username]
        listOfUsers[user.id] = user_info 
    
    print(listOfUsers)
    return JsonResponse(listOfUsers)


@csrf_exempt
def makeUser(request):
    body_unicode = request.body.decode('utf-8')
    body = json.loads(body_unicode)
    new_username = body['username']
    new_email = body['email']
    new_password = body['password']
    user = User.objects.create_user(username=new_username, email=new_email, password=new_password)
    user.save()
    return HttpResponse(status=200)

@authentication_classes([JWTAuthentication])
@permission_classes([IsAuthenticated])
@csrf_exempt
def getFriends(request):
    #Get userID from the token
    user_id = request.headers['Authorization']
    token = AccessToken(user_id.split(' ')[1])
    user_id = token.payload['user_id']
    #Get the list of friends based on userIDs and add them to a list
    friends = Friendship.objects.filter(Q(user1_id = user_id) | Q(user2_id = user_id))
    list_of_friends = []
    for friend in friends:
        list_of_friends.append({friend.user1_id})
        list_of_friends.append({friend.user2_id})
    #Make a list with usernames instead of userIds
    list_of_user_data = {}
    for friend in list_of_friends:
        friend_obj = User.objects.get(id=list(friend)[0])
        user_info = [friend_obj.first_name, friend_obj.last_name, friend_obj.email, friend_obj.username]
        list_of_user_data[friend_obj.id] = user_info

    return JsonResponse(list_of_user_data,safe=False, status=200)