import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kcds/resources/resources.dart';
import 'package:kcds/src/auth/view/auth_view.dart';
import 'package:sizer/sizer.dart';

class RegistrationSuccessful extends StatefulWidget {
  static String route = '/RegistrationSuccessful';
  const RegistrationSuccessful({Key? key}) : super(key: key);

  @override
  _RegistrationSuccessfulState createState() => _RegistrationSuccessfulState();
}

class _RegistrationSuccessfulState extends State<RegistrationSuccessful> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    alignment: Alignment.center,
                    width: Get.width,
                    child: Text(
                      "Registration Successfully\nDone!",
                      style: R.textStyles.robotoRegular().copyWith(
                            fontSize: 17.sp,
                          ),
                      textAlign: TextAlign.center,
                    )),
                Image.asset(
                  R.images.doneIcon,
                  scale: 3,
                ),
                InkWell(
                  onTap: () {
                    Get.offAllNamed(AuthView.route);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 6.h,
                    width: 50.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: R.colors.grey2)),
                    child: Text(
                      "Login",
                      style: R.textStyles.robotoRegular().copyWith(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              alignment: Alignment.bottomRight,
              width: Get.width * .3,
              height: 10.h,
              child: Image.asset(R.images.layer),
            ),
          ),
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: Get.width * .4,
                    height: 20.h,
                    child: Image.asset(R.images.layer2),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
