import 'package:flutter/material.dart';
import '../provider/userlogin.provider.dart';
import '../screens/authSigninSignup.dart';
import '../screens/homepage.dart';
import 'package:provider/provider.dart'; // 🌟 1. Import provider
// import 'your_home_page_file.dart'; // Make sure to import your home/profile screen

class Routes {
  static const String login = "/auth";
  static const String testing = "/testing";

  // Base path for the homepage
  static const String homepagePrefix = "/user/";

  // Helper method to generate the dynamic path string when navigating
  static String homepage(String userId) => "$homepagePrefix$userId";

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    final name = settings.name ?? '';

    // Check if the route starts with "/user/"
    if (name.startsWith(homepagePrefix)) {
      final userId = name.replaceFirst(homepagePrefix, '');

      return MaterialPageRoute(
        settings: settings,
        builder: (context) {
          // 🌟 3. Read your provider state inside the context builder
          // Replace 'isLoggedIn' with whatever boolean property name you use in your provider
          final userProvider = Provider.of<UserLoginProvider>(context, listen: false);
          final bool isLoggedIn = userProvider.isLoggedIn; // Example check: checks if username exists

          if (isLoggedIn) {
            return Homepage(userId: userId);
          } else {
            // 🌟 4. If NOT logged in, redirect them back to the Auth screen!
            return const Auth_Login_Signup();
          }
        },
      );
    }

    // Handle your static routes here
    switch (name) {
      case login:
        return MaterialPageRoute(builder: (context) => const Auth_Login_Signup());
    // case testing:
    //   return MaterialPageRoute(builder: (context) => const TestingPage());
      default:
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}