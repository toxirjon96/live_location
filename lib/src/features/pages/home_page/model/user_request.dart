class UserRequest {
  final String username;
  final String password;

  const UserRequest({
    required this.username,
    required this.password,
  });

  Map<String, Object?> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }
}
