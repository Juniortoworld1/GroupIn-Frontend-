import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:groupin/provider/Global.provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Imagepicker extends StatelessWidget {
  final String title ;
  final XFile? imageFile;
  final IconData icon ;
  final VoidCallback onTap ;
  final bool is_circle ;
  const Imagepicker({super.key, required this.title, this.imageFile, required this.icon, required this.onTap, required this.is_circle});

  @override
  Widget build(BuildContext context) {
    final watch = context.watch<GlobalValueProvider>() ;
    final _isDark = watch.getisDarkMode();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8,) ,
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 110,
            width: 110,
            decoration: BoxDecoration(
              color: _isDark?Colors.white:Colors.black ,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.green.shade500)
            ),

            child: ClipOval(
              child: imageFile != null
                  ? (kIsWeb
                  ? CircleAvatar(
                radius: 55, // Fits the 110 height/width perfectly
                backgroundImage: NetworkImage(imageFile!.path),
              )
                  : Image.file(
                File(imageFile!.path),
                fit: BoxFit.cover, // Ensures local file fills the circle perfectly
              ))
                  : Column( // Stacked icon and text vertically to fit the circular profile look
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: Colors.grey),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
