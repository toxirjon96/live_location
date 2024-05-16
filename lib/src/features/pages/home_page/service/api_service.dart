import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../common/constant/api_url.dart';
import '../../../../common/repository/request_repository.dart';
import '../model/distance_response.dart';
import '../model/location_model.dart';
import '../model/refresh_token_request.dart';
import '../model/refresh_token_response.dart';
import '../model/token_response.dart';
import '../model/user_request.dart';
import '../repository/api_request_repository.dart';

class ApiServiceImpl implements ApiRequestRepository {
  final RequestRepository requestRepository;

  const ApiServiceImpl({required this.requestRepository});

  @override
  Future<DistanceResponse> getDistance(
      LocationModel request, String bearerToken) async {
    String response = await requestRepository.post(
      ApiUrl.getDistance,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $bearerToken',
        },
      ),
    );
    Map<String, Object?> jsonResponse = jsonDecode(response);
    return DistanceResponse.fromJson(jsonResponse);
  }

  @override
  Future<TokenResponse> getToken(UserRequest request) {
    // TODO: implement getToken
    throw UnimplementedError();
  }

  @override
  Future<RefreshTokenResponse> getTokenFromRefreshToken(RefreshTokenRequest request) {
    // TODO: implement getTokenFromRefreshToken
    throw UnimplementedError();
  }

}
