class RefreshTokenResponse {
  final String access;

  const RefreshTokenResponse({required this.access});

  factory RefreshTokenResponse.fromJson(Map<String, Object?> json) {
    return RefreshTokenResponse(access: json['access'] as String);
  }
}
