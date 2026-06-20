import 'package:flutter/material.dart';

import '../utils/inputfield.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController()  ;
  final TextEditingController _usernameController = TextEditingController() ;

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 8,) ,
        InputField(
          label: "FullName",
          controller: _nameController,
          icon: const Icon(Icons.person),
          hint: "Enter your fullName",
        ),
        const SizedBox(height: 16),
        InputField(
          label: "Username",
          controller: _usernameController,
          icon: const Icon(Icons.email),
          hint: "Enter your Gmail",
        ),
        const SizedBox(height: 16),
        InputField(
          label: "email",
          controller: _emailController,
          icon: const Icon(Icons.lock),
          hint: "Enter your Password",
        ),
        const SizedBox(height: 16),


        InputField(
          label: "Password",
          controller: _passwordController,
          icon: const Icon(Icons.lock),
          hint: "Enter your Password",
        ),



        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
          child: const Text("Sign Up"),
        ) ,


      ],
    );
  }
}