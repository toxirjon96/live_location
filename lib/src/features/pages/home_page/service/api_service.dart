import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../common/constant/api_url.dart';
import '../../../../common/exception/json_decode_exception.dart';
import '../../../../common/repository/request_repository.dart';
import '../../../../common/util/logger.dart';
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
      data: request.toJson(),
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $bearerToken',
        },
      ),
    );
    try {
      Map<String, Object?> jsonResponse = jsonDecode(response);
      return DistanceResponse.fromJson(jsonResponse);
    } catch (e) {
      warning(e);
      throw JsonDecodeException(e.toString());
    }
  }

  @override
  Future<TokenResponse> getToken(UserRequest request) async {
    String response = await requestRepository.post(
      ApiUrl.token,
      data: request.toJson(),
    );
    try {
      Map<String, Object?> jsonResponse = jsonDecode(response);
      return TokenResponse.fromJson(jsonResponse);
    } catch (e) {
      warning(e);
      throw JsonDecodeException(e.toString());
    }
  }

  @override
  Future<RefreshTokenResponse> getTokenFromRefreshToken(
    RefreshTokenRequest request,
  ) async {
    String response = await requestRepository.post(
      ApiUrl.refreshToken,
      data: request.toJson(),
    );
    try {
      Map<String, Object?> jsonResponse = jsonDecode(response);
      return RefreshTokenResponse.fromJson(jsonResponse);
    } catch (e) {
      warning(e);
      throw JsonDecodeException(e.toString());
    }
  }
}
