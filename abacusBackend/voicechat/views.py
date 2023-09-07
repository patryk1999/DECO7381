from channels.layers import get_channel_layer
from asgiref.sync import async_to_sync
from django.http import HttpResponse
import json

@async_to_sync
async def send_message(request):
    message = "Hello, WebSocket!"
    channel_layer = get_channel_layer()
    await channel_layer.group_add("voice_channel_group", request.channel_name)
    await channel_layer.group_send(
        "voice_channel_group",
        {
            "type": "voice_channel.message",
            "message": json.dumps({"message": message}),
        },
    )
    return HttpResponse("Message sent to WebSocket clients.")