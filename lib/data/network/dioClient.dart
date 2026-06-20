import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:groupin/core/config/enviroment.dart';
import 'package:image_picker/image_picker.dart';

final dio = Dio();

// Changed return type from Future<void> to Future<Response?> to allow returning the response
Future<Response?> login(String username, String password) async {
  try {
    final response = await dio.post(
      "${Enviroment.baseUrl}/login",
      // Fixed: Pass data as a proper Key-Value Map
      data: {
        "username": username,
        "password": password,
      },
    );

    print("Login Success: ${response.data}");
    return response;

  } catch (e) {
    print("Error during login: $e");
    return null; // Return null if the request fails
  }
}


Future<Response?> signup({
  required String username,
  required String fullName,
  required String password,
  required String email,
  required XFile avatar,
  String coverImage = "", // Defaulted to empty string if not provided
}) async {
  try {
    final response = await dio.post(
      "${Enviroment.baseUrl}/register", // Updated endpoint
      data: {
        "username": username,
        "fullName": fullName,
        "password": password,
        "email": email,
        "avatar": avatar,
        "coverImage": coverImage, // Will be "" if not explicitly given
      },
    );

    print("Signup Success: ${response.data}");
    return response;

  } catch (e) {
    print("Error during signup: $e");
    return null;
  }
}