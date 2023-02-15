import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:kcds/src/base/customer/base_vm.dart';
import 'package:kcds/src/chat/view_model/chat_vm.dart';
import 'package:kcds/utils/fb_msg_handler/fb_notifications.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../../../constants/enums.dart';
import '../../../../../../resources/resources.dart';
import '../../../../../../utils/fb_collections.dart';
import '../../../../../../utils/loader.dart';
import '../../../../../auth/view_model/auth_vm.dart';
import '../../../../../chat/service/chat_service.dart';
import '../../../../../chat/view/chat_view.dart';
import '../../../../../notifications/model/app_notification.dart';
import '../../../../customer/base_view.dart';
import '../../../../customer/home/view_model/home_vm.dart';
import '../../../../customer/order/model/message.dart';
import '../../../../customer/order/view/widgets/accept_reject_sheet.dart';

class ViewOffers extends StatefulWidget {
  final bool isNewOrder;
  final String orderId;
  const ViewOffers({Key? key, required this.orderId, this.isNewOrder = false})
      : super(key: key);

  @override
  _ViewOffersState createState() => _ViewOffersState();
}

class _ViewOffersState extends State<ViewOffers> {
  var authVm = Provider.of<AuthVM>(Get.context!, listen: false);
  FBNotification fbNotification = FBNotification();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Consumer2<HomeVM, BaseVM>(builder: (context, model, baseVm, _) {
      return ModalProgressHUD(
        inAsyncCall: isLoading,
        progressIndicator: MyLoader(),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: R.colors.theme,
            centerTitle: true,
            leading: InkWell(
              onTap: () {
                if (widget.isNewOrder) {
                  Get.offAllNamed(BaseView.route);
                } else {
                  Get.back();
                }
              },
              child: Container(
                margin: EdgeInsets.all(10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: R.colors.white,
                    boxShadow: [
                      BoxShadow(color: R.colors.grey, blurRadius: 5)
                    ]),
                child: Icon(
                  Icons.arrow_back_ios_rounded,
                  size: 20,
                  color: R.colors.black,
                ),
              ),
            ),
            title: Text(
              "Offers",
              style: R.textStyles.poppinsHeading1(),
            ),
            actions: [
              Card(
                color: R.colors.theme,
                child: Image.asset(R.images.logo),
              )
            ],
          ),
          body: ListView(children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
              child: StreamBuilder(
                stream: FBCollections.offers
                    .where('orderId', isEqualTo: widget.orderId)
                    .where('status', isEqualTo: 0)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> querySnapshot) {
                  if (!querySnapshot.hasData) {
                    return Container(
                      margin: EdgeInsets.only(top: Get.height * .4),
                      child: MyLoader(),
                    );
                  } else if (querySnapshot.data!.docs.isEmpty) {
                    return Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: Get.height * .4),
                      child: ScalingText(
                        "No Offers Received yet",
                        style: R.textStyles.poppinsTitle1().copyWith(
                              fontSize: 16.sp,
                            ),
                      ),
                    );
                  } else {
                    return Column(
                        children: List.generate(querySnapshot.data!.docs.length,
                            (index) {
                      DocumentSnapshot offerDoc =
                          querySnapshot.data!.docs[index];
                      return FutureBuilder(
                          future: FBCollections.users
                              .doc(offerDoc['carrierId'])
                              .get(),
                          builder: (context, AsyncSnapshot snapshot) {
                            if (!snapshot.hasData) {
                              return MyLoader();
                            } else {
                              return Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18),
                                    color: Color(0xffE0E8EB)),
                                child: Card(
                                  child: Container(
                                    height: 28.w,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        snapshot.data['Image'] == null
                                            ? Image.asset(R.images.userIcon,
                                                fit: BoxFit.cover)
                                            : _blurHashImage(
                                                snapshot.data['Image'] ?? "",
                                                70),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${snapshot.data['fullName']}',
                                              style: R.textStyles
                                                  .poppinsTitle1()
                                                  .copyWith(
                                                    fontSize: 12.sp,
                                                  ),
                                            ),
                                            SizedBox(
                                              height: .2.h,
                                            ),
                                            StreamBuilder(
                                              stream: FBCollections.ratings
                                                  .where('rate_to',
                                                      isEqualTo: snapshot
                                                          .data['email'])
                                                  .snapshots(),
                                              builder: (context,
                                                  AsyncSnapshot<QuerySnapshot>
                                                      snapshot) {
                                                if (!snapshot.hasData) {
                                                  return SizedBox();
                                                } else if (snapshot
                                                    .data!.docs.isEmpty) {
                                                  return Center(
                                                    child:
                                                        Text("Not rated yet"),
                                                  );
                                                } else {
                                                  double rating = 0.0;
                                                  snapshot.data?.docs
                                                      .forEach((element) {
                                                    rating = rating +
                                                        double.parse(
                                                            "${element['rating']}");
                                                    print(
                                                        "total $rating i ${element['rating']}");
                                                  });
                                                  return Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      RatingBar.builder(
                                                        itemSize: 10,
                                                        ignoreGestures: true,
                                                        initialRating: rating /
                                                            (snapshot.data?.docs
                                                                .length)!,
                                                        direction:
                                                            Axis.horizontal,
                                                        allowHalfRating: true,
                                                        itemCount: 5,
                                                        itemPadding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    1.0),
                                                        itemBuilder:
                                                            (context, _) =>
                                                                Icon(
                                                          Icons.star,
                                                          size: 5,
                                                          color: Colors.amber,
                                                        ),
                                                        onRatingUpdate:
                                                            (rating) {},
                                                      ),
                                                      Text(
                                                        "(${snapshot.data?.docs.length})",
                                                        style: TextStyle(
                                                            color:
                                                                R.colors.white),
                                                      )
                                                    ],
                                                  );
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                        Spacer(),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    Get.bottomSheet(
                                                      AcceptRejectSheet(
                                                        accept: true,
                                                        onTap: () async {
                                                          Get.back();
                                                          await acceptOffer(
                                                              offerDoc, baseVm);
                                                        },
                                                      ),
                                                    );
                                                  },
                                                  child: Image.asset(
                                                    R.images.accept,
                                                    height: 28.sp,
                                                  ),
                                                ),
                                                R.sizedBox.sizedBox3w(),
                                                InkWell(
                                                  onTap: () {
                                                    Get.bottomSheet(
                                                      AcceptRejectSheet(
                                                        accept: false,
                                                        onTap: () {
                                                          rejectOffer(offerDoc,
                                                              offerDoc.id);
                                                        },
                                                      ),
                                                    );
                                                  },
                                                  child: Image.asset(
                                                    R.images.reject,
                                                    height: 28.sp,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            R.sizedBox.sizedBox1h(),
                                            Text(
                                              '${offerDoc['price']} SR',
                                              style:
                                                  R.textStyles.poppinsTitle1(),
                                            ),
                                          ],
                                        ),
                                        R.sizedBox.sizedBox3w(),
                                      ],
                                    ),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                ),
                              );
                            }
                          });
                    }));
                  }
                },
              ),
            ),
          ]),
          bottomNavigationBar: Container(
            alignment: Alignment.bottomRight,
            width: Get.width * .3,
            height: 10.h,
            child: Image.asset(R.images.layer),
          ),
        ),
      );
    });
  }

  Future<void> acceptOffer(
    DocumentSnapshot offerDoc,
    BaseVM baseVM,
  ) async {
    setState(() {
      isLoading = true;
    });
    await FBCollections.orders.doc(widget.orderId).update({
      'status': 1,
      'deliveryPrice': offerDoc['price'],
      'carrierId': offerDoc['carrierId'],
    });
    AppNotification notify = AppNotification(
        title: "Offer Accepted",
        message:
            "${authVm.appUser?.fullName} has accepted your offer against order no ${widget.orderId}",
        isSeen: false,
        notificationType: NotificationType.acceptedOffer,
        sender: authVm.appUser?.email,
        receiver: offerDoc['carrierId'],
        createdAt: Timestamp.now());
    await fbNotification.notifyUser(notify, sendPush: true, sendInApp: true);
    await FBCollections.users.doc(offerDoc['carrierId']).update({
      'onRide': true,
    });
    await InitiateChat(peerId: offerDoc['carrierId'], roomId: widget.orderId)
        .now()
        .then((value) async {
      log("my room id ${value.roomId}");
      setState(() {
        isLoading = false;
      });
      MessageModel msg = MessageModel(
        message: offerDoc['orderDetail'],
        receiver: offerDoc['carrierId'],
        sender: offerDoc['customerId'],
        roomId: offerDoc['orderId'],
        createdAt: Timestamp.now(),
        isSeen: false,
      );
      Provider.of<ChatVM>(Get.context!, listen: false).sendMessage(
        msg,
      );
      await Get.to(
        () => ChatView(
          isFirstTime: true,
          price: offerDoc['price'],
          peerId: offerDoc['carrierId'],
          orderId: widget.orderId,
        ),
      );
    });
  }

  Future<void> rejectOffer(
    DocumentSnapshot offerDoc,
    String offerId,
  ) async {
    setState(() {
      isLoading = true;
    });
    await FBCollections.offers.doc(offerId).update({
      'status': 2,
    });
    AppNotification notify = AppNotification(
        title: "Offer Rejected",
        message:
            "${authVm.appUser?.fullName} has rejected your offer against order no ${widget.orderId}",
        isSeen: false,
        notificationType: NotificationType.acceptedOffer,
        sender: authVm.appUser?.email,
        receiver: offerDoc['carrierId'],
        createdAt: Timestamp.now());
    await fbNotification.notifyUser(notify, sendPush: true, sendInApp: true);
    setState(() {
      isLoading = false;
    });
  }

  Widget _blurHashImage(String imageUrl, double size) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Get.width * .02),
      height: size,
      width: size,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: CachedNetworkImage(
          placeholder: (context, url) => const AspectRatio(
            aspectRatio: 1.6,
            child: BlurHash(hash: 'LEHV6nWB2yk8pyo0adR*.7kCMdnj'),
          ),
          imageUrl: imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
