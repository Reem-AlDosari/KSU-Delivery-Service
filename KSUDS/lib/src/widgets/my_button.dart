import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kcds/resources/resources.dart';

class MyButton extends StatefulWidget {
  final Function onTap;
  final String buttonText;
  final bool isPrefixIcon;
  final Color? color;
  MyButton({
    required this.onTap,
    required this.buttonText,
    this.isPrefixIcon = false,
    this.color,
  });
  @override
  _MyButtonState createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      elevation: 0,
      // minWidth: Get.width,
      height: Get.height * .06,
      color: widget.color ?? R.colors.theme,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(widget.buttonText, style: R.textStyles.heading2()),
        ],
      ),
      onPressed: () {
        widget.onTap();
      },
    );
  }
}
