from django.urls import path
from run import views

urlpatterns = [
path('addRun/', views.addRun),
path('addLocation/', views.addLocation),
path('getHistory/', views.getHistory),
path('updateConcurrentRun/', views.updateConcurrentRun)
]