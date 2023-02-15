import 'package:flutter/material.dart';
import 'package:kcds/resources/resources.dart';
import 'package:kcds/src/base/model/category.dart';

class BaseVM extends ChangeNotifier {
  int page = 0;
  List<Category> categories = [
    Category(name: 'Food', image: R.images.food),
    Category(name: 'Bookstore', image: R.images.books),
    Category(name: 'Coffee', image: R.images.coffee),
  ];

  void selectPage(int index) {
    page = index;

    notifyListeners();
  }
}
