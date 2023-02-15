import 'package:flutter/material.dart';
import 'package:kcds/resources/resources.dart';

class AppDecorations {
  InputDecoration appFieldDecoration(
    Widget? suffIcon,
    String label,
    String hintText,
  ) {
    return InputDecoration(
      suffixIcon: suffIcon ?? null,

      isDense: true,
      labelStyle: R.textStyles.heading3(),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(width: 1, color: Colors.grey),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(width: 1, color: R.colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(width: 1, color: R.colors.grey),
      ),
      border: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: R.colors.grey),
          borderRadius: BorderRadius.all(Radius.circular(8))),
      filled: false,
      // fillColor: R.colors.fieldFillColor,
      hintText: hintText,

      hintStyle: R.textStyles.textFormFieldHintStyle(),

      //  border: OutlineInputBorder()
    );
  }

  InputDecoration appFieldDecoration2(
    String hintText,
  ) {
    return InputDecoration(
      prefixIcon: const Icon(Icons.search),
      isDense: true,
      contentPadding: const EdgeInsets.only(top: 12),
      focusedBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      enabledBorder: InputBorder.none,
      border: InputBorder.none,
      filled: false,
      // fillColor: R.colors.fieldFillColor,
      hintText: hintText,

      hintStyle: R.textStyles.textFormFieldHintStyle(),

      //  border: OutlineInputBorder()
    );
  }
}
