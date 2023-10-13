import json
from channels.generic.websocket import AsyncWebsocketConsumer

class SignalingConsumer(AsyncWebsocketConsumer):
    # groups = ['broadcast']
    # async def connect(self):
    #     try:
    #         room = self.scope['url_route']['kwargs']['room_name']
    #     except:
    #         room = 'broadcast'
    #     if room not in self.groups:
    #         self.groups.append(room)
    #     print('connected')
    #     await self.accept()

    # async def disconnect(self, close_code):
    #     print('disconnected')
    #     pass 

    # async def receive(self, text_data):
    #     print(self.groups)
    #     message = json.loads(text_data)
    #     print(message)
    #     try:
    #         room = self.scope['url_route']['kwargs']['room_name']
    #     except:
    #         room = 'broadcast'
    #     index = 0
    #     for i in range(len(self.groups)):
    #         if self.groups[i] == room:
    #             index = i
    #             break
    #     message['type'] = 'websocket_receive'
    #     await self.channel_layer.group_send(
    #         self.groups[index], message)
        
    # async def websocket_receive(self, event):
    #     await self.send(json.dumps(event))
    async def connect(self):
        try:
            self.room_name = self.scope['url_route']['kwargs']['room_name']
        except:
            self.room_name = 'broadcast'
        self.room_group_name = f"chat_{self.room_name}"

        await self.channel_layer.group_add(
            self.room_group_name,
            self.channel_name
        )
        print('connected')
        await self.accept()

    async def disconnect(self, close_code):
        # Leave room group
        await self.channel_layer.group_discard(
            self.room_group_name,
            self.channel_name
        )

    # Receive message from WebSocket
    async def receive(self, text_data):
        try:
            text_data_json = json.loads(text_data)
            message = text_data_json.get('message', '')
        except json.JSONDecodeError:
            message = ''
            
        print(message)
        if message:
            # Send message to room group
            await self.channel_layer.group_send(
                self.room_group_name,
                {
                    'type': 'chat.message',
                    'message': message
                }
        )

    # Receive message from room group
    async def chat_message(self, event):
        message = event['message']

        # Send message to WebSocket
        await self.send(text_data=json.dumps(message))
   
       