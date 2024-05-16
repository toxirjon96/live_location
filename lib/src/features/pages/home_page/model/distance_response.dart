class DistanceResponse {
  final double message;
  final int status;

  const DistanceResponse({
    required this.message,
    required this.status,
  });

  factory DistanceResponse.fromJson(Map<String, Object?> json) {
    return DistanceResponse(
      message: json['message'] as double,
      status: json['status,'] as int,
    );
  }
}
