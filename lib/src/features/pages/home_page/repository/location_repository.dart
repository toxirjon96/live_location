import '../model/location_model.dart';

abstract interface class LocationRepository {
  Future<LocationModel> getCurrentLocation();

  Future<bool> requestPermission();

  Future<bool> checkPermission();
}
