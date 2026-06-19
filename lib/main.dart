import 'package:flutter/material.dart';
import 'package:groupin/provider/Global.dart';
import 'package:groupin/routes/routes.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => GlobalValueProvider(),
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
      // 1. Set your initial route here
      initialRoute: Routes.login,
      routes: Routes.getRoutes(),
    );
  }
}