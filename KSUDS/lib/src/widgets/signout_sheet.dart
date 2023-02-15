import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:kcds/resources/resources.dart';
import 'package:kcds/src/landing_pages//landing_page.dart';
import 'package:sizer/sizer.dart';

class SignOutBottomSheet extends StatefulWidget {
  const SignOutBottomSheet({Key? key}) : super(key: key);

  @override
  _SignOutBottomSheetState createState() => _SignOutBottomSheetState();
}

class _SignOutBottomSheetState extends State<SignOutBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: Get.width * .07),
        decoration: BoxDecoration(
          color: R.colors.white,
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 1.h,
            ),
            const Divider(
              thickness: 4.5,
              indent: 100,
              endIndent: 110,
            ),
            SizedBox(
              height: 4.h,
            ),
            Image.asset(
              R.images.logoutDoor,
              scale: 3,
            ),
            SizedBox(
              height: 3.h,
            ),
            Text(
              "Are you sure?",
              style: R.textStyles
                  .robotoMedium()
                  .copyWith(color: R.colors.darkGrey, fontSize: 14.sp),
            ),
            SizedBox(
              height: 2.h,
            ),
            Text(
              "You want to logout.",
              style: R.textStyles
                  .robotoRegular()
                  .copyWith(color: R.colors.darkGrey, fontSize: 12.sp),
            ),
            SizedBox(
              height: 4.h,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      child: Text(
                        'Cancel',
                        style: R.textStyles
                            .robotoMedium()
                            .copyWith(fontSize: 13.sp, color: R.colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        primary: R.colors.grey,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ),
                SizedBox(
                  width: 2.w,
                ),
                Expanded(
                  child: ElevatedButton(
                      child: Text(
                        'Logout',
                        style: R.textStyles
                            .robotoMedium()
                            .copyWith(fontSize: 13.sp, color: R.colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        primary: R.colors.theme,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                      ),
                      onPressed: () async {
                        FirebaseAuth.instance.signOut();
                        Get.offAllNamed(LandingPage.route);
                      }),
                ),
              ],
            ),
            SizedBox(
              height: 2.h,
            ),
          ],
        ));
  }
}
