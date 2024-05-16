import '../model/distance_response.dart';
import '../model/location_model.dart';
import '../model/token_response.dart';
import '../model/user_request.dart';
import '../repository/api_request_repository.dart';

class LocationController {
  final ApiRequestRepository apiRequestRepository;

  const LocationController({required this.apiRequestRepository});

  Future<DistanceResponse> getDistance(LocationModel request) async {
    TokenResponse token = await apiRequestRepository.getToken(
      const UserRequest(
        username: 'tester',
        password: 'tester1',
      ),
    );
    DistanceResponse distanceResponse = await apiRequestRepository.getDistance(
      request,
      token.access,
    );
    return distanceResponse;
  }
}
