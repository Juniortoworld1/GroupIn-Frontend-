import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/userlogin.provider.dart';
import '../screens/authSigninSignup.dart';
import '../screens/homepage.dart';
import '../screens/userProfile.dart';

class Routes {
  static const String login = "/auth";
  static const String testing = "/testing";
  // Base path for the homepage routing parsing
  static const String homepagePrefix = "/user/";
  static const String profilePrefix = "/user/profile/";
  static  String profilePage(String userId) => "$profilePrefix$userId" ;

  // Helper method to generate the dynamic path string when navigating
  static String homepage(String userId) => "$homepagePrefix$userId";

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    final name = settings.name ?? '';

    if(name.startsWith(profilePrefix)){
      return MaterialPageRoute(settings : settings , builder: (routingContext){
        final userProvider = Provider.of<UserLoginProvider>(routingContext , listen: false);
        final bool isLoggedIn = userProvider.isLoggedIn ;

        if(isLoggedIn && userProvider.user!.username == name.replaceFirst(profilePrefix, "")){
          return const userProfile() ;
        }else{
          return const  Homepage() ;
        }
      });
    }

    if (name.startsWith(homepagePrefix)) {
      final userId = name.replaceFirst(homepagePrefix, '');

      return MaterialPageRoute(
        settings: settings,
        builder: (routingContext) {
          final userProvider = Provider.of<UserLoginProvider>(routingContext, listen: false);
          final bool isLoggedIn = userProvider.isLoggedIn;

          if (isLoggedIn && userProvider.user!.username==userId ) {
            return Homepage();
          } else {

            return const Auth_Login_Signup();
          }
        },
      );
    }

    // 2. Handle Static Routes
    switch (name) {
      case "/":// Root entry mapping
      case login:    // Matches "/auth"
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const Auth_Login_Signup(),
        );

      default:
      // Catch-all route mapping fallback configuration
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}