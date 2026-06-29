import 'package:dio/dio.dart';

final Dio dio = Dio(
  BaseOptions(
    // 10-15 seconds is recommended for mobile networks to avoid premature timeouts
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 10),
  ),
);

Future<Map<String, dynamic>?> login(String username, String password) async {
  try {
    final response = await dio.post(
      "https://groupin-backend.onrender.com/groupin/api/v1/users/login",
      data: {
        "username": username,
        "password": password,
      },
    );

    final data = response.data?['data'];
    if (data == null || data['user'] == null) {
      print("Login response missing expected data: ${response.data}");
      return null;
    }

    print("Login Success: ${response.data}");
    print("${data['accessToken']} access token");

    return data['user'] as Map<String, dynamic>;
  } on DioException catch (e) {
    print("Dio error during login: ${e.message}");
    print("Dio response data: ${e.response?.data}");
    return null;
  } catch (e) {
    print("Unexpected error during login: $e");
    return null;
  }
}