import json
from channels.generic.websocket import AsyncWebsocketConsumer

class SignalingConsumer(AsyncWebsocketConsumer):
    groups = ['broadcast']
    async def connect(self):
        try:
            room = self.scope['url_route']['kwargs']['room_name']
        except:
            room = 'broadcast'
        if room not in self.groups:
            self.groups.append(room)
        print('connected')
        await self.accept()

    async def disconnect(self, close_code):
        pass  # Disconnect handling

    async def receive(self, text_data):
        print(self.groups)
        if text_data != '':
            message = json.loads(text_data)
        else: 
            message = {}
        message['type'] = 'send_message'
        try:
            room = self.scope['url_route']['kwargs']['room_name']
        except:
            room = 'broadcast'
        index = 0
        for i in range(len(self.groups)):
            if self.groups[i] == room:
                index = i
                break
        await self.channel_layer.group_send(
            self.groups[index], message)
        return
        action = message['action']
        if action == 'user':
            print('user')
            self.groups.append(message['username'])
            print(self.groups)
            # Handle SDP offer
            await self.send(text_data=json.dumps({'action': 'answer', 'sdp': '...'}))
        elif action == 'broadcast':
            print('broadcast')
            self.channel_layer.group_send(
                self.groups[0],
                {
                    'type': 'send_message',
                    'message': 'Hello there!',
                }
            )
        elif action == 'answer':
            # Handle SDP answer
            pass  # Add handling code as needed
        elif action == 'ice':
            # Handle ICE candidate
            pass  # Add handling code as needed
    async def send_message(self, message):
        await self.send(text_data=json.dumps(message))
    
   
       