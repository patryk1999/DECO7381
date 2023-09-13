from channels.routing import ProtocolTypeRouter, URLRouter
from django.urls import re_path
from . import consumers

application = ProtocolTypeRouter({
    "websocket": URLRouter([
        re_path(r"^ws/voice_channel/$", consumers.VoiceChannelConsumer.as_asgi()),
    ]),
})