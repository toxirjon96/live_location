import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import '../../../common/constant/app_color.dart';
import '../../../common/dependency/scope/dependency_scope.dart';
import 'bloc/location_bloc.dart';
import 'controller/location_controller.dart';
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
  late final LocationBloc locationBloc;
  ValueNotifier<LocationModel?> locationModelNotifier = ValueNotifier(null);

  @override
  void initState() {
    locationService = DependencyScope.of(context).locationRepository;
    yandexMapController = DependencyScope.of(context).mapControllerCompleter;
    locationController = LocationController(
      apiRequestRepository: ApiServiceImpl(
          requestRepository: DependencyScope.of(context).requestRepository),
    );
    locationBloc = LocationBloc(controller: locationController);
    _moveToCurrentLocation();
    super.initState();
  }

  void calculateDistance() {
    if (locationModelNotifier.value != null) {
      locationBloc.add(
        CalculateLocation$Event(
          location: locationModelNotifier.value!,
        ),
      );
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
    return BlocProvider.value(
      value: locationBloc,
      child: Scaffold(
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
            Align(
              child: BlocConsumer(
                bloc: locationBloc,
                builder: (context, state) {
                  if (state is LocationDistanceLoading$State) {
                    return const SizedBox(
                      width: 100,
                      height: 100,
                      child: CircularProgressIndicator(
                        color: AppColor.mainColor,
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
                listener: (context, state) {
                  if (state is LocationDistanceError$State) {
                    showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Xatolik'),
                          content: Text(
                            state.message,
                          ),
                          actions: <Widget>[
                            TextButton(
                              style: TextButton.styleFrom(
                                textStyle:
                                Theme.of(context).textTheme.labelLarge,
                              ),
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                  if (state is LocationDistanceSuccessful$State) {
                    showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Masofa'),
                          content: Text(
                            'Siz turgan joydan biz bergan lokatsiyagacha bo\'lgan masofa ${state.distanceResponse.message}',
                          ),
                          actions: <Widget>[
                            TextButton(
                              style: TextButton.styleFrom(
                                textStyle:
                                Theme.of(context).textTheme.labelLarge,
                              ),
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
      ),
    );
  }
}
