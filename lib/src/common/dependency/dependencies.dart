import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../features/pages/home_page/repository/location_repository.dart';
import '../repository/request_repository.dart';

base class Dependencies {
  Dependencies();

  late final SharedPreferences sharedPreferences;
  late final RequestRepository requestRepository;
  late final Completer<YandexMapController> mapControllerCompleter;
  late final LocationRepository locationRepository;
}

final class MutableDependencies implements Dependencies {
  MutableDependencies({
    required this.sharedPreferences,
    required this.requestRepository,
    required this.mapControllerCompleter,
    required this.locationRepository,
  });

  @override
  SharedPreferences sharedPreferences;

  @override
  RequestRepository requestRepository;

  @override
  Completer<YandexMapController> mapControllerCompleter;

  @override
  LocationRepository locationRepository;
}
