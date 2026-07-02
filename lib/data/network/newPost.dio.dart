import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';


final dio = Dio(
  BaseOptions(
    connectTimeout:  const Duration(seconds: 5) ,
    receiveTimeout: const Duration(seconds: 4)
  )
) ;

Future<Response?> newPost({
  required String  private  ,
  List<XFile>? imgPost, // Made nullable using '?'
  String? textContent, // Made nullable using '?'
}) async {
  if (imgPost == null && (textContent == null || textContent.trim().isEmpty)) {
    throw Exception("Please provide either text or an image.");
  }
  try {
    Map<String, dynamic> formDataMap = {
      "message": textContent,
      "private":private
    };
    if (imgPost != null) {
      final List<MultipartFile> images = [];

      if (kIsWeb) {
        // Web path: Read files as bytes
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

        formDataMap['postImg'] = images;
      };
    }else{
      formDataMap['postImg'] = "" ;
    }
    FormData formData = FormData.fromMap(formDataMap) ;
    final response = await dio.post(
      "https://groupin-backend.onrender.com/groupin/api/v1/user/post" ,
      data: formDataMap  ,
    );
    return (response.data);
  }catch(error){
    throw Exception("Post Failed $error") ;

  }
}