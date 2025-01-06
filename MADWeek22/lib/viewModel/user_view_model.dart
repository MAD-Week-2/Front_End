import 'package:flutter/material.dart';
import '../model/user_model.dart';

class UserViewModel extends ChangeNotifier {
  UserModel _user = UserModel(username: '태건'); // 초기값 설정

  UserModel get user => _user;

  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }
}
