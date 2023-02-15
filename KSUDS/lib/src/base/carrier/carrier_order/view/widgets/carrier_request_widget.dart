import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kcds/resources/resources.dart';
import 'package:kcds/src/auth/view_model/auth_vm.dart';
import 'package:kcds/src/base/carrier/carrier_order/view/widgets/send_offer_dialog.dart';
import 'package:kcds/src/chat/view/chat_view.dart';
import 'package:kcds/src/widgets/my_button.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../../../utils/fb_collections.dart';
import '../../../../../../utils/loader.dart';
import '../../../../../../utils/show_message.dart';
import '../../../../customer/order/model/order.dart';

class CarrierRequestWidget extends StatefulWidget {
  final Order order;
  const CarrierRequestWidget({Key? key, required this.order}) : super(key: key);

  @override
  State<CarrierRequestWidget> createState() => _CarrierRequestWidgetState();
}

class _CarrierRequestWidgetState extends State<CarrierRequestWidget> {
  static bool isOpened = false;
  var authVm = Provider.of<AuthVM>(Get.context!, listen: false);
  ExpandableController exController = ExpandableController(
    initialExpanded: isOpened,
  );

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
        child: ExpandablePanel(
            controller: exController,
            theme: ExpandableThemeData(
                hasIcon: false, inkWellBorderRadius: BorderRadius.circular(8)),
            header: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Order ID:',
                      style: R.textStyles.poppinsTitle1().copyWith(
                            fontSize: 12.sp,
                          ),
                    ),
                    Text(
                      '#${widget.order.id}',
                      style: R.textStyles.poppinsTitle1().copyWith(
                          fontSize: 12.sp, color: const Color(0xff667C8A)),
                    ),
                  ],
                ),
                R.sizedBox.sizedBox1h(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.order.pickAddress ?? "",
                      style: R.textStyles.robotoMedium(),
                    ),
                    if (widget.order.status > 1)
                      IconButton(
                        onPressed: () {
                          Get.to(
                            () => ChatView(
                              orderId: widget.order.id!,
                              peerId: widget.order.customerId,
                              firstMessage: widget.order.orderDetail,
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.chat_outlined,
                          size: 20.sp,
                          color: R.colors.darkGrey,
                        ),
                      )
                    else
                      SizedBox(),
                  ],
                )
              ],
            ),
            collapsed: SizedBox(),
            expanded: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                R.sizedBox.sizedBox1h(),
                Text(
                  "Deliver to",
                  style:
                      R.textStyles.poppinsHeading1().copyWith(fontSize: 12.sp),
                ),
                Text(
                  widget.order.dropAddress ?? "",
                  style: R.textStyles.robotoMedium(),
                ),
                R.sizedBox.sizedBox1h(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          R.images.accessTime,
                          height: 22.sp,
                        ),
                        R.sizedBox.sizedBox2w(),
                        Text(
                          DateFormat('yyyy-MM-dd – hh:mm a')
                              .format((widget.order.createdAt)!.toDate()),
                          style: R.textStyles
                              .poppinsHeading1()
                              .copyWith(fontSize: 12.sp),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          R.images.pin,
                          height: 22.sp,
                        ),
                        Text(
                          '0.7km',
                          style: R.textStyles
                              .poppinsHeading1()
                              .copyWith(fontSize: 12.sp),
                        ),
                      ],
                    )
                  ],
                ),
                R.sizedBox.sizedBox1h(),
                StreamBuilder(
                    stream: FBCollections.offers
                        .where("orderId", isEqualTo: widget.order.id)
                        .where("carrierId", isEqualTo: authVm.appUser?.email)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return MyLoader();
                      } else if (snapshot.data!.docs.isEmpty) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 1.h),
                          child: MyButton(
                              onTap: () {
                                if (authVm.appUser?.onRide == false) {
                                  if (widget.order.requestExpiry! >
                                      Timestamp.now().millisecondsSinceEpoch) {
                                    Get.dialog(SendOfferDialog(
                                      order: widget.order,
                                    ));
                                  } else {
                                    ShowMessage.toast(
                                        'This request has been expired');
                                  }
                                } else {
                                  ShowMessage.toast(
                                      'Please complete your active order first');
                                }
                                setState(() {});
                              },
                              buttonText: "Select Order"),
                        );
                      } else {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 1.h),
                          child: Text(
                            "Offer Sent: ${snapshot.data?.docs[0]['price']}",
                            style: R.textStyles
                                .poppinsTitle1()
                                .copyWith(color: const Color(0xff667C8A)),
                          ),
                        );
                      }
                    }),
              ],
            )

            // tapHeaderToExpand: true,
            // hasIcon: true,
            ),
      ),
    );
  }
}
