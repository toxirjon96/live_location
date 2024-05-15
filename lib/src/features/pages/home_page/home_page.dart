import 'dart:async';

import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../../common/dependency/scope/dependency_scope.dart';
import 'model/location_model.dart';
import 'repository/location_repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final LocationRepository locationService;
  late final Completer<YandexMapController> yandexMapController;

  @override
  void initState() {
    locationService = DependencyScope.of(context).locationRepository;
    yandexMapController = DependencyScope.of(context).mapControllerCompleter;
    _initPermission();
    super.initState();
  }

  Future<void> _initPermission() async {
    if (!await locationService.checkPermission()) {
      await locationService.requestPermission();
    }
    await _fetchCurrentLocation();
  }

  Future<void> _fetchCurrentLocation() async {
    LocationModel location = await locationService.getCurrentLocation();
    _moveToCurrentLocation(location);
  }

  Future<void> _moveToCurrentLocation(
    LocationModel model,
  ) async {
    (await yandexMapController.future).moveCamera(
      animation: const MapAnimation(type: MapAnimationType.linear, duration: 1),
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: Point(
            latitude: model.latitude,
            longitude: model.longitude,
          ),
          zoom: 12,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: YandexMap(
          onMapCreated: (controller) {
            DependencyScope.of(context)
                .mapControllerCompleter
                .complete(controller);
          },
        ),
      ),
    );
  }
}
