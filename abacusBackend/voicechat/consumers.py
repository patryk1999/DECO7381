import json
from channels.generic.websocket import AsyncWebsocketConsumer

class VoiceChannelConsumer(AsyncWebsocketConsumer):
    async def connect(self):
        await self.accept()

    async def disconnect(self, close_code):
        pass

    async def receive(self, text_data):
        text_data_json = json.loads(text_data)
        message = text_data_json["message"]

        await self.send(text_data=json.dumps({"message": message}))

    async def voice_channel_message(self, event):
        message = event["message"]

        await self.send(text_data=json.dumps({"message": message}))