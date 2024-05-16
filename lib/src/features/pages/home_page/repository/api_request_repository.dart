import '../model/distance_response.dart';
import '../model/location_model.dart';
import '../model/refresh_token_request.dart';
import '../model/refresh_token_response.dart';
import '../model/token_response.dart';
import '../model/user_request.dart';

abstract interface class ApiRequestRepository {
  Future<TokenResponse> getToken(UserRequest request);

  Future<RefreshTokenResponse> getTokenFromRefreshToken(RefreshTokenRequest request);

  Future<DistanceResponse> getDistance(LocationModel request, String bearerToken);
}
