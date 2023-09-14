from django.urls import path
from run import views

urlpatterns = [
path('addRun/', views.addRun)
]