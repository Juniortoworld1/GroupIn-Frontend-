import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/Global.dart';
import '../utils/inputfield.dart';

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
    final providerValue = context.watch<GlobalValueProvider>();
    final _isDark = providerValue.getisDarkMode() ;
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
        const SizedBox(height: 8,) ,
        InkWell(onTap: (){} , child: Row(mainAxisAlignment:MainAxisAlignment.end , children: [Text("Forgot" , style: TextStyle(fontSize: 15 , color: _isDark?Colors.white:Colors.black),) , SizedBox(width: 5,) , Center(child: Icon(Icons.help , color: _isDark?Colors.white:Colors.black,) , )],),) ,
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
