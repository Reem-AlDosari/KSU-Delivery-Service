import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kcds/resources/resources.dart';
import 'package:sizer/sizer.dart';

class MyTextStyle {
  TextStyle textFormFieldErrorStyle() {
    return GoogleFonts.nunito(
        color: Colors.red,
        letterSpacing: .2,
        fontSize: 12.sp,
        fontWeight: FontWeight.bold);
  }

  TextStyle textFormFieldStyle() {
    return GoogleFonts.nunito(
        letterSpacing: .2, fontSize: 12.sp, fontWeight: FontWeight.w400);
  }

  TextStyle textFormFieldHintStyle() {
    return GoogleFonts.nunito(
        letterSpacing: .2, fontSize: 12.sp, fontWeight: FontWeight.w400);
  }

  TextStyle text1() {
    return GoogleFonts.nunito(
        color: R.colors.darkGrey,
        letterSpacing: .1,
        fontSize: 11.sp,
        fontWeight: FontWeight.w400);
  }

  TextStyle text2() {
    return GoogleFonts.nunito(
        letterSpacing: .2, fontSize: 13.sp, fontWeight: FontWeight.w400);
  }

  TextStyle text3() {
    return GoogleFonts.nunito(
        letterSpacing: 0, fontSize: 12.sp, fontWeight: FontWeight.w400);
  }

  TextStyle text4() {
    return GoogleFonts.nunito(
        color: R.colors.theme,
        letterSpacing: .2,
        fontSize: 10.sp,
        fontWeight: FontWeight.w500);
  }

  TextStyle robotoMedium() {
    return GoogleFonts.roboto(
        color: R.colors.grey2,
        letterSpacing: .2,
        fontSize: 12.sp,
        fontWeight: FontWeight.w500);
  }

  TextStyle robotoRegular() {
    return GoogleFonts.roboto(
        color: R.colors.black,
        letterSpacing: .2,
        fontSize: 12.sp,
        fontWeight: FontWeight.w400);
  }

  TextStyle heading1() {
    return GoogleFonts.nunito(
        color: R.colors.themeBlack,
        letterSpacing: .1,
        fontSize: 20.sp,
        fontWeight: FontWeight.bold);
  }

  TextStyle poppinsHeading1() {
    return GoogleFonts.poppins(
        fontSize: 27.sp, color: R.colors.black, fontWeight: FontWeight.w600);
  }

  TextStyle poppinsTitle1() {
    return GoogleFonts.poppins(
        fontSize: 14.sp, color: R.colors.black, fontWeight: FontWeight.w500);
  }

  TextStyle heading2() {
    return GoogleFonts.nunito(
        color: R.colors.white,
        letterSpacing: .3,
        fontSize: 12.sp,
        fontWeight: FontWeight.bold);
  }

  TextStyle heading3() {
    return GoogleFonts.nunito(
        letterSpacing: .2, fontSize: 12.sp, fontWeight: FontWeight.bold);
  }

  TextStyle heading4() {
    return GoogleFonts.nunito(
        color: R.colors.theme,
        letterSpacing: 0,
        fontSize: 11.sp,
        fontWeight: FontWeight.bold);
  }

  TextStyle title1() {
    return GoogleFonts.nunito(
        letterSpacing: 0,
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: R.colors.darkGrey);
  }

  TextStyle title2() {
    return GoogleFonts.nunito(
        color: R.colors.white,
        letterSpacing: 0,
        fontSize: 13.sp,
        fontWeight: FontWeight.w600);
  }
}
