import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kcds/resources/resources.dart';
import 'package:kcds/src/widgets/email_sent_view.dart';
import 'package:kcds/src/widgets/heading.dart';
import 'package:kcds/src/widgets/my_button.dart';
import 'package:kcds/utils/validator.dart';
import 'package:sizer/sizer.dart';

class ResetView extends StatefulWidget {
  static String route = '/ResetView';
  const ResetView({Key? key}) : super(key: key);

  @override
  State<ResetView> createState() => _ResetViewState();
}

class _ResetViewState extends State<ResetView> {
  TextEditingController emailTC = TextEditingController();

  FocusNode emailFn = FocusNode();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  get onPressed => null;

  get child => null;
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: Get.width * .4,
                        height: 20.h,
                        child: Stack(
                          children: [
                            Image.asset(R.images.layer2),
                            Positioned(
                              top: 60,
                              left: 20,
                              child: InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: R.colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            color: R.colors.grey, blurRadius: 5)
                                      ]),
                                  child: Icon(
                                    Icons.arrow_back_ios_rounded,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
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
                      "Forgot password",
                      style: R.textStyles.heading1().copyWith(fontSize: 46.sp),
                    ),
                    InkWell(
                      onTap: () {},
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: "Enter your registered email below ",
                            style: R.textStyles.text1(),
                          ),
                        ]),
                      ),
                    ),
                    R.sizedBox.sizedBox2h(),
                    const Heading(
                      title: 'Email',
                    ),
                    R.sizedBox.sizedBox2h(),
                    TextFormField(
                      decoration: R.decorations.appFieldDecoration(
                          null, "Email", 'Name@example.com'),
                      controller: emailTC,
                      validator: (value) =>
                          FieldValidator.validateEmail(emailTC.text),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      style: R.textStyles.textFormFieldStyle(),
                    ),
                    R.sizedBox.sizedBox2h(),
                    R.sizedBox.sizedBox2h(),
                    R.sizedBox.sizedBox2h(),
                    MyButton(
                      onTap: () async {
                        await FirebaseAuth.instance
                            .sendPasswordResetEmail(email: emailTC.text.trim());
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SentView()),
                        );
                      },
                      buttonText: "Send email",
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

class _onBackPressed {}
