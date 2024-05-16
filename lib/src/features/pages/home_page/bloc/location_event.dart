part of 'location_bloc.dart';

/// events
sealed class LocationEvent {
  const LocationEvent._();
}

final class CalculateLocation$Event extends LocationEvent {
  const CalculateLocation$Event({required this.location}) : super._();
  final LocationModel location;
}
