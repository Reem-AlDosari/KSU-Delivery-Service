import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kcds/resources/resources.dart';

class MyButton1 extends StatefulWidget {
  final Function onTap;
  final String buttonText;
  final bool isPrefixIcon;
  final Color? color;
  MyButton1(
      {required this.onTap,
      required this.buttonText,
      this.isPrefixIcon = false,
      this.color});
  @override
  _MyButton1State createState() => _MyButton1State();
}

class _MyButton1State extends State<MyButton1> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(85, 0, 0, 0),
      child: MaterialButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
            side: const BorderSide(color: Colors.grey)),
        elevation: 0,
        // minWidth: Get.width,
        //minWidth: Get.width,

        height: Get.height * .05,
        padding: EdgeInsets.symmetric(horizontal: Get.width * .15),
        // color: widget.color ?? R.colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.buttonText, style: R.textStyles.text4()),
          ],
        ),
        onPressed: () {
          widget.onTap();
        },
      ),
    );
  }
}
