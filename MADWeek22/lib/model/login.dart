class UserModel {
  final String email;
  final String password;
  final bool locationConsent;

  UserModel({
    required this.email,
    required this.password,
    required this.locationConsent,
  });
}
