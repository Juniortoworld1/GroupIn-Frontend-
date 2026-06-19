import 'package:flutter/material.dart';
import '../utils/inputfield.dart';

class Testing extends StatefulWidget {
  const Testing({super.key});

  @override
  State<Testing> createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.yellowAccent,
        body: SafeArea( // Added SafeArea to protect top status bar
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(height: 40),

              // 1. Top Circle Icon (No longer wrapped in Flexible)
              Container(
                height: 100,
                width: 100,
                decoration: const BoxDecoration(
                  color: Colors.white, // Brightened slightly against yellow
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.group),
              ),

              SizedBox(height: 18,) ,
              // 2. The Invisible Spring (Pushes the bottom card down)


              // 3. The Form Container Card (No longer wrapped in Flexible)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(bottom: 24, left: 16, right: 16), // Padding inside container
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Keeps container tight around components
                  children: [
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _Controller("Login", 0),
                        _Controller("Signup", 1)
                      ],
                    ),
                    const SizedBox(height: 20),
                    IndexedStack(
                      index: _currentIndex,
                      children: const [
                        LoginForm(),
                        SignupForm()
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        )
    );
  }

  Widget _Controller(String title , int index){
    bool _isselected = _currentIndex == index;
    return GestureDetector(
      onTap: (){
        setState(() {
          _currentIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: Duration(seconds: 1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15) ,
          color: _isselected?Colors.yellowAccent:Colors.transparent
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(title, style: TextStyle(fontSize: 22, fontWeight: _isselected ? FontWeight.bold : FontWeight.w500),),
              const SizedBox(height: 4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 4,
                width: 40,
                color: _isselected ? Colors.blue : Colors.transparent,
              )
            ],
          ),
        ),
      ),
    );
  }
}

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
      mainAxisSize: MainAxisSize.min,
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
      mainAxisSize: MainAxisSize.min,
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
        InputField(
          label: "Password",
          controller: _passwordController,
          icon: const Icon(Icons.lock),
          hint: "Enter your Password",
        ),
        InputField(
          label: "Password",
          controller: _passwordController,
          icon: const Icon(Icons.lock),
          hint: "Enter your Password",
        ),
        InputField(
          label: "Password",
          controller: _passwordController,
          icon: const Icon(Icons.lock),
          hint: "Enter your Password",
        ),
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