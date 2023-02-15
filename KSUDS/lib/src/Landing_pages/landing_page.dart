import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kcds/constants/enums.dart';
import 'package:kcds/resources/resources.dart';
import 'package:kcds/src/auth/view/auth_view.dart';
import 'package:kcds/src/auth/view_model/auth_vm.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class LandingPage extends StatefulWidget {
  static String route = '/LandingPage';
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthVM>(builder: (context, model, _) {
      return Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: Get.width * .4,
                      height: 20.h,
                      child: Image.asset(R.images.layer2),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 4.w),
                      child: Image.asset(
                        R.images.logo,
                        height: 40.sp,
                      ),
                    )
                  ],
                )),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Who Are You?",
                    style: R.textStyles.heading1().copyWith(fontSize: 46.sp),
                    textAlign: TextAlign.center,
                  ),
                  R.sizedBox.sizedBox5h(),
                   R.sizedBox.sizedBox1h(),
                    R.sizedBox.sizedBox1h(),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7)),
                    elevation: 0,
                    // minWidth: Get.width,
                    height: Get.height * .065,
                    padding: EdgeInsets.symmetric(horizontal: Get.width * .15),
                    color: R.colors.theme,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          R.images.userIcon,
                          height: 21.sp,
                        ),
                        Text(
                          "Customer",
                          style: R.textStyles
                              .heading1()
                              .copyWith(fontSize: 21.sp, color: R.colors.white),
                        ),
                        const SizedBox(
                          width: 20,
                        )
                      ],
                    ),
                    onPressed: () {
                      model.userTYpe = UserType.customer.index;
                      model.update();
                      Get.toNamed(AuthView.route);
                    },
                  ),
                  R.sizedBox.sizedBox2h(),
                   R.sizedBox.sizedBox2h(),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7)),
                    elevation: 0,
                    // minWidth: Get.width,
                    height: Get.height * .065,
                    padding: EdgeInsets.symmetric(horizontal: Get.width * .15),
                    color: R.colors.theme,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          R.images.carrierIcon,
                          height: 21.sp,
                        ),
                        Text(
                          "Courier",
                          style: R.textStyles
                              .heading1()
                              .copyWith(fontSize: 21.sp, color: R.colors.white),
                        ),
                        const SizedBox(
                          width: 20,
                        )
                      ],
                    ),
                    onPressed: () {
                      model.userTYpe = UserType.carrier.index;
                      model.update();
                      Get.toNamed(AuthView.route);
                    },
                  ),
                ],
              ),
            )
          ],
        ),
        bottomNavigationBar: Container(
          alignment: Alignment.bottomRight,
          width: Get.width * .3,
          height: 10.h,
          child: Image.asset(R.images.layer),
        ),
        
      );
    });
  }
}
