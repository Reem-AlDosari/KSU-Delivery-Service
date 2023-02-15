import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kcds/resources/resources.dart';
import 'package:kcds/src/auth/view_model/auth_vm.dart';
import 'package:kcds/src/base/customer/order/view_model/order_vm.dart';
import 'package:kcds/src/location/view/location_view.dart';
import 'package:kcds/src/widgets/my_button.dart';
import 'package:kcds/utils/show_message.dart';
import 'package:kcds/utils/validator.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../location/model/location_model.dart';
import '../../../../location/view_model/location_viewmodal.dart';
import '../../../../widgets/heading.dart';
import '../model/order.dart';

class TypeOrder extends StatefulWidget {
  static String route = '/TypeOrderView';
  const TypeOrder({Key? key}) : super(key: key);

  @override
  State<TypeOrder> createState() => _TypeOrderState();
}

class _TypeOrderState extends State<TypeOrder> {
  bool gift = false;
  TextEditingController orderTC = TextEditingController();
  TextEditingController noteTC = TextEditingController();

  FocusNode orderFn = FocusNode();
  FocusNode noteFn = FocusNode();
  late RoomProvider _roomProvider;

  int selectRes = 0;
  late Detail rest;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    _roomProvider = Provider.of<RoomProvider>(context, listen: false);
    selectRes = _roomProvider.selectedStore;

    rest = Detail.fromJson(fixPosition[selectRes]);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    orderTC.dispose();
    noteTC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<OrderVM, RoomProvider, AuthVM>(
        builder: (context, vm, roomProvider, authVm, _) {
      return ModalProgressHUD(
        inAsyncCall: vm.isLoading,
        progressIndicator: CircularProgressIndicator(
          color: R.colors.theme,
        ),
        child: Scaffold(
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
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: R.colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                                color: R.colors.grey,
                                                blurRadius: 5)
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
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: const Heading(
                            title: 'Type your order:',
                          ),
                        ),
                        R.sizedBox.sizedBox2h(),
                        TextFormField(
                          decoration:
                              R.decorations.appFieldDecoration(null, "", ''),
                          controller: orderTC,
                          validator: (value) =>
                              FieldValidator.checkEmpty(orderTC.text),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          maxLines: 4,
                          minLines: 4,
                          style: R.textStyles.textFormFieldStyle(),
                        ),
                        R.sizedBox.sizedBox2h(),
                        const Heading(
                          title: 'Choose your location:',
                        ),
                        R.sizedBox.sizedBox1h(),
                        InkWell(
                          onTap: () {
                            Get.toNamed(LocationView.route);
                          },
                          child: Container(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(3),
                                  child: Image.asset(
                                    R.images.pin,
                                    height: 16,
                                    color: R.colors.white,
                                  ),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: R.colors.theme),
                                ),
                                R.sizedBox.sizedBox3w(),
                                Text(
                                  roomProvider.selectedRoom.isEmpty
                                      ? "Locate"
                                      : "${roomProvider.selectedBuilding},hallway ${roomProvider.selectedHallway},${roomProvider.selectedRoom[0].label}",
                                  style: R.textStyles
                                      .robotoRegular()
                                      .copyWith(color: R.colors.theme),
                                ),
                              ],
                            ),
                            //  width: Get.width * .35,
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(color: R.colors.theme)),
                          ),
                        ),
                        const Heading(
                          title: 'Any note for the carrier? ',
                        ),
                        TextFormField(
                          decoration:
                              R.decorations.appFieldDecoration(null, " ", ' '),
                          controller: noteTC,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          style: R.textStyles.textFormFieldStyle(),
                        ),
                        R.sizedBox.sizedBox2h(),
                        Row(
                          children: [
                            Text(
                              "Send as a Gift?",
                              style: R.textStyles.robotoMedium().copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: R.colors.themeBlack),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  gift = !gift;
                                });
                              },
                              icon: Icon(
                                gift
                                    ? Icons.check_box_outline_blank_rounded
                                    : Icons.check_box_rounded,
                                color: R.colors.grey,
                              ),
                            )
                          ],
                        ),
                        R.sizedBox.sizedBox2h(),
                        MyButton(
                          onTap: () async {
                            if (formKey.currentState!.validate()) {
                              if (roomProvider.selectedRoom.isEmpty) {
                                ShowMessage.toast(
                                    'Please choose your location');
                              } else {
                                vm.placeOrder(
                                    order: Order(
                                        status: 0,
                                        storeId: roomProvider.selectedStore,
                                        createdAt: Timestamp.now(),
                                        id: Timestamp.now()
                                            .millisecondsSinceEpoch
                                            .toString(),
                                        requestExpiry:
                                            Timestamp.fromDate(DateTime(
                                          DateTime.now().year,
                                          DateTime.now().month,
                                          DateTime.now().day,
                                          DateTime.now().hour,
                                          DateTime.now().minute + 30,
                                          DateTime.now().second,
                                        )).millisecondsSinceEpoch,
                                        orderDetail: orderTC.text,
                                        note: noteTC.text,
                                        carrierId: '',
                                        pickLat: rest.lat,
                                        pickLng: rest.long,
                                        customerId: authVm.appUser?.email,
                                        dropLat:
                                            roomProvider.selectedRoom[0].lat,
                                        dropLng:
                                            roomProvider.selectedRoom[0].long,
                                        pickAddress:
                                            roomProvider.selectedStore == 0
                                                ? "Dunkin Donuts"
                                                : "Subway",
                                        dropAddress:
                                            "${roomProvider.selectedBuilding},hallway ${roomProvider.selectedHallway},${roomProvider.selectedRoom[0].label}",
                                        price: ''));
                              }
                            }
                          },
                          buttonText: "Place Order",
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
        ),
      );
    });
  }
}
