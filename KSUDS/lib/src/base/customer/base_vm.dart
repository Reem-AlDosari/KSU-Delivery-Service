import 'package:flutter/material.dart';

class BaseVM extends ChangeNotifier {
  int page = 0;
  String carrierEmail = 'dinapef790@vapaka.com';
  void selectPage(int index) {
    page = index;

    notifyListeners();
  }
}
