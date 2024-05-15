import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import '../../features/pages/home_page/service/location_service.dart';
import 'app.dart';
import '../constant/api_config.dart';
import '../dependency/dependencies.dart';
import '../service/request_service.dart';

final class AppRunner {
  Future<void> initializeAndRun() async {
    WidgetsFlutterBinding.ensureInitialized();

    final sharedPreferences = await SharedPreferences.getInstance();
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.liveLocationBaseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    final requestRepository = RequestServiceImpl(dio);
    final mapControllerCompleter = Completer<YandexMapController>();
    final locationRepository = LocationServiceImpl();
    final Dependencies dependencies = MutableDependencies(
      sharedPreferences: sharedPreferences,
      requestRepository: requestRepository,
      mapControllerCompleter: mapControllerCompleter,
      locationRepository: locationRepository,
    );

    App(
      dependencies: dependencies,
    ).run();
  }
}
