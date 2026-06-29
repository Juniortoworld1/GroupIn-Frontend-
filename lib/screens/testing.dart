import 'package:flutter/material.dart';
import 'package:groupin/provider/Global.provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../utils/SelectingMultipleImage.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final ImagePicker _picker = ImagePicker();
  List<XFile> _selectedImages = []; // Hold multiple files here
  TextEditingController _postController = TextEditingController() ;
  // Method to trigger pickMultiImage engine
  Future<void> _pickMultipleImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        imageQuality: 85, // Compresses file sizes for fast database/Cloudinary uploads
      );

      if (images.isNotEmpty) {
        setState(() {
          // Appends newly picked items to your existing collection array
          _selectedImages.addAll(images);
        });
      }
    } catch (e) {
      debugPrint("Error selecting media: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final _isDark = context.watch<GlobalValueProvider>().getisDarkMode() ;
    final screenWidth = MediaQuery.sizeOf(context).width ;
    return Scaffold(
      appBar: AppBar(title: Text("Create Post" , style: TextStyle(color: _isDark?Colors.white10: Colors.black12),)),
      // FIX: Wrap the body in a SingleChildScrollView
      backgroundColor: _isDark?Colors.black:Colors.white,
      body: Center(
        child: Container(
          width: screenWidth>700?screenWidth*0.6:screenWidth,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(), // Provides smooth native scrolling
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  MultiImagePickerGrid(
                    selectedFiles: _selectedImages,
                    onPickImages: _pickMultipleImages,
                    onRemoveImage: (index) {
                      setState(() {
                        _selectedImages.removeAt(index);
                      });
                    },
                  ),


                  const SizedBox(height: 24),


                  AnimatedContainer(
                    duration: Duration(seconds: 1),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12) ,
                      border: Border.all(
                        color: Colors.grey.shade300, // Quick shorthand for all sides
                        width: 1.5,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _postController,
                              decoration: InputDecoration(
                                hintText: "What's on your mind?",
                                hintStyle: TextStyle(color: _isDark?Colors.white:Colors.black),
                                border: InputBorder.none,
                              ),
                              maxLines: 4,
                            ),
                          ),

                        ],
                      ),
                    ),

                  ),

                  SizedBox(height: 8,) ,

                  InkWell(
                    child: Container(
                      width: double.infinity,

                      height: 35,
                      decoration: BoxDecoration(
                        color: Colors.green ,
                        borderRadius: BorderRadius.circular(12) ,
                      ),
                      child: Center(child: Text("Post" , style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold ),)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}