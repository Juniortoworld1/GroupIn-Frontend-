import 'package:flutter/material.dart';
import '../utils/inputfield.dart';

class Auth_Login_Signup extends StatefulWidget {
  const Auth_Login_Signup({super.key});

  @override
  State<Auth_Login_Signup> createState() => _Auth_Login_Signup();
}

class _Auth_Login_Signup extends State<Auth_Login_Signup> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.yellowAccent,
        body: SafeArea(
          bottom: false, // Ensures the white container bleeds cleanly to the absolute bottom edge
          child: Column(
            children: [
              const SizedBox(height: 40),

              // 1. Top Circle Icon
              Container(
                height: 100,
                width: 100,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.group),
              ),

              // 2. The Invisible Spring - Pushes everything below it down

              // 3. The Form Container Card
              Expanded( // CRITICAL: This gives FractionallySizedBox the defined space it needs!
                child: FractionallySizedBox(
                  heightFactor: _currentIndex==0?0.6:0.8, // Adjust this decimal (0.0 to 1.0) to change how high the white sheet goes
                  widthFactor: 1.0,   // Keeps it full width so your input textfields aren't squished
                  alignment: Alignment.bottomCenter, // Keeps the card stuck to the bottom of the screen
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Column(
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

                          // Expanded + SingleChildScrollView handles the long list of inputs when the keyboard appears
                          Expanded(
                            child: _currentIndex == 0
                                ? Padding(
                              padding: const EdgeInsets.only(bottom: 24.0),
                              child: IndexedStack(
                                index: _currentIndex,
                                children: const [
                                  LoginForm(),
                                  SignupForm(),
                                ],
                              ),
                            )
                                : SingleChildScrollView(
                              padding: const EdgeInsets.only(bottom: 24.0),
                              child: IndexedStack(
                                index: _currentIndex,
                                children: const [
                                  LoginForm(),
                                  SignupForm(),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
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
        duration: const Duration(milliseconds: 300),
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

// Keep your LoginForm and SignupForm classes exactly as they are.

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
        ) ,


      ],
    );
  }
}