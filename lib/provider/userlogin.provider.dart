import 'package:flutter/material.dart';

import '../data/model/userModel.dart';

// Create a small model for your User data to type-safely access items


class UserLoginProvider with ChangeNotifier {
  UserModel? _user;
  bool _isLoggedIn = false;

  UserModel? get user => _user;
  bool get isLoggedIn => _isLoggedIn;

  void putData(Map<String, dynamic> data) {
    _user = UserModel(
      username: data['username'] ?? '',
      fullName: data['fullName'] ?? '',
      email: data['email'] ?? '',
      avatarUrl: data['avatar'],
      coverImage: data['coverImage'],
    );
    _isLoggedIn = true;
    notifyListeners(); // Essential to rebuild elements reacting to auth shifts
  }

  void logout() {
    _user = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}