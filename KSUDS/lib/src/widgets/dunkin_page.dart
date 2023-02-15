import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kcds/resources/resources.dart';
import 'package:kcds/src/base/customer/order/view/type_order_view.dart';
import 'package:kcds/src/widgets/my_button.dart';
import 'package:sizer/sizer.dart';

class DunkinView extends StatefulWidget {
  static String route = '/DunkinView';
  const DunkinView({Key? key}) : super(key: key);

  @override
  State<DunkinView> createState() => _DunkinViewState();
}

class _DunkinViewState extends State<DunkinView> {
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
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(4, 0, 0, 0),
                      child: Text(
                        "Menu:",
                        style:
                            R.textStyles.heading4().copyWith(fontSize: 30.sp),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                            width: Get.width * .9,
                            height: 40.h,
                            //edit this one
                            child: InteractiveViewer(
                                clipBehavior: Clip.none,
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.asset(
                                      "assets/images/DunkinDount.jpeg",
                                      fit: BoxFit.scaleDown,
                                    ),
                                  ),
                                ))),
                      ),
                    ),
                    const SizedBox(height: 70),
                    MyButton(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TypeOrder()),
                        );
                      },
                      buttonText: "Make an Order",
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
