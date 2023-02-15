import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kcds/resources/resources.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../utils/fb_collections.dart';
import '../../../../utils/loader.dart';
import '../../../auth/view_model/auth_vm.dart';
import '../../customer/home/view_model/home_vm.dart';
import '../../customer/order/model/order.dart';
import '../../customer/order/view/widgets/order_widget.dart';

class CarrierHistoryView extends StatelessWidget {
  const CarrierHistoryView({Key? key}) : super(key: key);

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
                "History",
                style: R.textStyles.poppinsHeading1(),
              ),
              StreamBuilder(
                stream: FBCollections.orders
                    .where('carrierId', isEqualTo: authVm.appUser?.email)
                    .where('status', isGreaterThan: 4)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: MyLoader(),
                    );
                  } else if (snapshot.data!.docs.isEmpty) {
                    return Container(
                      margin: EdgeInsets.only(top: Get.height * .3),
                      child: Center(child: Text("No History")),
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
