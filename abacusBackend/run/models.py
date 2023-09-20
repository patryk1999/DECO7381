from datetime import timezone
from django.db import models
from django.contrib.auth.models import User

class Run(models.Model):
    user = models.ForeignKey(User,on_delete=models.CASCADE)
    concurrentRun = models.ForeignKey('self',on_delete=models.SET_NULL,null=True,default=None)
    startTime = models.DateTimeField(auto_now=False, auto_now_add=False)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

class Location(models.Model):
    latitude = models.FloatField()
    longitude = models.FloatField()
    runId = models.ForeignKey(Run, on_delete=models.CASCADE)

    


