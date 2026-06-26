import 'package:flutter/material.dart';

class AppSizes {
  static double width(BuildContext context) {
    double currentWidth = MediaQuery.sizeOf(context).width;
    return currentWidth > 800 ? currentWidth * 0.6 : currentWidth;
  }
  static double height(BuildContext context) => MediaQuery.sizeOf(context).height;

}