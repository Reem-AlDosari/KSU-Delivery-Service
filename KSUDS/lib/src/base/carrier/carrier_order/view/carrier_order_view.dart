import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kcds/src/base/customer/home/view_model/home_vm.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../../resources/resources.dart';
import '../../../../../utils/fb_collections.dart';
import '../../../../../utils/loader.dart';
import '../../../../auth/view_model/auth_vm.dart';
import '../../../customer/order/model/order.dart';
import '../../../customer/order/view/widgets/order_widget.dart';

class CarrierOrderView extends StatefulWidget {
  static String route = '/CarrierOrderView';
  const CarrierOrderView({Key? key}) : super(key: key);

  @override
  State<CarrierOrderView> createState() => _CarrierOrderViewState();
}

class _CarrierOrderViewState extends State<CarrierOrderView> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<HomeVM, AuthVM>(builder: (context, model, authVm, _) {
      return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Current Order",
                style: R.textStyles.poppinsHeading1(),
              ),
              StreamBuilder(
                stream: FBCollections.orders
                    .where('carrierId', isEqualTo: authVm.appUser?.email)
                    .where(
                      'status',
                      whereIn: [1, 2, 3, 4],
                    )
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Container(
                      margin: EdgeInsets.only(top: Get.height * .3),
                      child: MyLoader(),
                    );
                  } else if (snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: Get.height * .35),
                        child: ScalingText("No Current Orders"),
                      ),
                    );
                  } else {
                    return Column(
                        children:
                            List.generate(snapshot.data!.docs.length, (index) {
                      DocumentSnapshot doc = snapshot.data!.docs[index];
                      Order order =
                          Order.fromJson(doc.data() as Map<String, dynamic>);
                      return OrderWidget(
                        isCustomer: false,
                        order: order,
                      );
                    }));
                  }
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}
