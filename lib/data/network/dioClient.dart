import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart'; // Required for kIsWeb
import 'package:groupin/core/config/enviroment.dart';
import 'package:image_picker/image_picker.dart';

final dio = Dio();

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

// Fixed Signup to match your working multipart request structure
Future<Response?> signup({
  required String username,
  required String fullName,
  required String password,
  required String email,
  required XFile avatar,
  String coverImage = "",
}) async {
  try {
    print("🚀 Preparing Dio Multipart Request...");

    // 1. Create the base map for your fields
    Map<String, dynamic> formDataMap = {
      "username": username,
      "fullName": fullName,
      "password": password,
      "email": email,
      "coverImage": coverImage, // Defaults to ""
    };

    // 2. Add the Avatar Image handling matching your http template
    if (kIsWeb) {
      // Web handling: read file as bytes
      final bytes = await avatar.readAsBytes();
      formDataMap["avatar"] = MultipartFile.fromBytes(
        bytes,
        filename: avatar.name,
      );
    } else {
      // Mobile/Desktop handling: read file from local path
      formDataMap["avatar"] = await MultipartFile.fromFile(
        avatar.path,
        filename: avatar.name,
      );
    }

    // 3. Convert the map into Dio's FormData object
    FormData formData = FormData.fromMap(formDataMap);

    print("📬 Sending registration data to ${Enviroment.baseUrl}/register...");

    // 4. Fire the request
    final response = await dio.post(
      "http://localhost:3000/groupin/api/v1/users/register",
      data: formData, // Crucial: Send FormData, not a raw Map
    );

    print("Signup Success: ${response.data}");
    return response;

  } catch (e) {
    print("❌ Error during signup: $e");
    return null;
  }
}