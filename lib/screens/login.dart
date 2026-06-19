import 'package:flutter/material.dart';
import 'package:groupin/utils/inputfield.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Clean background
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              // Space from the very top of the phone

              // 1. TOP HEADER: Login and Signup Toggles
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTabHeader("Login", 0),
                  const SizedBox(width: 30), // Gap between headers
                  _buildTabHeader("Signup", 1),
                ],
              ),

              // 2. MIDDLE FORM: Centered perfectly on screen
              Expanded(
                child: Center(
                  child: SingleChildScrollView( // Prevents keyboard overflow errors
                    child: IndexedStack(
                      index: _currentIndex,
                      children: const [
                        LoginForm(),
                        SignupForm(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabHeader(String title, int index) {
    bool isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? Colors.blue : Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          // Animated underline indicator
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 3,
            width: 40,
            color: isSelected ? Colors.blue : Colors.transparent,
          ),
        ],
      ),
    );
  }
}

// --- SEPARATE STATEFUL WIDGET FOR LOGIN FORM ---
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
    return Column(
      mainAxisSize: MainAxisSize.min, // Keeps form compact
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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
          style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
          child: const Text("Login"),
        )
      ],
    );
  }
}

// --- SEPARATE STATEFUL WIDGET FOR SIGNUP FORM ---
class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

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
      mainAxisSize: MainAxisSize.min, // Keeps form compact
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InputField(
          label: "Name",
          controller: _nameController,
          icon: const Icon(Icons.person),
          hint: "Enter your name",
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
          style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
          child: const Text("Sign Up"),
        )
      ],
    );
  }
}