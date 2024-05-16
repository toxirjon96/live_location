class TokenResponse {
  final String refresh;
  final String access;

  const TokenResponse({
    required this.refresh,
    required this.access,
  });

  factory TokenResponse.fromJson(Map<String, Object?> json) {
    return TokenResponse(
      refresh: json['refresh'] as String,
      access: json['access'] as String,
    );
  }
  @override
  String toString() {
    return 'TokenResponse{refresh: $refresh, access: $access}';
  }
}
