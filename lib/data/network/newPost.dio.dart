import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

final dio = Dio(
  BaseOptions(
    connectTimeout: const Duration(seconds: 15), // Expanded for slow multi-file uploads
    receiveTimeout: const Duration(seconds: 15),
  ),
);

Future<Response?> newPost({
  required bool private,
  List<XFile>? imgPost,
  String? textContent,
}) async {
  if ((imgPost == null || imgPost.isEmpty) && (textContent == null || textContent.trim().isEmpty)) {
    throw Exception("Please provide either text or an image.");
  }

  try {
    print("Posting Data Initiated....");

    Map<String, dynamic> formDataMap = {
      "message": textContent ?? "",
      "private": private ? "private" : "public",
    };

    if (imgPost != null && imgPost.isNotEmpty) {
      final List<MultipartFile> images = [];

      if (kIsWeb) {
        for (var img in imgPost) {
          final bytes = await img.readAsBytes();
          images.add(
            MultipartFile.fromBytes(
              bytes,
              filename: img.name,
            ),
          );
        }
      } else {
        for (var img in imgPost) {
          images.add(
            await MultipartFile.fromFile(
              img.path,
              filename: img.name,
            ),
          );
        }
      }

      // ✅ Attached properly out of the conditional platform loops
      formDataMap['postImg'] = images;
    }

    // Convert map to standard Form Data container
    FormData formData = FormData.fromMap(formDataMap);

    final response = await dio.post(
      "https://groupin-backend.onrender.com/groupin/api/v1/users/post",
      data: formData, // ✅ Fixed: Sending the actual Form Data container now
    );

    print("Server Response Status: ${response.statusCode}");
    print("Server Response Body: ${response.data}");

    return response; // ✅ Fixed: Return response object directly

  } on DioException catch (e) {
    print("Dio Error: ${e.response?.data ?? e.message}");
    rethrow; // Sends the error straight back to your try/catch UI blocks smoothly
  } catch (error) {
    print("Generic Error: $error");
    rethrow;
  }
}