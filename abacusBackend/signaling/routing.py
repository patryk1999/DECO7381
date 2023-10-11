from django.urls import re_path, path
from signaling import consumer
from channels.routing import ProtocolTypeRouter, URLRouter

websocket_urlpatterns = [
    path("<str:room_name>/", consumer.SignalingConsumer.as_asgi()),
    path("", consumer.SignalingConsumer.as_asgi())
]  