import 'package:flutter/material.dart';
import 'package:groupin/screens/testing.dart';
import 'package:provider/provider.dart';

import '../provider/userlogin.provider.dart';
import '../screens/NewPost.dart';
import '../screens/authSigninSignup.dart';
import '../screens/homepage.dart';
import '../screens/userProfile.dart';

class Routes {
  static const String login = "/auth";
  static const String testing = "/testing";

  static const String homepagePrefix = "/user/";
  static const String profilePrefix = "/user/profile/";
  static const String newPostPrefix = "/user/post/";

  static String profilePage(String userId) => "$profilePrefix$userId";
  static String homepage(String userId) => "$homepagePrefix$userId";
  static String newPostPage(String userId) => "$newPostPrefix$userId";

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    // Standardize root domain loading parameters smoothly
    final name = (settings.name == null || settings.name == "/") ? login : settings.name!;

    // 1. Handle Static Explicit Matches First
    if (name == login) {
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => const Auth_Login_Signup(),
      );
    }

    if (name == testing) {
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => const Testing(),
      );
    }

    // 2. Handle Deep Nested Dynamic Subpaths (Specific rules must come BEFORE broad rules)
    if (name.startsWith(profilePrefix)) {
      return MaterialPageRoute(
        settings: settings,
        builder: (routingContext) {
          final userProvider = Provider.of<UserLoginProvider>(routingContext, listen: false);
          final String usernameParam = name.replaceFirst(profilePrefix, "");

          if (userProvider.isLoggedIn && userProvider.user?.username == usernameParam) {
            return const userProfile();
          } else {
            return const Auth_Login_Signup();
          }
        },
      );
    }

    if (name.startsWith(newPostPrefix)) {
      return MaterialPageRoute(
        settings: settings,
        builder: (routingContext) {
          final userProvider = Provider.of<UserLoginProvider>(routingContext, listen: false);
          final String usernameParam = name.replaceFirst(newPostPrefix, ""); // Fixed bug here

          if (userProvider.isLoggedIn && userProvider.user?.username == usernameParam) {
            return const CreatePostScreen();
          } else {
            return const Auth_Login_Signup();
          }
        },
      );
    }

    // Broadest check comes last so it doesn't intercept profile or posts
    if (name.startsWith(homepagePrefix)) {
      return MaterialPageRoute(
        settings: settings,
        builder: (routingContext) {
          final userProvider = Provider.of<UserLoginProvider>(routingContext, listen: false);
          final String usernameParam = name.replaceFirst(homepagePrefix, "");

          if (userProvider.isLoggedIn && userProvider.user?.username == usernameParam) {
            return Homepage();
          } else {
            return const Auth_Login_Signup();
          }
        },
      );
    }

    // 3. Absolute Fallback Catch-All configuration
    return MaterialPageRoute(
      settings: settings,
      builder: (context) => const Scaffold(
        body: Center(child: Text('Route not found')),
      ),
    );
  }
}