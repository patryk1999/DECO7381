import django
import os
from django.conf import settings

# Set the DJANGO_SETTINGS_MODULE environment variable
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'abacusBackend.settings')

django.setup()

# Configure Django settings
#settings.configure()



from django.db import models
from django.contrib.auth.models import User
from run.models import Run, Location
from users.models import Friendship


# User db with admin, pat, ryan and emma <3
user1 = User.objects.create_user(username='admin', email='admin@admin.com', password='admin', last_name = 'adminski', first_name = 'admin')
user2 = User.objects.create_user(username='pat', email='pat@pat.com', password='pat', last_name = 'Kuklinski', first_name = 'Patryk')
user3 = User.objects.create_user(username='ryan123', email='ryan@gosling.com', password='driver123', last_name = 'Gosling', first_name = 'Ryan')
user4 = User.objects.create_user(username='emma_st', email='emma@stone.com', password='admin', last_name = 'Stone', first_name = 'Emma')

user1.save()
user2.save()
user3.save()
user4.save()


# Now making db of runs
owner1 = User.objects.get(id=1)
owner2 = User.objects.get(id=2)
owner3 = User.objects.get(id=3)
owner4 = User.objects.get(id=4)

run1 = Run(user=owner2, startTime = '2023-11-15 09:00:00', endTime = '2023-11-15 10:00:00', avgPace = 8)
run1.save()
run2 = Run(user=owner2, startTime = '2023-11-20 09:00:00', endTime = '2023-11-20 12:00:00', avgPace = 8)
run2.save()
run3 = Run(user=owner3, startTime = '2023-11-18 11:00:00', endTime = '2023-11-18 12:00:00', avgPace = 5)
run3.save()
run4 = Run(user=owner3, startTime = '2023-11-22 08:00:00', endTime = '2023-11-22 10:00:00', avgPace = 5)
run4.save()
concurrentRun2 = Run.objects.get(id=2)
run5 = Run(user=owner3, startTime = '2023-11-20 09:00:00', endTime = '2023-11-15 10:00:00', avgPace = 6, concurrentRun = concurrentRun2)
run5.save()
run6 = Run(user=owner3, startTime = '2023-11-21 09:00:00', endTime = '2023-11-21 12:00:00', avgPace = 2)
run6.save()
concurrentRun6 = Run.objects.get(id=6)
run7 = Run(user=owner4, startTime = '2023-11-21 09:00:00', endTime = '2023-11-21 12:00:00', avgPace = 2, concurrentRun = concurrentRun6)

run7.save()

#ForceFriending

friend_1 = User.objects.get(username= 'pat')
friend_2 = User.objects.get(username= 'ryan123')
f1 = Friendship(user1 = friend_1, user2 = friend_2)
f1.save()

friend_1 = User.objects.get(username= 'ryan123')
friend_2 = User.objects.get(username= 'emma_st')
f2 = Friendship(user1 = friend_1, user2 = friend_2)
f2.save()