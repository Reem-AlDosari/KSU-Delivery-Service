import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:kcds/constants/enums.dart';
import 'package:kcds/resources/resources.dart';
import 'package:kcds/src/auth/view_model/auth_vm.dart';
import 'package:kcds/src/base/carrier/carrier_base_view.dart';
import 'package:kcds/src/base/customer/base_view.dart';
import 'package:kcds/utils/fb_collections.dart';
import 'package:kcds/utils/loader.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class RateUser extends StatefulWidget {
  final String? userId;
  final String? orderId;
  static String route = '/RateUser';
  const RateUser({Key? key, this.userId, this.orderId}) : super(key: key);

  @override
  _RateUserState createState() => _RateUserState();
}

class _RateUserState extends State<RateUser> {
  bool rated = false;
  double rating = 2.5;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        progressIndicator: MyLoader(),
        child: Stack(
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
                        rated ? "Thank You" : 'How Was your Order?',
                        style: R.textStyles.robotoRegular().copyWith(
                              fontSize: 17.sp,
                            ),
                        textAlign: TextAlign.center,
                      )),
                  rated
                      ? Image.asset(
                          R.images.doneIcon,
                          scale: 3,
                        )
                      : Stack(
                          children: [
                            Center(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: R.colors.theme,
                                    shape: BoxShape.circle),
                                height: 130,
                                width: 130,
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 40),
                                child: RatingBar.builder(
                                  initialRating: rating,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemPadding:
                                      EdgeInsets.symmetric(horizontal: 4.0),
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (r) {
                                    rating = r;
                                    setState(() {});
                                    print(rating);
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                  InkWell(
                    onTap: () {
                      if (rated) {
                        if (Provider.of<AuthVM>(context, listen: false)
                                .appUser
                                ?.role ==
                            UserType.customer.index) {
                          Get.offAllNamed(BaseView.route);
                        } else {
                          Get.offAllNamed(CarrierBaseView.route);
                        }
                      } else {
                        rateNow(
                          rating,
                        );
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
                        rated ? "Home" : "Submit",
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
      ),
    );
  }

  rateNow(
    double rating,
  ) async {
    setState(() {
      isLoading = true;
    });
    await FBCollections.ratings.add({
      "createdAt": Timestamp.now(),
      "rate_by": Provider.of<AuthVM>(context, listen: false).appUser?.email,
      "rate_to": widget.userId,
      "order_id": widget.orderId,
      'rating': rating
    });
    setState(() {
      rated = true;
      isLoading = false;
    });
  }
}
