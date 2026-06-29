import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:groupin/provider/Global.provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class MultiImagePickerGrid extends StatelessWidget {
  final List<XFile> selectedFiles;
  final VoidCallback onPickImages;
  final Function(int index) onRemoveImage;

  const MultiImagePickerGrid({
    super.key,
    required this.selectedFiles,
    required this.onPickImages,
    required this.onRemoveImage,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<GlobalValueProvider>().getisDarkMode();
    final cardColor = isDark ? Colors.grey[900] : Colors.grey[100];
    final borderColor = isDark ? Colors.white10 : Colors.grey[300]!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Grid View of selected images + Add Button
        GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 3 items per row
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          // Total items = selected images + 1 slot for the "Add" button
          itemCount: selectedFiles.length + 1,
          itemBuilder: (context, index) {
            // CASE 1: The very last slot is ALWAYS the "Add More Images" button
            if (index == selectedFiles.length) {
              return InkWell(
                onTap: onPickImages,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderColor, style: BorderStyle.solid),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_photo_alternate_outlined, color: isDark ? Colors.white60 : Colors.black54, size: 28),
                      const SizedBox(height: 4),
                      Text(
                        "Add Media",
                        style: TextStyle(fontSize: 11, color: isDark ? Colors.white60 : Colors.black54),
                      )
                    ],
                  ),
                ),
              );
            }

            // CASE 2: Selected Image Preview Slots
            final file = selectedFiles[index];
            return Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: kIsWeb
                        ? Image.network(file.path, fit: BoxFit.cover)
                        : Image.file(File(file.path), fit: BoxFit.cover),
                  ),
                ),
                // Tiny minimalist Delete Button overlayed on top right
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () => onRemoveImage(index),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close_rounded, color: Colors.white, size: 14),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}