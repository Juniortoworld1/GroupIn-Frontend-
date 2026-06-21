import 'package:flutter/material.dart';

class GlobalValueProvider extends ChangeNotifier {
  bool _ReRunAnimation = false;
  bool _isDarkMode = false ;
  bool getisDarkMode()=>_isDarkMode;
  void modeChanger(){
    _isDarkMode=!_isDarkMode ;
    notifyListeners();
  }
  bool getAnimation() => _ReRunAnimation;
  void Repeat() {
    _ReRunAnimation = !_ReRunAnimation;
    notifyListeners();
  }
}
