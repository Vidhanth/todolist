import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDark = false;

  bool get isDark => _isDark;
  set isDark(dark) {
    _isDark = dark;
    notifyListeners();
  }
}
