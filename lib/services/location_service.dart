import 'package:geolocator/geolocator.dart';

enum PermissionStatus { disabled, denied, permDenied, allowed }

class LocationResult {
  PermissionStatus status;
  double? latitude;
  double? longitude;

  LocationResult({required this.status, this.latitude, this.longitude});
}

class LocationService {
  Future<LocationResult> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LocationResult(status: PermissionStatus.disabled);
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return LocationResult(status: PermissionStatus.denied);
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return LocationResult(status: PermissionStatus.permDenied);
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    return LocationResult(
        status: PermissionStatus.allowed,
        latitude: position.latitude,
        longitude: position.longitude);
  }
}
