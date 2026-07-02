import 'package:flutter/material.dart';
import 'package:groupin/data/network/newPost.dio.dart';
import 'package:groupin/provider/Global.provider.dart';
import 'package:groupin/provider/userlogin.provider.dart';
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
  List<XFile> _selectedImages = [];
  bool isLoading = false ;
  final TextEditingController _postController = TextEditingController();
  bool isPrivate = false;

  Future<void> _pickMultipleImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        imageQuality: 85,
      );

      if (images.isNotEmpty) {
        setState(() {
          _selectedImages.addAll(images);
        });
      }
    } catch (e) {
      debugPrint("Error selecting media: $e");
    }
  }

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _isDark = context.watch<GlobalValueProvider>().getisDarkMode();
    final screenWidth = MediaQuery.sizeOf(context).width;
    final user = context.watch<UserLoginProvider>().user;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.of(context).pushReplacementNamed('/user/${user?.username}');
      },
      child: Scaffold(
        backgroundColor: _isDark ? Colors.black : Colors.white,
        body: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: screenWidth > 800 ? screenWidth * 0.6 : screenWidth,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 18, left: 8),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios_new_rounded,
                            color: _isDark ? Colors.white : Colors.black, size: 20),
                        onPressed: () => Navigator.maybePop(context),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            "New Post",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: _isDark ? Colors.white : Colors.black
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
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
                            duration: const Duration(seconds: 1),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.grey.shade300,
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
                                      style: TextStyle(color: _isDark ? Colors.white : Colors.black),
                                      decoration: InputDecoration(
                                        hintText: "What's on your mind?",
                                        hintStyle: TextStyle(color: Colors.grey.shade500),
                                        border: InputBorder.none,
                                      ),
                                      maxLines: 4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Privacy Toggle Toggles Fix
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Public Button
                                Expanded(
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(30),
                                    onTap: () {
                                      setState(() => isPrivate = false  );
                                    },
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 300),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: isPrivate ? Colors.grey.shade400 : Colors.green,
                                      ),
                                      child: const Center(child: Text("Public", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 10),

                                // Private Button
                                Expanded(
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(30),
                                    onTap: () {
                                      setState(() => isPrivate = true);
                                    },
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 300),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: isPrivate ? Colors.green : Colors.grey.shade400,
                                      ),
                                      child: const Center(child: Text("Private", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Post Action Button Fixed
                          InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () async {
                              final text = _postController.text.trim();
                              setState(() {
                                isLoading = true;
                              });
                              // Check if BOTH image list is empty and text field is empty
                              if (_selectedImages.isEmpty && text.isEmpty) {
                                setState(() {
                                  isLoading = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text("Please add either text or an image to post!"),
                                    behavior: SnackBarBehavior.floating,
                                    width: 320,
                                    backgroundColor: Colors.redAccent,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                                return; // Stop executing
                              }

                              // Run API call
                              try {
                                final dynamic response = await newPost(
                                  private: isPrivate,
                                  textContent: text,
                                  imgPost: _selectedImages,
                                );

                                if (response != null) {
                                  setState(() {
                                    // 1. Clears the input text field
                                    _postController.clear();

                                    // 2. Empties the selected images array
                                    _selectedImages.clear();

                                    // 3. Optional: Reset privacy back to default if desired
                                    isPrivate = false;
                                    isLoading = false;
                                  });

                                  // Optional: Show a success toast or snackbar
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text("Post created successfully!"),
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Colors.green,
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                }
                              } catch (error) {
                                debugPrint("Upload failed: $error");
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              height: 45,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: isLoading?SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(color: _isDark ? Colors.white : Colors.black),
                                ):Text(
                                  "Post",
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}