import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kcds/resources/resources.dart';
import 'package:kcds/src/Landing_pages/landing_page.dart';
import 'package:kcds/src/widgets/my_button.dart';
import 'package:sizer/sizer.dart';

class SentView extends StatefulWidget {
  static String route = '/SentView';
  const SentView({Key? key}) : super(key: key);

  @override
  State<SentView> createState() => _SentViewState();
}

class _SentViewState extends State<SentView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: Get.width * .4,
                  height: 20.h,
                  child: Image.asset(R.images.layer2),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Email has been sent!",
                      style: R.textStyles.heading1().copyWith(fontSize: 46.sp),
                    ),
                    InkWell(
                      onTap: () {},
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: "Please check your inbox ",
                            style: R.textStyles.text1(),
                          ),
                        ]),
                      ),
                    ),
                    R.sizedBox.sizedBox2h(),
                    R.sizedBox.sizedBox2h(),
                    R.sizedBox.sizedBox2h(),
                    R.sizedBox.sizedBox2h(),
                    MyButton(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LandingPage()),
                        );
                      },
                      buttonText: "Go to Login",
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        alignment: Alignment.bottomRight,
        width: Get.width * .3,
        height: 10.h,
        child: Image.asset(R.images.layer),
      ),
    );
  }
}
