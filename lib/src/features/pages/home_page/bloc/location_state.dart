part of 'location_bloc.dart';

/// states
sealed class LocationState {
  const LocationState._();
}

final class InitialLocation$State extends LocationState {
  const InitialLocation$State() : super._();
}

final class LocationDistanceLoading$State extends LocationState {
  const LocationDistanceLoading$State() : super._();
}

final class LocationDistanceSuccessful$State extends LocationState {
  const LocationDistanceSuccessful$State({
    required this.distanceResponse,
  }) : super._();

  final DistanceResponse distanceResponse;
}

final class LocationDistanceError$State extends LocationState {
  const LocationDistanceError$State({
    required this.message,
  }) : super._();

  final String message;
}
