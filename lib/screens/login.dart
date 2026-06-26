import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:groupin/data/model/userModel.dart';
import 'package:provider/provider.dart';

import '../constants/heighWidth.dart';
import '../data/network/logindioClient.dart';
import '../provider/Global.provider.dart';
import '../provider/userlogin.provider.dart';
import '../routes/routes.dart';
import '../utils/inputfield.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final providerValue = context.watch<GlobalValueProvider>();
    final _isDark = providerValue.getisDarkMode();
    final screenWidth = MediaQuery.sizeOf(context).width;

    return Center(
      child: AnimatedContainer(
        duration: const Duration(seconds: 2),
        width: AppSizes.width(context) ,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InputField(
                  label: "Email",
                  controller: _usernameController,
                  icon: const Icon(Icons.email),
                  hint: "Enter your Gmail",
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return 'This field cannot be empty';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                InputField(
                  label: "Password",
                  controller: _passwordController,
                  icon: const Icon(Icons.lock),
                  hint: "Enter your Password",
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return 'This field cannot be empty';
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Forgot",
                        style: TextStyle(fontSize: 15, color: _isDark ? Colors.white : Colors.black),
                      ),
                      const SizedBox(width: 5),
                      Icon(Icons.help, color: _isDark ? Colors.white : Colors.black),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _isLoading = true;
                      });

                      try {
                        print("Proceeding to login...");

                        final dynamic response = await login(
                          _usernameController.text.trim(),
                          _passwordController.text.trim(),
                        );

                        // 1. Verify we got a valid user object back
                        if (response != null) {
                          if (response is! Map<String, dynamic>) {
                            throw Exception("Unexpected data structure from server");
                          }

                          // 2. Parse the single user object into UserModel
                          final userDetail = UserModel.fromMap(response);

                          // 3. Save to provider
                          if (mounted) {
                            final userProvider = Provider.of<UserLoginProvider>(context, listen: false);
                            userProvider.putData(userDetail);
                          }

                          // 4. Turn off loader before leaving the screen
                          setState(() {
                            _isLoading = false;
                          });

                          // 5. Navigate safely
                          if (mounted) {
                            Navigator.pushReplacementNamed(
                              context,
                              Routes.homepage(userDetail.username),
                            );
                          }
                        } else {
                          _showErrorSnackbar("Invalid username or password.");
                          setState(() { _isLoading = false; });
                        }
                      } catch (e) {
                        print("Login process error: $e");
                        _showErrorSnackbar("Something went wrong. Please try again.");
                        setState(() { _isLoading = false; });
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                  child: _isLoading
                      ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(color: _isDark ? Colors.white : Colors.black),
                  )
                      : const Text("Login"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}