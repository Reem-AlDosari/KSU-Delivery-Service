import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kcds/constants/enums.dart';
import 'package:kcds/resources/resources.dart';
import 'package:kcds/src/auth/model/user_data.dart';
import 'package:kcds/src/auth/view_model/auth_vm.dart';
import 'package:kcds/src/widgets/Reset_password.dart';
import 'package:kcds/src/widgets/heading.dart';
import 'package:kcds/src/widgets/my_button.dart';
import 'package:kcds/utils/app_utils.dart';
import 'package:kcds/utils/loader.dart';
import 'package:kcds/utils/validator.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class AuthView extends StatefulWidget {
  static String route = '/AuthView';
  const AuthView({Key? key}) : super(key: key);

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  bool visibility = true;
  bool visibility2 = true;
  TextEditingController numberTC = TextEditingController();
  TextEditingController nameTC = TextEditingController();
  TextEditingController emailTC = TextEditingController();

  TextEditingController confirmPassTC = TextEditingController();
  TextEditingController passwordTC = TextEditingController();
  TextEditingController signInEmailTC = TextEditingController();
  TextEditingController signInPassTC = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();
  final PageController _controller = PageController();
  int currentPage = 0;

  get child => null;
  @override
  void dispose() {
    // TODO: implement dispose
    numberTC.clear();
    nameTC.clear();
    emailTC.clear();
    confirmPassTC.clear();
    passwordTC.clear();
    signInEmailTC.clear();
    signInPassTC.clear();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthVM>(builder: (context, model, _) {
      return ModalProgressHUD(
        inAsyncCall: model.isLoading,
        progressIndicator: MyLoader(
          color: R.colors.theme,
        ),
        child: Scaffold(
          body: Stack(
            children: [
              PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _controller,
                onPageChanged: (page) {
                  currentPage = page;
                  setState(() {});
                },
                children: [
                  Form(
                    key: signInFormKey,
                    autovalidateMode: AutovalidateMode.disabled,
                    child: ListView(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(left: 4.w, right: 4.w, top: 20.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Login",
                                style: R.textStyles
                                    .heading1()
                                    .copyWith(fontSize: 46.sp),
                              ),
                              R.sizedBox.sizedBox1h(),
                              Text(
                                "Sign in with your data that you entered during your registration.",
                                style: R.textStyles.text1().copyWith(
                                    fontSize: 13.sp, color: R.colors.darkGrey),
                              ),
                              R.sizedBox.sizedBox2h(),
                              const Heading(
                                title: 'Email',
                              ),
                              TextFormField(
                                decoration: R.decorations.appFieldDecoration(
                                    null, "Email", 'Johngreen@gmail.com'),
                                controller: signInEmailTC,
                                validator: (value) =>
                                    FieldValidator.validateEmail(
                                        signInEmailTC.text),
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                style: R.textStyles.textFormFieldStyle(),
                              ),
                              R.sizedBox.sizedBox2h(),
                              const Heading(
                                title: 'Password',
                              ),
                              TextFormField(
                                decoration: R.decorations.appFieldDecoration(
                                    InkWell(
                                        onTap: () {
                                          setState(() {
                                            visibility = !visibility;
                                          });
                                        },
                                        child: Icon(visibility
                                            ? Icons.visibility_off
                                            : Icons.visibility)),
                                    "Password",
                                    'min 8 characters'),
                                obscureText: visibility,
                                controller: signInPassTC,
                                validator: (value) =>
                                    FieldValidator.validatePassword(
                                        signInPassTC.text),
                                keyboardType: TextInputType.visiblePassword,
                                textInputAction: TextInputAction.done,
                                style: R.textStyles.textFormFieldStyle(),
                              ),
                              R.sizedBox.sizedBox2h(),
                              MyButton(
                                onTap: () {
                                  if (signInFormKey.currentState!.validate()) {
                                    model.signInNow(signInEmailTC.text.trim(),
                                        signInPassTC.text.trim());
                                  }
                                },
                                buttonText: "Login",
                              ),

                              //  Container(
                              //   alignment: Alignment.center,
                              // child: TextButton(
                              //style: TextButton.styleFrom(
                              //  alignment: Alignment.center,
                              //  textStyle: R.textStyles
                              //  .heading2()
                              // .copyWith(color: R.colors.theme),
                              //  ),
                              //  onPressed: () {
                              //  Navigator.push( context,MaterialPageRoute(builder: (context) => const  ResetView()),
                              //   );
                              //  },
                              // child: const Text('Forgot Password?'),
                              //  ),
                              //  ),
                              // R.sizedBox.sizedBox10h(),
                              R.sizedBox.sizedBox1h(),
                              R.sizedBox.sizedBox1h(),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ResetView()),
                                  );
                                },
                                child: RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                      text: "Forgot password?",
                                      style: R.textStyles
                                          .heading2()
                                          .copyWith(color: R.colors.theme),
                                    )
                                  ]),
                                ),
                              ),
                              R.sizedBox.sizedBox1h(),
                              InkWell(
                                onTap: () {
                                  _controller.jumpToPage(1);
                                  print(currentPage);
                                },
                                child: RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                      text: "Don’t have an account? ",
                                      style: R.textStyles.text1(),
                                    ),
                                    TextSpan(
                                      text: "Sign up",
                                      style: R.textStyles
                                          .heading2()
                                          .copyWith(color: R.colors.theme),
                                    )
                                  ]),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Form(
                    key: formKey,
                    autovalidateMode: AutovalidateMode.disabled,
                    child: ListView(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(left: 5.w, right: 5.w, top: 20.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Sign up",
                                style: R.textStyles
                                    .heading1()
                                    .copyWith(fontSize: 46.sp),
                              ),
                              InkWell(
                                onTap: () {
                                  _controller.jumpToPage(0);
                                  print(currentPage);
                                },
                                child: RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                      text: "Already have an account? ",
                                      style: R.textStyles.text1(),
                                    ),
                                    TextSpan(
                                      text: "Sign in",
                                      style: R.textStyles
                                          .heading2()
                                          .copyWith(color: R.colors.theme),
                                    )
                                  ]),
                                ),
                              ),
                              const Heading(
                                title: 'Full name',
                              ),
                              TextFormField(
                                decoration: R.decorations.appFieldDecoration(
                                    null, "Full name", 'John green'),
                                controller: nameTC,
                                validator: (value) =>
                                    FieldValidator.validateName(nameTC.text),
                                keyboardType: TextInputType.name,
                                textInputAction: TextInputAction.next,
                                style: R.textStyles.textFormFieldStyle(),
                              ),
                              const Heading(
                                title: 'Email',
                              ),
                              TextFormField(
                                decoration: R.decorations.appFieldDecoration(
                                    null, "Email", 'Johngreen@gmail.com'),
                                controller: emailTC,
                                validator: (value) =>
                                    FieldValidator.validateEmail(emailTC.text),
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                style: R.textStyles.textFormFieldStyle(),
                              ),
                              const Heading(
                                title: 'Phone Number',
                              ),
                              TextFormField(
                                decoration: R.decorations.appFieldDecoration(
                                    null, "Full name", '(966) 555-0113'),
                                controller: numberTC,
                                validator: (value) =>
                                    FieldValidator.validatePhoneNumber(
                                        numberTC.text),
                                keyboardType: TextInputType.phone,
                                textInputAction: TextInputAction.next,
                                style: R.textStyles.textFormFieldStyle(),
                              ),
                              const Heading(
                                title: 'Password',
                              ),
                              TextFormField(
                                obscureText: visibility,
                                decoration: R.decorations.appFieldDecoration(
                                    InkWell(
                                        onTap: () {
                                          setState(() {
                                            visibility = !visibility;
                                          });
                                        },
                                        child: Icon(visibility
                                            ? Icons.visibility_off
                                            : Icons.visibility)),
                                    "Password",
                                    'min 8 characters'),
                                controller: passwordTC,
                                validator: (value) =>
                                    FieldValidator.validatePassword(
                                        passwordTC.text),
                                keyboardType: TextInputType.visiblePassword,
                                textInputAction: TextInputAction.next,
                                style: R.textStyles.textFormFieldStyle(),
                              ),
                              const Heading(
                                title: 'Confirm Password',
                              ),
                              TextFormField(
                                obscureText: visibility2,
                                decoration: R.decorations.appFieldDecoration(
                                    InkWell(
                                        onTap: () {
                                          setState(() {
                                            visibility2 = !visibility2;
                                          });
                                        },
                                        child: Icon(visibility2
                                            ? Icons.visibility_off
                                            : Icons.visibility)),
                                    "Confirm Password",
                                    ''),
                                controller: confirmPassTC,
                                validator: (value) =>
                                    FieldValidator.validatePasswordMatch(
                                        passwordTC.text, confirmPassTC.text),
                                keyboardType: TextInputType.visiblePassword,
                                textInputAction: TextInputAction.done,
                                style: R.textStyles.textFormFieldStyle(),
                              ),
                              R.sizedBox.sizedBox2h(),
                              MyButton(
                                onTap: () async {
                                  if (formKey.currentState!.validate()) {
                                    UserData userData = UserData(
                                      fullName: nameTC.text,
                                      onRide: false,
                                      createdAt: Timestamp.now(),
                                      phoneNo: numberTC.text,
                                      email: emailTC.text.trim(),
                                      role: model.userTYpe,
                                      status: UserStatus.active.index,
                                    );
                                    await model.registerUser(
                                        userData, passwordTC.text);
                                  }
                                },
                                buttonText: "Create account",
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              AppUtils.isKeyboardOpen(context)
                  ? SizedBox()
                  : Positioned(
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
            ],
          ),
        ),
      );
    });
  }
}
