import 'package:flutter/material.dart';
import 'package:todolist/utils/db_helper.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDark = DBHelper.instance.getFromPrefs('is_dark') ?? false;

  bool get isDark => _isDark;
  set isDark(dark) {
    _isDark = dark;
    DBHelper.instance.saveToPrefs('is_dark', dark);
    notifyListeners();
  }
}
