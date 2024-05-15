import 'package:geolocator/geolocator.dart';

import '../model/location_model.dart';
import '../repository/location_repository.dart';

class LocationServiceImpl implements LocationRepository {
  final defaultLocation = const DefaultLocation();

  @override
  Future<bool> checkPermission() {
    return Geolocator.checkPermission()
        .then((value) =>
            value == LocationPermission.always ||
            value == LocationPermission.whileInUse)
        .catchError((_) => false);
  }

  @override
  Future<LocationModel> getCurrentLocation() async {
    return Geolocator.getCurrentPosition().then((value) {
      return LocationModel(
          latitude: value.latitude, longitude: value.longitude);
    }).catchError(
      (_) => defaultLocation,
    );
  }

  @override
  Future<bool> requestPermission() {
    return Geolocator.requestPermission()
        .then((value) =>
            value == LocationPermission.always ||
            value == LocationPermission.whileInUse)
        .catchError((_) => false);
  }
}
