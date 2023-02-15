import 'dart:developer';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:kcds/constants/enums.dart';
import 'package:kcds/resources/fonts.dart';
import 'package:kcds/src/auth/view_model/auth_vm.dart';
import 'package:kcds/src/base/customer/order/model/message.dart';
import 'package:kcds/src/base/customer/order/view_model/order_vm.dart';
import 'package:kcds/src/chat/view/export_bill.dart';
import 'package:kcds/src/chat/view_model/chat_vm.dart';
import 'package:kcds/src/widgets/my_button.dart';
import 'package:kcds/utils/loader.dart';
import 'package:kcds/utils/show_message.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../resources/resources.dart';
import '../../../utils/fb_collections.dart';
import '../../../utils/fb_msg_handler/fb_notifications.dart';
import '../../base/customer/base_view.dart';
import '../../base/customer/order/model/order.dart';
import '../../widgets/Report_issue.dart';
import '../../widgets/circle_avatar.dart';
import '../../widgets/other_user_profile.dart';

class ChatView extends StatefulWidget {
  final bool isFirstTime;
  final String? peerId;
  final String? price;
  final String? firstMessage;
  final String orderId;
  static String route = "/ChatView";
  const ChatView({
    Key? key,
    this.peerId,
    this.price,
    this.firstMessage,
    this.isFirstTime = false,
    required this.orderId,
  }) : super(key: key);
  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  var vm = Provider.of<ChatVM>(Get.context!, listen: false);
  var authVm = Provider.of<AuthVM>(Get.context!, listen: false);
  bool expanded = false;
  bool isLoading = false;

  TextEditingController chatTC = TextEditingController();
  ScrollController chatScrollController = ScrollController();

  @override
  void initState() {
    log("room id ${widget.orderId}");
    vm.fetchChat(widget.orderId, widget.isFirstTime, widget.peerId!);
    readMsgs();
    // TODO: implement initState
    super.initState();
  }

  Future<void> readMsgs() async {
    await FirebaseFirestore.instance
        .collection("chats")
        .where('roomId', isEqualTo: widget.orderId)
        .where('receiver', isEqualTo: authVm.appUser?.email)
        .where('isSeen', isEqualTo: false)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        FirebaseFirestore.instance
            .collection("chats")
            .doc(element.id)
            .update({"isSeen": true});
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    //Provider.of<OrderVM>(context, listen: false).disposeCurrentOrder();
    vm.streamSubscriptionChat?.cancel();
    vm.streamSubscriptionChat = null;
    chatTC.dispose();
    chatScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<ChatVM, AuthVM, OrderVM>(
        builder: (context, vm, authVM, orderVm, _) {
      return ModalProgressHUD(
        inAsyncCall: isLoading,
        color: Colors.transparent,
        progressIndicator: MyLoader(
          color: R.colors.theme,
        ),
        child: Scaffold(
            appBar: AppBar(
              toolbarHeight: 9.h,
              elevation: 0.7,
              backgroundColor: R.colors.theme,
              title: Text(
                "KSUDS",
                style: MyTextStyle().poppinsTitle1().copyWith(fontSize: 24),
              ),
              centerTitle: true,
              leading: GestureDetector(
                onTap: () {
                  if (widget.isFirstTime)
                    Get.offAll(BaseView());
                  else {
                    Get.back();
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: R.colors.white,
                      boxShadow: [
                        BoxShadow(color: R.colors.grey, blurRadius: 10)
                      ]),
                  width: 2.h,
                  height: 2.h,
                  margin: EdgeInsets.only(left: 4.w, top: 1.5.h, bottom: 1.5.h),
                  child: Icon(
                    Icons.arrow_back_ios_rounded,
                    color: R.colors.darkGrey,
                  ),
                ),
              ),
              actions: [
                GestureDetector(
                  onTap: () {
                    Get.to(() => ReportAnIssue());
                  },
                  child: Container(
                    padding: EdgeInsets.only(top: 2.h, bottom: 2.h, right: 2.w),
                    child: Image.asset(
                      R.images.helpIcon,
                      height: 20.sp,
                    ),
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                FutureBuilder(
                    future: FBCollections.users.doc(widget.peerId).get(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return MyLoader();
                      } else {
                        return Container(
                          padding: EdgeInsets.all(8),
                          child: Container(
                            padding: EdgeInsets.only(top: 20),
                            // height: 15.h,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Get.to(OtherUserProfile(
                                      email: snapshot.data['email'],
                                    ));
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    child: AppCircleAvatar(
                                      assetImage: R.images.user,
                                      image: snapshot.data['Image'] ?? "",
                                      radius: 30,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '${snapshot.data['fullName'] ?? ""}',
                                            style: R.textStyles
                                                .poppinsTitle1()
                                                .copyWith(
                                                  fontSize: 12.sp,
                                                ),
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  _makePhoneCall(
                                                      'tel:${snapshot.data['phoneNo']}');
                                                });
                                              },
                                              icon: Icon(Icons.phone)),
                                        ],
                                      ),
                                      authVM.appUser?.role ==
                                              UserType.customer.index
                                          ? Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      'the service total price is:',
                                                      style: R.textStyles
                                                          .poppinsTitle1()
                                                          .copyWith(
                                                              fontSize: 12),
                                                    ),
                                                    Text('${widget.price} SR',
                                                        style: R.textStyles
                                                            .poppinsTitle1()),
                                                  ],
                                                ),
                                                orderVm.streamOrder
                                                            ?.paymentStatus ==
                                                        1
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: SizedBox(
                                                          width:
                                                              Get.width * .65,
                                                          child: MyButton(
                                                              color: Color(
                                                                  0xffFBE88D),
                                                              onTap: () {
                                                                Get.dialog(PaymentDialog(
                                                                    orderVm:
                                                                        orderVm,
                                                                    order: orderVm
                                                                        .streamOrder!));
                                                                // orderVm.payNow(
                                                                //     docID: widget
                                                                //         .orderId,
                                                                //     order: orderVm
                                                                //         .streamOrder!);
                                                              },
                                                              buttonText:
                                                                  'Proceed to payment'),
                                                        ),
                                                      )
                                                    : orderVm.streamOrder
                                                                ?.paymentStatus ==
                                                            2
                                                        ? SizedBox()
                                                        : SizedBox()
                                              ],
                                            )
                                          : Column(
                                              children: [
                                                Text(
                                                    '${orderVm.streamOrder?.orderDetail ?? ""}',
                                                    style: R.textStyles
                                                        .poppinsTitle1()),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: SizedBox(
                                                    width: Get.width * .65,
                                                    child: MyButton(
                                                        color:
                                                            Color(0xffFBE88D),
                                                        onTap: () {
                                                          if (orderVm
                                                                  .streamOrder
                                                                  ?.paymentStatus ==
                                                              0)
                                                            Get.to(ExportBill(
                                                              name: snapshot
                                                                      .data[
                                                                  'fullName'],
                                                              order: orderVm
                                                                  .streamOrder!,
                                                            ));
                                                        },
                                                        buttonText: orderVm
                                                                    .streamOrder
                                                                    ?.paymentStatus ==
                                                                0
                                                            ? 'Export Bill'
                                                            : orderVm.streamOrder
                                                                        ?.paymentStatus ==
                                                                    1
                                                                ? 'Bill Exported'
                                                                : orderVm.streamOrder
                                                                            ?.paymentStatus ==
                                                                        2
                                                                    ? 'Bill Paid'
                                                                    : ''),
                                                  ),
                                                )
                                              ],
                                            ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    }),
                SizedBox(
                  height: 3.h,
                ),
                conversation(vm, authVM),
                bottomBar(vm, authVM, orderVm),
              ],
            )),
      );
    });
  }

  Widget bottomBar(ChatVM vm, AuthVM authVM, OrderVM orderVM) {
    return Container(
      alignment: Alignment.center,
      height: 7.h,
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      width: double.infinity,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: const Color(0xff6D6D6D).withOpacity(.16),
            // offset: Offset(1, -2),
          ),
        ],
        color: R.colors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: TextFormField(
              textAlign: TextAlign.start,
              controller: chatTC,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: BorderSide(color: R.colors.white)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: BorderSide(color: R.colors.white)),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: BorderSide(color: R.colors.white)),
                focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: BorderSide(color: R.colors.white)),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: Get.width * .03),
                fillColor: R.colors.white,
                filled: true,
                hintStyle: R.textStyles
                    .text1()
                    .copyWith(color: const Color(0xff63697B), fontSize: 10.sp),
                hintText: "Type something...",
              ),
              onChanged: (value) {},
              onFieldSubmitted: (value) {},
            ),
          ),
          SizedBox(
            width: Get.width * .02,
          ),
          Expanded(
            flex: 0,
            child: InkWell(
                onTap: () async {
                  if (chatTC.text != '') {
                    print(chatTC.text);
                    MessageModel msg = MessageModel(
                      message: chatTC.text,
                      receiver: widget.peerId,
                      sender: authVM.appUser?.email,
                      roomId: orderVM.streamOrder?.id,
                      createdAt: Timestamp.now(),
                      isSeen: false,
                    );
                    chatTC.clear();
                    vm.sendMessage(
                      msg,
                    );
                  } else {
                    Fluttertoast.showToast(msg: "Type Something");
                  }
                },
                child: Image.asset(
                  R.images.send,
                  scale: 4,
                )),
          ),
        ],
      ),
    );
  }

  Widget conversation(ChatVM vm, AuthVM authVM) {
    return Flexible(
      child: ListView.builder(
        padding: const EdgeInsets.all(10.0),
        itemBuilder: (context, index) {
          MessageModel msg = vm.chatList[index];
          log("msgs length ${vm.chatList.length}");

          return buildItem(msg, vm, authVM);
        },
        itemCount: vm.chatList.length,
        reverse: true,
        controller: chatScrollController,
      ),
    );
  }

  Widget buildItem(MessageModel msg, ChatVM vm, AuthVM authVM) {
    if (msg.sender == authVM.appUser?.email) {
      // Right (my message)
      return Column(children: [
        sendChat(msg),
      ]);
    } else {
      // Left (received message)
      return Container(
        child: Column(
          children: <Widget>[
            receivedChat(msg),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: const EdgeInsets.only(bottom: 10.0),
      );
    }
  }

  Widget sendChat(MessageModel msg) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h),
      child: Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * .7, minWidth: 1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Container(
                  padding: EdgeInsets.all(20.sp),
                  decoration: BoxDecoration(
                    color: R.colors.theme,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  child: msg.type == 1
                      ? Image.network(msg.message!)
                      : Text(
                          msg.message ?? "",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget receivedChat(MessageModel msg) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        margin: EdgeInsets.symmetric(vertical: 1.h),
        child: Align(
          alignment: Alignment.centerLeft,
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * .7, minWidth: 1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: Container(
                    padding: EdgeInsets.all(20.sp),
                    decoration: BoxDecoration(
                      color: R.colors.darkGrey,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    child: msg.type == 1
                        ? Image.network(msg.message!)
                        : Text(
                            msg.message ?? "",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class PaymentDialog extends StatefulWidget {
  final Order order;
  final OrderVM orderVm;
  const PaymentDialog({Key? key, required this.order, required this.orderVm})
      : super(key: key);

  @override
  _PaymentDialogState createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  FBNotification fbNotification = FBNotification();
  var provider = Provider.of<AuthVM>(Get.context!, listen: false);
  bool isLoading = false;
  double balance = 0.0;
  TextEditingController priceTC = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    getWalletBalance();
    super.initState();
  }

  getWalletBalance() async {
    await FBCollections.wallet
        .where('customerId', isEqualTo: widget.order.customerId)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        if (element['type'] == TransactionType.add) {
          balance = balance + double.parse("${element['amount']}");
        } else {
          balance = balance - double.parse("${element['amount']}");
        }
      });
      setState(() {});
    });
  }

  payFromWallet(String customerId, double amount, String orderId) async {
    await FBCollections.wallet.add({
      'createdAt': Timestamp.now(),
      'type': TransactionType.subtract,
      'customerId': customerId,
      'amount': amount,
    });
    await FBCollections.orders.doc(orderId).update({
      'payment_status': PaymentStatus.Paid.index,
    });
    ShowMessage.toast("Payment Successful");
  }

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
                padding:
                    EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 20),
                decoration: BoxDecoration(
                    color: R.colors.white,
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        child: Icon(
                          Icons.cancel,
                          color: R.colors.theme,
                        ),
                        onTap: () {
                          Get.back();
                        },
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        Get.back();
                        widget.orderVm.payNow(
                            docID: widget.order.id!, order: widget.order);
                      },
                      leading: Image.asset(R.images.pay2),
                      title: Text('Pay with paypal'),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    ListTile(
                      onTap: () async {
                        if (double.parse(widget.order.totalPrice!) < balance) {
                          Get.back();
                          setState(() {
                            isLoading = true;
                          });
                          await payFromWallet(
                              widget.order.customerId!,
                              double.parse(widget.order.totalPrice!),
                              widget.order.id!);
                          setState(() {
                            isLoading = false;
                          });
                        } else {
                          ShowMessage.toast(
                              "You don't have enough balance in the wallet");
                        }
                      },
                      leading: Image.asset(R.images.pay1),
                      title: Text('Pay with Reward Points'),
                      trailing: Text("$balance SR",
                          style: R.textStyles
                              .poppinsTitle1()
                              .copyWith(color: R.colors.theme)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
