import 'package:geolocator/geolocator.dart';

class LocationHelper {
  static Future<Position> getMyCurrentLocation() async {
    bool isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isServiceEnabled) {
      await Geolocator.requestPermission();
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}
