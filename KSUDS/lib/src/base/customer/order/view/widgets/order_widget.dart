import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kcds/src/auth/view_model/auth_vm.dart';
import 'package:kcds/src/base/customer/order/view/widgets/order_details_page.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../../../resources/resources.dart';
import '../../../../../chat/view/chat_view.dart';
import '../../../../carrier/carrier_order/view/widgets/view_offers.dart';
import '../../model/order.dart';

class OrderWidget extends StatefulWidget {
  final Order order;
  final bool isCustomer;
  final bool iSRequested;
  const OrderWidget(
      {Key? key,
      required this.order,
      this.isCustomer = true,
      this.iSRequested = false})
      : super(key: key);

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  var authVm = Provider.of<AuthVM>(Get.context!, listen: false);
  List<String> statuses = [
    'Pending',
    'Accepted',
    'Going to pickup',
    'Picked Food',
    'Arrived at drop location',
    'Delivered',
    'Canceled'
  ];

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.order.status != 0)
          Get.to(() => OrderDetailsPage(
                order: widget.order,
              ));
      },
      child: Container(
        padding: EdgeInsets.all(3),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: widget.order.status == 1 || widget.order.status == 2
                ? R.colors.theme
                : Color(0xffE0E8EB)),
        child: Card(
          child: Container(
            padding: EdgeInsets.all(5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  widget.order.pickAddress == 'Dunkin Donuts'
                      ? R.images.cup
                      : R.images.subway,
                  fit: BoxFit.cover,
                  height: 60,
                ),
                R.sizedBox.sizedBox1w(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.order.pickAddress}',
                        style: R.textStyles.poppinsTitle1().copyWith(
                              fontSize: 12.sp,
                            ),
                      ),
                      SizedBox(
                        height: .2.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (widget.iSRequested)
                            Text(
                              widget.order.requestExpiry! <
                                      Timestamp.now().millisecondsSinceEpoch
                                  ? "Expired"
                                  : statuses[widget.order.status],
                              style: R.textStyles.poppinsTitle1().copyWith(
                                  fontSize: 14.sp,
                                  decoration: TextDecoration.underline),
                            )
                          else
                            Text(
                              statuses[widget.order.status],
                              style: R.textStyles.poppinsTitle1().copyWith(
                                  fontSize: 14.sp,
                                  decoration: TextDecoration.underline),
                            ),
                          widget.order.status == 0
                              ? TextButton(
                                  onPressed: () {
                                    Get.to(() => ViewOffers(
                                          orderId: widget.order.id!,
                                        ));
                                  },
                                  child: Text(
                                    "View Offers",
                                    style: R.textStyles.robotoMedium().copyWith(
                                        decoration: TextDecoration.underline),
                                  ),
                                )
                              : SizedBox(),
                        ],
                      ),
                      widget.order.status == 0
                          ? SizedBox()
                          : widget.order.status > 5
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      DateFormat('yyyy-MMM-dd').format(
                                          (widget.order.createdAt?.toDate())!),
                                      style: R.textStyles
                                          .poppinsHeading1()
                                          .copyWith(fontSize: 10.sp),
                                    ),
                                    Text(
                                      'Order ID:${widget.order.id}',
                                      style:
                                          R.textStyles.poppinsTitle1().copyWith(
                                                fontSize: 10.sp,
                                              ),
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Order ID:${widget.order.id}',
                                      style:
                                          R.textStyles.poppinsTitle1().copyWith(
                                                fontSize: 10.sp,
                                              ),
                                    ),
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            if (widget.order.status != 0)
                                              Get.to(() => OrderDetailsPage(
                                                    order: widget.order,
                                                    showDetail: false,
                                                  ));
                                          },
                                          child: Image.asset(
                                            R.images.pin,
                                            height: 24,
                                          ),
                                        ),
                                        R.sizedBox.sizedBox3w(),
                                        StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection("chats")
                                              .where('roomId',
                                                  isEqualTo: widget.order.id)
                                              .where('receiver',
                                                  isEqualTo:
                                                      authVm.appUser?.email)
                                              .where('isSeen', isEqualTo: false)
                                              .snapshots(),
                                          builder: (context,
                                              AsyncSnapshot<QuerySnapshot>
                                                  snapshot) {
                                            if (!snapshot.hasData) {
                                              return SizedBox();
                                            } else if (snapshot
                                                .data!.docs.isEmpty) {
                                              return IconButton(
                                                  onPressed: () {
                                                    Get.to(() => ChatView(
                                                          price: widget
                                                              .order.price,
                                                          peerId: widget
                                                              .order.carrierId,
                                                          orderId: (widget
                                                              .order.id)!,
                                                        ));
                                                  },
                                                  icon: Image.asset(
                                                      R.images.commentIcon));
                                            } else {
                                              return Badge(
                                                position: BadgePosition.topEnd(
                                                    end: 0, top: 6),
                                                badgeContent: Text(
                                                  '${snapshot.data!.docs.length}',
                                                  style: R.textStyles
                                                      .robotoRegular()
                                                      .copyWith(
                                                          fontSize: 8,
                                                          color:
                                                              R.colors.white),
                                                ),
                                                child: IconButton(
                                                    onPressed: () {
                                                      Get.to(() => ChatView(
                                                            price: widget
                                                                .order.price,
                                                            peerId: widget.order
                                                                .carrierId,
                                                            orderId: (widget
                                                                .order.id)!,
                                                          ));
                                                    },
                                                    icon: Image.asset(
                                                        R.images.commentIcon)),
                                              );
                                            }
                                          },
                                        ),
                                      ],
                                    )
                                  ],
                                )
                    ],
                  ),
                ),
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
        ),
      ),
    );
  }
}
