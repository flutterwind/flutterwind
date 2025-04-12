import 'package:flutter/material.dart';

class DarkModeController extends ChangeNotifier {
  bool _isDarkMode = false;
  
  bool get isDarkMode => _isDarkMode;
  
  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
  
  void setDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }
}