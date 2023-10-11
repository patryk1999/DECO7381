from channels.routing import ProtocolTypeRouter, URLRouter
import os
import django
from django.core.asgi import get_asgi_application
from signaling.routing import websocket_urlpatterns

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'abacusBackend.settings')

#django.setup()

application = ProtocolTypeRouter({
            "http": get_asgi_application(),
            "websocket": URLRouter(websocket_urlpatterns) 
                       })