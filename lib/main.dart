import 'package:flutter/material.dart';
import 'package:groupin/screens/login.dart';
import 'package:provider/provider.dart';
import 'provider/Global.dart';

void main() {
  runApp(Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.blue),
      title: "GroupIn",
      home: ChangeNotifierProvider(
        create: (context) => GlobalValueProvider(),
        child: Login(),
      ),
    );
  }
}
