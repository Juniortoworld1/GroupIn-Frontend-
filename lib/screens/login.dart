import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/network/dioClient.dart';
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
  bool _isLoading = false ;
  @override
  void initState(){
    super.initState() ;

  }
  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final providerValue = context.watch<GlobalValueProvider>();
    final _isDark = providerValue.getisDarkMode() ;
    return SingleChildScrollView(
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
            const SizedBox(height: 8,) ,
            InkWell(onTap: (){} , child: Row(mainAxisAlignment:MainAxisAlignment.end , children: [Text("Forgot" , style: TextStyle(fontSize: 15 , color: _isDark?Colors.white:Colors.black),) , SizedBox(width: 5,) , Center(child: Icon(Icons.help , color: _isDark?Colors.white:Colors.black,) , )],),) ,
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    _isLoading = true ;
                  });
                  print("Form is valid! Proceeding to sign up...");
                  final Response<dynamic>? response = await login(_usernameController.text, _passwordController.text) ;
                  print("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n ${response?.data['data']['createUser']['_id']}");
                  Map<String , dynamic> apiResponse ={
                    'username':response?.data['data']['createUser']['username']  ,
                    'fullName':response?.data['data']['createUser']['fullName']  ,
                    'email':response?.data['data']['createUser']['email']  ,
                    'avatar':response?.data['data']['createUser']['avatar']  ,
                    'coverImage':response?.data['data']['createUser']['coverImage']  ,
                  };
                  final userProvider = Provider.of<UserLoginProvider>(context , listen: false) ;
                  userProvider.putData(apiResponse) ;
                  Navigator.pushNamed(context, Routes.homepage(response?.data['data']['createUser']['username'])) ;
                  if(response?.statusCode==200){
                    print("\n\n\n\n\n\n\ndone") ;
                    setState(() {
                      _isLoading = false ;
                    });
                  }
                } else {
                  setState(() {
                    _isLoading = false ;
                  });
                  print("Form is invalid!");
                }
              },
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              child: _isLoading?SizedBox( width: 24 , height : 24 ,child: CircularProgressIndicator(color: _isDark?Colors.white:Colors.black,)):Text("Login"),
            )
          ],
        ),
      ),
    );
  }
}
