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
  Future<bool> login() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final success = await _authService.login(_email, _password);
      if (success) {
        _isLoading = false;
        notifyListeners();
        return true; // 로그인 성공
      } else {
        _errorMessage = 'Invalid email or password.';
      }
    } catch (e) {
      _errorMessage = 'An error occurred: $e';
    }

    _isLoading = false;
    notifyListeners();
    return false; // 로그인 실패
  }

}