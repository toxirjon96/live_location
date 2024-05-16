import 'package:bloc/bloc.dart';

import '../../../../common/exception/json_decode_exception.dart';
import '../../../../common/exception/request_exception.dart';
import '../../../../common/exception/status_code_exception.dart';
import '../../../../common/exception/unknown_exception.dart';
import '../../../../common/util/logger.dart';
import '../controller/location_controller.dart';
import '../model/distance_response.dart';
import '../model/location_model.dart';

part 'location_event.dart';

part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc({required LocationController controller})
      : _controller = controller,
        super(const InitialLocation$State()) {
    on<LocationEvent>(
      (event, emit) => switch (event) {
        CalculateLocation$Event e => _calculateDistance(e, emit),
      },
    );
  }

  final LocationController _controller;

  void _calculateDistance(
    CalculateLocation$Event event,
    Emitter<LocationState> emit,
  ) async {
    try {
      emit(const LocationDistanceLoading$State());
      DistanceResponse response = await _controller.getDistance(event.location);
      emit(
        LocationDistanceSuccessful$State(
          distanceResponse: response,
        ),
      );
    } on StatusCodeException catch (e) {
      info(e.toString());
      emit(
        const LocationDistanceError$State(
            message:
                'API bilan bog\'liq muammo mavjud! Administrator bilan bog\'laning!'),
      );
    } on UnknownException catch (e) {
      info(e.toString());
      emit(
        const LocationDistanceError$State(
            message: 'Noma\'lum xatolik! Administrator bilan bog\'laning!'),
      );
    } on RequestException catch (e) {
      info(e.toString());
      emit(
        const LocationDistanceError$State(
            message:
                'So\'rov jo\'natishda xatolik! Administrator bilan bog\'laning!'),
      );
    } on JsonDecodeException catch (e) {
      info(e.toString());
      emit(
        const LocationDistanceError$State(
            message:
                'Response formatida xatolik! Administrator bilan bog\'laning!'),
      );
    } catch (e) {
      info(e.toString());
      emit(
        const LocationDistanceError$State(
            message: 'Noma\'lum xatolik! Administrator bilan bog\'laning!'),
      );
    }
  }
}
