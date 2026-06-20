import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final Icon icon;
  final bool isPassword;

  const InputField({
    super.key, // Updated to modern super parameter syntax
    required this.label,
    required this.controller,
    required this.icon,
    this.isPassword = false,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Field Label Text

        // 2. The Actual Input Field
        TextFormField(
          controller: controller,
          obscureText: isPassword, // Hides text if it's a password field
          style: const TextStyle(color: Colors.transparent),
          decoration: InputDecoration(
            hintText: hint,
            label: Text(label),
            hintStyle: TextStyle(color: Colors.black),
            prefixIcon: icon,
            prefixIconColor: Colors.yellowAccent,
            filled: true,
            // Deep subtle blue/grey tint to match background color 0xFF0B0F19
            fillColor: Colors.yellowAccent.withOpacity(0.1),

            // Modern rounded borders that disappear when not focused
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          ),
        ),
      ],
    );
  }
}