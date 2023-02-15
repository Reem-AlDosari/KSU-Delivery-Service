import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:kcds/resources/resources.dart';

class ShowMessage {
  static void toast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        fontSize: 14,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER);
  }

  static Widget errorGifWidget() {
    return Center(
        child: Image.asset(
      "assets/images/quit.png",
      scale: 3,
    ));
  }

  //
  // static Widget noInternetWidget({double scale = 2}) {
  //   return Center(
  //       child: Image.asset(
  //     noInternetGif,
  //     scale: scale,
  //   ));
  // }

  static void inSnackBar(String title, String message) {
    Get.snackbar(title, message,
        backgroundColor: R.colors.theme, colorText: R.colors.white);
  }
}
