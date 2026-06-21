import 'package:flutter/material.dart';

import '../data/model/userModel.dart';
class UserLoginProvider extends ChangeNotifier {
  UserModel? _user;

  // Expose the user object. If null, user is logged out.
  UserModel? get user => _user;
  bool get isLoggedIn => _user != null;

  /// Updates the user data state safely
  void putData(Map<String, dynamic> newData) {
    _user = UserModel.fromMap(newData);
    notifyListeners();
  }

  /// Clear user data on logout
  void logout() {
    _user = null;
    notifyListeners();
  }
}