
import 'package:flutter/cupertino.dart';
import 'package:groupin/screens/testing.dart';

import '../screens/login.dart';

class Routes {
  static String login = "/login" ;
  static String testing = "/testing" ;
  static Map<String , WidgetBuilder> getRoutes(){
    return {
      login:(context)=>const Login()  ,
      testing:(context)=>const Testing()
    } ;
  }

}