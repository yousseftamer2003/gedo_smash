import 'package:flutter/material.dart';

class TabsController with ChangeNotifier {
  int _originalIndex = 0;
  int get originalIndex => _originalIndex;

  int _prevIndex = 0;
  int get prevIndex => _prevIndex;

  void setIndex(int newIndex){
    _prevIndex = originalIndex;
    _originalIndex = newIndex;
    notifyListeners();
  }
}