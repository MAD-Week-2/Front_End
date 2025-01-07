import 'package:flutter/material.dart';
import '../model/login.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignupViewModel extends ChangeNotifier {
  String _email = '';
  String _password = '';
  bool _locationConsent = false;

  String _errorMessage = '';
  bool _isLoading = false;

  String get email => _email;
  String get password => _password;
  bool get locationConsent => _locationConsent;
  String get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  final String _baseUrl = dotenv.env['BASEURL'] ?? '';

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void setPassword(String password) {
    _password = password;
    notifyListeners();
  }

  void toggleLocationConsent(bool? value) {
    _locationConsent = value ?? false; // null일 경우 기본값 false로 처리
    notifyListeners();
  }

  Future<bool> signup() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    // 입력값 검증
    if (_email.isEmpty || _password.isEmpty) {
      _errorMessage = 'Email and Password cannot be empty.';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    if (!_locationConsent) {
      _errorMessage = 'You must agree to the location terms.';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    final url = Uri.parse('$_baseUrl/signup');
    print(url);

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': _email,
          'password': _password,
        }),
      );

      if (response.statusCode == 200) {
        _isLoading = false;
        notifyListeners();
        return true; // 회원가입 성공
      } else {
        final data = jsonDecode(response.body);
        _errorMessage = data['message'] ?? 'Signup failed. Please try again.';
      }
    } catch (e) {
      _errorMessage = 'An error occurred. Please try again later.';
      print('Error: $e');
    }

    _isLoading = false;
    notifyListeners();
    return false; // 회원가입 실패
  }
}
