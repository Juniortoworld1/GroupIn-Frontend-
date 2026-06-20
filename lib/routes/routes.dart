
import 'package:flutter/cupertino.dart';
import 'package:groupin/screens/testing.dart';

import '../screens/login.dart';

class Routes {
  static String login = "/auth" ;
  static String testing = "/testing" ;
  static Map<String , WidgetBuilder> getRoutes(){
    return {
      login:(context)=>const Auth_Login_Signup()  ,
      testing:(context)=>const Testing()
    } ;
  }

}