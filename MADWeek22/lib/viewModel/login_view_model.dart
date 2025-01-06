import 'package:flutter/material.dart';
import '../service/auth_service.dart';
import '../service/auth_service.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  String _email = '';
  String _password = '';
  bool _isLoading = false;
  String _errorMessage = '';

  String get email => _email;
  String get password => _password;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  void setEmail(String email) {
    _email = email;
    notifyListeners(); // View에 상태 변경 알림
  }

  void setPassword(String password) {
    _password = password;
    notifyListeners();
  }

  /// 로그인 로직
  Future<void> login() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    final success = await _authService.login(_email, _password);
    _isLoading = false;

    if (!success) {
      _errorMessage = 'Invalid email or password.';
    }
    notifyListeners();
  }
}
