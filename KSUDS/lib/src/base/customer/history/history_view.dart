import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kcds/resources/resources.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../utils/fb_collections.dart';
import '../../../../utils/loader.dart';
import '../../../auth/view_model/auth_vm.dart';
import '../home/view_model/home_vm.dart';
import '../order/model/order.dart';
import '../order/view/widgets/order_widget.dart';

class HistoryView extends StatelessWidget {
  const HistoryView({Key? key}) : super(key: key);

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
                    .where('customerId', isEqualTo: authVm.appUser?.email)
                    .where('status', isGreaterThan: 4)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: MyLoader(),
                    );
                  } else if (snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text("No History"),
                    );
                  } else {
                    return Column(
                        children:
                            List.generate(snapshot.data!.docs.length, (index) {
                      DocumentSnapshot doc = snapshot.data!.docs[index];
                      Order order =
                          Order.fromJson(doc.data() as Map<String, dynamic>);
                      return OrderWidget(
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
