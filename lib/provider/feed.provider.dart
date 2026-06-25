import 'package:flutter/material.dart';
import '../data/model/post_model.dart';
import '../data/model/userModel.dart'; // Your existing user model
 // The model we created above

class FeedProvider extends ChangeNotifier {
  UserModel? _user;
  List<PostModel> _feedList = [];
  bool _isLoading = false;

  // Getters
  UserModel? get user => _user;
  bool get isLoggedIn => _user != null;
  List<PostModel> get feedList => _feedList;
  bool get isLoading => _isLoading;

  /// Call this when the user logs in
  void loginUser(Map<String, dynamic> userData) {
    _user = UserModel.fromMap(userData);
    notifyListeners();
  }

  /// Sets feed items from the API response if the user is authenticated
  void setFeedData(Map<String, dynamic> jsonResponse) {
    if (!isLoggedIn) {
      print("User not logged in. Cannot fetch feed.");
      return;
    }

    if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
      final List<dynamic> feedData = jsonResponse['data'];

      // Map the dynamic list into a typed List<PostModel>
      _feedList = feedData.map((postJson) => PostModel.fromMap(postJson)).toList();
      notifyListeners();
    }
  }

  /// Clear everything on logout
  void logout() {
    _user = null;
    _feedList = [];
    notifyListeners();
  }
}