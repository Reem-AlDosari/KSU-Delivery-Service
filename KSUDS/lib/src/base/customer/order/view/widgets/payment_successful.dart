import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kcds/constants/enums.dart';
import 'package:kcds/resources/resources.dart';
import 'package:kcds/src/auth/view_model/auth_vm.dart';
import 'package:kcds/src/base/carrier/carrier_base_view.dart';
import 'package:kcds/src/base/carrier/carrier_order/view/widgets/view_offers.dart';
import 'package:kcds/src/base/customer/base_view.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SuccessPage extends StatefulWidget {
  final bool isOrder;
  final String title;
  final String? orderId;
  static String route = '/SuccessPage';
  const SuccessPage(
      {Key? key,
      this.isOrder = false,
      this.orderId,
      this.title = 'Payment Successfully\nDone!'})
      : super(key: key);

  @override
  _SuccessPageState createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
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
                      "${widget.title}",
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
                    if (Provider.of<AuthVM>(context, listen: false)
                            .appUser
                            ?.role ==
                        UserType.customer.index) {
                      if (widget.isOrder) {
                        Get.offAll(ViewOffers(
                            isNewOrder: true, orderId: widget.orderId!));
                      } else {
                        Get.offAllNamed(BaseView.route);
                      }
                    } else {
                      Get.offAllNamed(CarrierBaseView.route);
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 6.h,
                    width: 50.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: R.colors.grey2)),
                    child: Text(
                      widget.isOrder ? "Go to Offers" : "Go to Home",
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
