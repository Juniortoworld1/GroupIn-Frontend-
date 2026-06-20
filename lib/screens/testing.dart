import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // 1. Don't forget to import provider!
import '../utils/inputfield.dart';
import '../provider/Global.dart' ;

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 3. Watch the provider for changes to update the UI
    final globalProvider = context.watch<GlobalValueProvider>();
    final isDark = globalProvider.getisDarkMode();

    return Container(
      // Optional: Just to demonstrate the theme change dynamically in this widget
      color: isDark ? Colors.grey[900] : Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 4. The new theme toggle button at the top
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              color: isDark ? Colors.amber : Colors.black,
            ),
            onPressed: () {
              // 5. Trigger the modeChanger function on click
              context.read<GlobalValueProvider>().modeChanger();
            },
          ),
          const SizedBox(height: 16),

          InputField(
            label: "Email",
            controller: _loginController,
            icon: const Icon(Icons.email),
            hint: "Enter your Gmail",
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
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              // Optional: change button color based on theme
              backgroundColor: isDark ? Colors.blueGrey : Colors.blue,
            ),
            child: const Text("Login"),
          )
        ],
      ),
    );
  }
}