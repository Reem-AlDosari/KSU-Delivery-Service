import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kcds/resources/resources.dart';
import 'package:kcds/src/auth/view_model/auth_vm.dart';
import 'package:kcds/src/base/customer/home/view_model/home_vm.dart';
import 'package:kcds/src/base/customer/order/view/widgets/order_widget.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../../utils/fb_collections.dart';
import '../../../../../utils/loader.dart';
import '../model/order.dart';

class OrderView extends StatefulWidget {
  static String route = '/OrderView';
  const OrderView({Key? key}) : super(key: key);

  @override
  State<OrderView> createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  List<String> texts = [
    "Requested orders",
    "Active orders",
  ];
  int selected = 0;
  TextEditingController searchTC = TextEditingController();
  PageController controller = PageController();
  @override
  Widget build(BuildContext context) {
    return Consumer2<HomeVM, AuthVM>(builder: (context, model, authVm, _) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                decoration: BoxDecoration(
                    color: selected == 0 ? R.colors.theme : R.colors.white,
                    border: Border.all(color: R.colors.theme)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    2,
                    (index) => Expanded(
                      child: InkWell(
                        onTap: () {
                          selected = index;
                          controller.jumpToPage(index);
                          setState(() {});
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: selected == index
                                ? R.colors.theme
                                : R.colors.white,
                          ),
                          padding: EdgeInsets.all(10),
                          child: Text(
                            texts[index],
                            style: TextStyle(
                                color: selected == index
                                    ? R.colors.white
                                    : R.colors.theme),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView(
                controller: controller,
                children: [
                  Column(
                    children: [
                      Text(
                        "Requested orders",
                        style: R.textStyles.poppinsHeading1(),
                      ),
                      StreamBuilder(
                        stream: FBCollections.orders
                            .where('customerId',
                                isEqualTo: authVm.appUser?.email)
                            .where('status', isEqualTo: 0)
                            .orderBy('createdAt', descending: true)
                            .snapshots(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return Container(
                              margin: EdgeInsets.only(top: Get.height * .3),
                              child: MyLoader(),
                            );
                          } else if (snapshot.data!.docs.isEmpty) {
                            return const SizedBox();
                          } else {
                            return SingleChildScrollView(
                              child: Column(
                                  children: List.generate(
                                      snapshot.data!.docs.length, (index) {
                                DocumentSnapshot doc =
                                    snapshot.data!.docs[index];
                                Order order = Order.fromJson(
                                    doc.data() as Map<String, dynamic>);
                                return OrderWidget(
                                  iSRequested: true,
                                  order: order,
                                );
                              })),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "Active orders",
                        style: R.textStyles.poppinsHeading1(),
                      ),
                      StreamBuilder(
                        stream: FBCollections.orders
                            .where('customerId',
                                isEqualTo: authVm.appUser?.email)
                            .where('status', whereIn: [1, 2, 3, 4])
                            .orderBy('createdAt', descending: true)
                            .snapshots(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return Container(
                              margin: EdgeInsets.only(top: Get.height * .3),
                              child: MyLoader(),
                            );
                          } else if (snapshot.data!.docs.isEmpty) {
                            return const SizedBox();
                          } else {
                            return SingleChildScrollView(
                              child: Column(
                                  children: List.generate(
                                      snapshot.data!.docs.length, (index) {
                                DocumentSnapshot doc =
                                    snapshot.data!.docs[index];
                                Order order = Order.fromJson(
                                    doc.data() as Map<String, dynamic>);
                                return OrderWidget(
                                  isCustomer: true,
                                  order: order,
                                );
                              })),
                            );
                          }
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
