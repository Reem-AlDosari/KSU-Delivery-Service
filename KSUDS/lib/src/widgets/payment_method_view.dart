import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kcds/resources/resources.dart';
import 'package:kcds/src/base/model/category.dart';
import 'package:kcds/src/base/view_model/base_vm.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:kcds/resources/images.dart';

class PaymentView extends StatefulWidget {
  static String route = '/PaymentView';
  const PaymentView({Key? key}) : super(key: key);

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  TextEditingController searchTC = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Consumer<BaseVM>(builder: (context, model, _) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: R.colors.theme,
          centerTitle: true,
          leading: Container(
            child: IconButton(
                alignment: Alignment.topCenter,
                iconSize: 40,
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context, true);
                }),
          ),
          title: Text(
            "KSUDS",
            style: R.textStyles.poppinsHeading1(),
          ),
          actions: [
            Card(
              color: R.colors.theme,
              child: Image.asset(R.images.logo),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 9.w),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Select your payment method ",
                      style: R.textStyles.poppinsTitle1(),
                    ),
                    Text(
                      "Your total points:",
                      style: R.textStyles.title1(),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 40, 0, 0),
                      child: Row(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              width: Get.width * .4,
                              height: 20.h,
                              child: Image.asset(R.images.pay1),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              width: Get.width * .414,
                              height: 20.h,
                              child: Image.asset(R.images.pay2),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 40, 0, 0),
                      child: Row(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              width: Get.width * .4,
                              height: 20.h,
                              child: Image.asset(R.images.pay3),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              width: Get.width * .4,
                              height: 20.h,
                              child: Image.asset(R.images.pay4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ])),
        ),
      );
    });
  }
}

