import 'package:dio/src/response.dart';
import 'package:flutter/material.dart';
import 'package:groupin/provider/Global.provider.dart';
import 'package:groupin/utils/imagePicker.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../data/network/dioClient.dart';
import '../data/network/signupdioClient.dart';
import '../utils/inputfield.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();

  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  XFile? _profilePic;
  bool _isLoading = false ;

  @override
  void iniState(){
    super.initState();

  }

  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _passwordController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _profilePic = pickedFile;
        });
      }
    } catch (e) {
      print("Error opening gallery: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final watch = context.watch<GlobalValueProvider>();
    final _isDark = watch.getisDarkMode();

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Text(
            "SignUp",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _isDark ? Colors.white : Colors.black),
          ),
          const SizedBox(height: 8),
          Imagepicker(title: "Profile Pic ", icon: Icons.person, onTap: () => _pickImage(ImageSource.gallery), is_circle: true, imageFile: _profilePic),
          const SizedBox(height: 8),

          InputField(
            label: "FullName",
            controller: _nameController,
            icon: const Icon(Icons.person),
            hint: "Enter your full name",
            validator: (value) {
              if (value == null || value.trim().isEmpty) return 'This field cannot be empty';
              return null;
            },
          ),
          const SizedBox(height: 16),

          InputField(
            label: "Username",
            controller: _usernameController,
            icon: const Icon(Icons.alternate_email),
            hint: "Enter your username",
            validator: (value) {
              if (value == null || value.trim().isEmpty) return 'This field cannot be empty';
              return null;
            },
          ),
          const SizedBox(height: 16),

          InputField(
            label: "Email",
            controller: _emailController,
            icon: const Icon(Icons.email),
            hint: "Enter your email address",
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
            hint: "Enter your password",
            validator: (value) {
              if (value == null || value.trim().isEmpty) return 'This field cannot be empty';
              return null;
            },
          ),
          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: ()  async {
              if (_formKey.currentState!.validate())  {
                setState(() {
                  _isLoading=true ;
                });
                print("Form is valid! Proceeding to sign up...");
                print("\n\n\n\n\n\n\n\n\n\n${_profilePic}") ;
                final Response<dynamic>? response = await signup(username: _usernameController.text, fullName: _nameController.text, password: _passwordController.text, email: _emailController.text, avatar: _profilePic! , coverImage: "") ;
                if(response?.statusCode==200){
                  print("\n\n\n\n\n\n\ndone") ;
                  setState(() {
                    _isLoading=false ;
                  });
                }
              } else {
                print("Form is invalid!");
                setState(() {
                  _isLoading=false ;
                });
              }



            },
            style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
            child: _isLoading?SizedBox( width: 24 , height : 24 ,child: CircularProgressIndicator(color: _isDark?Colors.white:Colors.black,)):Text("Sign Up"),
          ),
        ],
      ),
    );
  }
}