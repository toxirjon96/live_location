import 'dart:async';

import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../../common/constant/app_color.dart';
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
    _moveToCurrentLocation();
    super.initState();
  }

  Future<void> _moveToCurrentLocation() async {
    if (!await locationService.checkPermission()) {
      await locationService.requestPermission();
    }
    LocationModel model = await locationService.getCurrentLocation();
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
      body: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            right: 0,
            bottom: 0,
            child: YandexMap(
              onMapCreated: (controller) {
                DependencyScope.of(context)
                    .mapControllerCompleter
                    .complete(controller);
              },
            ),
          ),
          const Positioned(
            left: 0,
            top: 0,
            right: 0,
            bottom: 0,
            child: Icon(
              Icons.location_on,
              color: Colors.red,
              size: 40,
            ),
          ),
          Positioned(
            bottom: 180,
            left: 50,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 4,
                ),
              ),
              onPressed: () {},
              label: const Text('Masofa'),
              icon: const Icon(Icons.polyline_sharp),
            ),
          ),
          Positioned(
            right: 10,
            bottom: 180,
            child: IconButton(
              icon: const Icon(
                Icons.navigation,
                size: 50,
              ),
              onPressed: () {
                _moveToCurrentLocation();
              },
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              decoration: const BoxDecoration(
                color: AppColor.mainColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              height: 150,
              child: Column(
                children: [
                  TextField(
                    style: const TextStyle(
                      color: AppColor.whiteColor,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Search anything',
                      labelStyle: const TextStyle(
                        color: AppColor.whiteColor,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          color: AppColor.whiteColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
