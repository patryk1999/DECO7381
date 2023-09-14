from django.db import models
from django.contrib.auth.models import User

# Create your models here.
class Friendship(models.Model):
    user1 = models.ForeignKey(User,related_name = 'friend_1',on_delete=models.CASCADE)
    user2 = models.ForeignKey(User,related_name = 'friend_2', on_delete=models.CASCADE)
    
