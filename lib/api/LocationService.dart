import 'package:geolocator/geolocator.dart';

getLocation() {
  return Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
}
