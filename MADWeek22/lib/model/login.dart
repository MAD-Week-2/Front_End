class LoginModel {
  final String email;
  final String password;
  final bool locationConsent;

  LoginModel({
    required this.email,
    required this.password,
    required this.locationConsent,
  });

  // JSON 변환 (서버 요청 시 사용)
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'location_consent': locationConsent,
    };
  }
}
