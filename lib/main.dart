import 'package:flutter/material.dart';
import 'package:groupin/provider/Global.provider.dart';
import 'package:groupin/provider/userlogin.provider.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:groupin/routes/routes.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

void main() {
  usePathUrlStrategy() ;
  runApp(
    // 1. Use MultiProvider instead of a single ChangeNotifierProvider
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GlobalValueProvider()),
        ChangeNotifierProvider(create: (context) => UserLoginProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Provider Routing App',
      initialRoute: Routes.login,
      onGenerateRoute: Routes.generateRoute ,
      debugShowCheckedModeBanner: false, // Optional: hides the debug banner
    );
  }
}