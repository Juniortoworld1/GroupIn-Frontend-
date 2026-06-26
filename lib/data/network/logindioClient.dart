import 'package:dio/dio.dart';

final Dio dio = Dio(
  BaseOptions(
    // 10-15 seconds is recommended for mobile networks to avoid premature timeouts
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 10),
  ),
);

/// Sends a login request to the backend server.
/// Returns a [Response] object on success, or [null] if an error occurs.
Future<Response<dynamic>?> login(String username, String password) async {
  try {
    // ⚠️ CRITICAL NOTE: "localhost" only works for Web or iOS Simulators.
    // Read the environment guide below if using an Android Emulator or physical device.
    final response = await dio.post(
      "http://localhost:3000/groupin/api/v1/users/login",
      data: {
        "username": username,
        "password": password,
      },
    );

    print("Login Success: ${response.data}");

    // Safely printing the token to ensure no null-pointer crashes
    if (response.data != null && response.data['data'] != null) {
      print("${response.data['data']['accessToken']} access token");
    }

    return response;
  } on DioException catch (e) {
    print("Dio error during login: ${e.message}");
    print("Dio response data: ${e.response?.data}");
    return e.response; // Returning the response so your UI can parse the 400/401 error message status
  } catch (e) {
    print("Unexpected error during login: $e");
    return null;
  }
}