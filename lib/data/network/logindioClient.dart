import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart'; // Required for kIsWeb

import 'package:image_picker/image_picker.dart';

final dio = Dio(
  BaseOptions(
    connectTimeout: const Duration(seconds: 5), // Time to establish a connection
    receiveTimeout: const Duration(seconds: 3), // Time to receive data from the server
  ),
);
// Login remains unchanged
Future<Response?> login(String username, String password) async {
  try {
    final response = await dio.post(
      "http://localhost:3000/groupin/api/v1/users/login",
      data: {
        "username": username,
        "password": password,
      },
    );
    print("Login Success: ${response.data}");
    return response;
  } catch (e) {
    print("Error during login: $e");
    return null;
  }
}