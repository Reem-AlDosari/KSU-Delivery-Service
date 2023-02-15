import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kcds/utils/loader.dart';
import 'package:kcds/utils/show_message.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../../../constants/enums.dart';
import '../../../../../../resources/resources.dart';
import '../../../../../../utils/fb_collections.dart';
import '../../../../../../utils/validator.dart';
import '../../../../../../utils/fb_msg_handler/fb_notifications.dart';
import '../../../../../auth/view_model/auth_vm.dart';
import '../../../../../notifications/model/app_notification.dart';
import '../../../../../widgets/my_button.dart';
import '../../../../customer/order/model/order.dart';
import '../../model/offer.dart';

class SendOfferDialog extends StatefulWidget {
  final Order order;
  const SendOfferDialog({Key? key, required this.order}) : super(key: key);

  @override
  _SendOfferDialogState createState() => _SendOfferDialogState();
}

class _SendOfferDialogState extends State<SendOfferDialog> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  FBNotification fbNotification = FBNotification();
  var provider = Provider.of<AuthVM>(Get.context!, listen: false);
  bool isLoading = false;
  TextEditingController priceTC = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: new ImageFilter.blur(sigmaX: 3, sigmaY: 3),
      child: Material(
        color: Colors.transparent,
        child: ModalProgressHUD(
          inAsyncCall: isLoading,
          progressIndicator: MyLoader(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 22.h),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: R.colors.white,
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FutureBuilder(
                        future: FBCollections.offers
                            .where("orderId", isEqualTo: widget.order.id)
                            .where("carrierId",
                                isEqualTo: provider.appUser?.email)
                            .get(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return MyLoader();
                          } else if (snapshot.data!.docs.isEmpty) {
                            return Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                    "Delivery Price:",
                                    style: R.textStyles
                                        .poppinsTitle1()
                                        .copyWith(
                                            color: const Color(0xff667C8A)),
                                  ),
                                ),
                                TextFormField(
                                  decoration: R.decorations
                                      .appFieldDecoration(null, "price", ' '),
                                  controller: priceTC,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.done,
                                  style: R.textStyles.textFormFieldStyle(),
                                  validator: (value) =>
                                      FieldValidator.checkEmpty(priceTC.text),
                                ),
                                R.sizedBox.sizedBox3h(),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.w, vertical: 1.h),
                                  child: MyButton(
                                      onTap: () {
                                        if (priceTC.text.isNotEmpty)
                                          sendOffer(Offer(
                                            orderDetail:
                                                widget.order.orderDetail,
                                            createdAt: Timestamp.now(),
                                            orderId: widget.order.id,
                                            customerId: widget.order.customerId,
                                            carrierId: provider.appUser?.email,
                                            status: 0,
                                            price: priceTC.text,
                                          ));
                                        else {
                                          ShowMessage.toast(
                                              "Please enter the delivery price");
                                        }
                                      },
                                      buttonText: "Send Offer"),
                                )
                              ],
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> sendOffer(Offer offer) async {
    setState(() {
      isLoading = true;
    });
    await FBCollections.offers.add(offer.toJson());
    AppNotification notify = AppNotification(
        title: "Offer Received",
        message:
            "${Provider.of<AuthVM>(context, listen: false).appUser?.fullName} has sent you an  offer against order no ${widget.order.id}",
        isSeen: false,
        notificationType: NotificationType.sendOffer,
        sender: Provider.of<AuthVM>(context, listen: false).appUser?.email,
        receiver: widget.order.customerId,
        createdAt: Timestamp.now());
    await fbNotification.notifyUser(notify, sendPush: true, sendInApp: true);
    ShowMessage.toast('Offer sent successfully');
    setState(() {
      isLoading = false;
    });
    Get.back();
  }
}
