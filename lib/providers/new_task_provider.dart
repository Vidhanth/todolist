import 'package:flutter/material.dart';

class NewTaskProvider with ChangeNotifier {
  int _colorIndex = 0;

  set colorIndex(newIndex) {
    _colorIndex = newIndex;
    notifyListeners();
  }

  int get colorIndex => _colorIndex;
}
