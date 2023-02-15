import 'package:flutter/material.dart';

class CarrierBaseVM extends ChangeNotifier {
  int page = 0;
  void selectPage(int index) {
    page = index;

    notifyListeners();
  }
}
