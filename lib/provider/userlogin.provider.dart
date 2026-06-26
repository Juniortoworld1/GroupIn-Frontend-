import 'package:flutter/material.dart';

import '../data/model/userModel.dart';

class UserLoginProvider with ChangeNotifier {
  UserModel? _user;
  bool _isLoggedIn = false;

  UserModel? get user => _user;
  bool get isLoggedIn => _isLoggedIn;

  void putData(UserModel user) {
    _user = user;
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _user = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}