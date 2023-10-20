import 'package:geolocator/geolocator.dart';
import 'dart:async';

class LocationDataMock {
  final StreamController<Position> _positionController =
      StreamController<Position>.broadcast();

  Stream<Position> get onLocationChanged => _positionController.stream;

  void emitLocation(Position position) {
    _positionController.add(position);
  }

  void dispose() {
    _positionController.close();
  }
}
