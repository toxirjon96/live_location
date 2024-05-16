import 'dart:async';

import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../../common/constant/app_color.dart';
import '../../../common/dependency/scope/dependency_scope.dart';
import 'controller/location_controller.dart';
import 'model/distance_response.dart';
import 'model/location_model.dart';
import 'repository/location_repository.dart';
import 'service/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final LocationRepository locationService;
  late final Completer<YandexMapController> yandexMapController;
  late final LocationController locationController;
  ValueNotifier<LocationModel?> locationModelNotifier = ValueNotifier(null);

  @override
  void initState() {
    locationService = DependencyScope.of(context).locationRepository;
    yandexMapController = DependencyScope.of(context).mapControllerCompleter;
    locationController = LocationController(
      apiRequestRepository: ApiServiceImpl(
          requestRepository: DependencyScope.of(context).requestRepository),
    );
    _moveToCurrentLocation();
    super.initState();
  }
  void calculateDistance(){
    _getDistance();
  }
  void _getDistance() async {
    if (locationModelNotifier.value != null) {
      DistanceResponse distanceResponse = await locationController.getDistance(
        locationModelNotifier.value!,
      );
      print(distanceResponse);
    }
  }

  Future<void> _moveToCurrentLocation() async {
    if (!await locationService.checkPermission()) {
      await locationService.requestPermission();
    }
    locationModelNotifier.value = await locationService.getCurrentLocation();
    if (locationModelNotifier.value != null) {
      (await yandexMapController.future).moveCamera(
        animation:
            const MapAnimation(type: MapAnimationType.linear, duration: 1),
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: Point(
              latitude: locationModelNotifier.value!.latitude,
              longitude: locationModelNotifier.value!.longitude,
            ),
            zoom: 16,
          ),
        ),
      );
    }
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
            child: ValueListenableBuilder(
              builder: (context, value, child) {
                if (value == null) {
                  return YandexMap(
                    onMapCreated: (controller) {
                      DependencyScope.of(context)
                          .mapControllerCompleter
                          .complete(controller);
                    },
                  );
                } else {
                  return YandexMap(
                    onMapCreated: (controller) {
                      DependencyScope.of(context)
                          .mapControllerCompleter
                          .complete(controller);
                    },
                    mapObjects: [
                      PlacemarkMapObject(
                        mapId: MapObjectId('MapObject $value'),
                        point: Point(
                            latitude: value.latitude,
                            longitude: value.longitude),
                        opacity: 1,
                        icon: PlacemarkIcon.single(
                          PlacemarkIconStyle(
                            image: BitmapDescriptor.fromAssetImage(
                              'assets/images/location.png',
                            ),
                            scale: 0.3,
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
              valueListenable: locationModelNotifier,
            ),
          ),
          Positioned(
            bottom: 180,
            left: 50,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColor.whiteColor,
                backgroundColor: AppColor.mainColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
              onPressed: calculateDistance,
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
