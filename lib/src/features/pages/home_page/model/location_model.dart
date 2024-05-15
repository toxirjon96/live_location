class LocationModel {
  final double latitude;
  final double longitude;

  const LocationModel({
    required this.latitude,
    required this.longitude,
  });

  Map<String, Object?> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

class DefaultLocation extends LocationModel {
  const DefaultLocation({
    super.latitude = 21.423423423423423,
    super.longitude = 12.23558444636441,
  });
}
