class RefreshTokenRequest {
  final String refresh;

  const RefreshTokenRequest({required this.refresh});

  Map<String, Object?> toJson() {
    return {'refresh': refresh};
  }
}
