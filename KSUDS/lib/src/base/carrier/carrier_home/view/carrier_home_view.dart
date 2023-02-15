import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kcds/constants/enums.dart';
import 'package:kcds/resources/resources.dart';
import 'package:kcds/src/base/carrier/carrier_order/view/widgets/carrier_request_widget.dart';
import 'package:kcds/src/base/customer/home/view_model/home_vm.dart';
import 'package:kcds/utils/fb_collections.dart';
import 'package:kcds/utils/loader.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../customer/order/model/order.dart';

class CarrierHomeView extends StatefulWidget {
  static String route = '/CarrierHomeView';
  const CarrierHomeView({Key? key}) : super(key: key);

  @override
  State<CarrierHomeView> createState() => _CarrierHomeViewState();
}

class _CarrierHomeViewState extends State<CarrierHomeView> {
  TextEditingController searchTC = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeVM>(builder: (context, model, _) {
      return ListView(children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "All orders",
                style: R.textStyles.poppinsHeading1(),
              ),
              Text(
                "pickup orders request",
                style: R.textStyles
                    .poppinsTitle1()
                    .copyWith(color: const Color(0xff667C8A)),
              ),
              StreamBuilder(
                stream: FBCollections.orders
                    .where('status', isEqualTo: OrderStatus.pending.index)
                    .where('requestExpiry',
                        isGreaterThan: Timestamp.now().millisecondsSinceEpoch)
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
                        padding: EdgeInsets.only(top: Get.height * .3),
                        child: ScalingText("No New Requests"),
                      ),
                    );
                  } else {
                    return Column(
                        children:
                            List.generate(snapshot.data!.docs.length, (index) {
                      DocumentSnapshot doc = snapshot.data!.docs[index];
                      Order order =
                          Order.fromJson(doc.data() as Map<String, dynamic>);
                      return CarrierRequestWidget(
                        order: order,
                      );
                    }));
                  }
                },
              ),
            ],
          ),
        ),
      ]);
    });
  }
}
