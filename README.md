<div style="text-align: center; margin-bottom: 10px;">
    <img src="abacusFrontend/assets/Rwf.png" alt="Image Description" width="200" >
</div>

# DECO7381

Run with Friends

## Backend

The application have a Django backend with an sqlite3 database. Django channels is used to handle websocket connections and function as a signalling server for WebRTC.

### Running backend

For local backend:
First install all the required packages by running  
`pip install -r requirements.txt`

Run dev server `python manage.py runserver`

The backend is now deployed to a web server so it is not nessacery to run the backend locally

## Frontend

### RoomScreen

The Room screen in the frontend functions as a mediator. Facilitating a connection between the two runners using WebRTC technology. When both runners are ready a video call will commence and a start run button will allow for the run to start.

Followed Guide: https://www.100ms.live/blog/flutter-webrtc

### Plugins

On the Run screen the get the users location we have used the Flutter GeoLocator plugin: https://pub.dev/packages/geolocator
For the map we have used the google_maps_flutter package: https://pub.dev/packages/google_maps_flutter

### Running frontend

Download flutter following the flutter installation guide [Installation Guide](https://docs.flutter.dev/get-started/install)

remember to set the path for flutter

The application can only be run on an actual physical device due to the augmented reality features:
Follow this guide for Android [Android Flutter Guide](https://appmaking.com/run-flutter-apps-on-android-device/)
Follow this guide for Ios [Ios FLutter Guide](https://medium.com/front-end-weekly/how-to-test-your-flutter-ios-app-on-your-ios-device-75924bfd75a8)

Go into the abacusFrontend folder and run `flutter run`
