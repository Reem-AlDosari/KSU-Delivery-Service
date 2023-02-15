import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kcds/resources/resources.dart';
import 'package:kcds/src/base/customer/home/view/widgets/product_widget.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../../location/view_model/location_viewmodal.dart';
import '../../../../../widgets/dunkin_page.dart';

class CoffeePage extends StatefulWidget {
  static String route = '/CoffeePage';
  const CoffeePage({Key? key}) : super(key: key);

  @override
  State<CoffeePage> createState() => _CoffeePageState();
}

class _CoffeePageState extends State<CoffeePage> {
  late RoomProvider _roomProvider;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    _roomProvider = Provider.of<RoomProvider>(context, listen: false);
    super.initState();
  }

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
                padding: EdgeInsetsDirectional.fromSTEB(4, 0, 0, 0),
                child: Text(
                  "Coffee:",
                  style: R.textStyles.heading4().copyWith(fontSize: 30.sp),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _roomProvider.selectedStore = 0;
                  Get.toNamed(DunkinView.route);
                },
                child: ProductWidget(
                  name: "Dunkin Donuts",
                  image: R.images.cup,
                  category: 'Coffee',
                ),
              ),
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
