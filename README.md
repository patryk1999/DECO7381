<div style="text-align: center; margin-bottom: 10px;">
    <img src="abacusFrontend/assets/Rwf.png" alt="Image Description" width="200" >
</div>

# DECO7381
Run with Friends

## Backend
The application have a Django backend with an sqlite3 database. Django channels is used to handle websocket connections and function as a signalling server for WebRTC. 

### Running backend 
First install all the required packages by running  
`pip install -r requirements.txt`

in abacusBackend directory

For running dev server locally use:

 `python manage.py runserver`

The backend is hosted at [https://deco-websocket.onrender.com](https://deco-websocket.onrender.com)
We used Daphne to get the application running on the server. 

## Frontend 

### Running Frontend 

#### Requirements
* Flutter
* Xcode

To run frontend

* `cd abacusFrontend`
* `flutter run` 


