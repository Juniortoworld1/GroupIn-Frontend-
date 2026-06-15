import 'package:flutter/material.dart';

class GlobalValueProvider extends ChangeNotifier {
  bool _ReRunAnimation = false;
  bool getAnimation() => _ReRunAnimation;
  void Repeat() {
    _ReRunAnimation = !_ReRunAnimation;
    notifyListeners();
  }
}
