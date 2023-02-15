import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kcds/constants/enums.dart';
import 'package:kcds/utils/fb_collections.dart';

import '../../../../../services/order_service.dart';
import '../../../../../services/paypal_payment/pay_pal_payment.dart';
import '../model/order.dart';
import '../view/widgets/payment_successful.dart';

class OrderVM extends ChangeNotifier {
  Order? streamOrder;
  StreamSubscription? _streamSubscriptionCurrentOrder;
  bool isLoading = false;
  void startLoader() {
    isLoading = true;
    notifyListeners();
  }

  void stopLoader() {
    isLoading = false;
    notifyListeners();
  }

  Future<void> placeOrder({required Order order}) async {
    startLoader();
    await FBCollections.orders.doc(order.id).set(order.toJson());

    stopLoader();
    Get.offAll(SuccessPage(
      orderId: order.id,
      isOrder: true,
      title: 'Order Placed Successfully',
    ));
  }

  Future<void> payNow({required String docID, required Order order}) async {
    startLoader();
    print("initializing payment");
    var transId = Timestamp.now().millisecondsSinceEpoch.toString();
    await Get.to(() => PaypalPayment(
          docId: docID,
          order: order,
          transId: transId,
          onFinish: (val) async {
            print("payment finished");
            stopLoader();
            await FBCollections.wallet.add({
              'createdAt': Timestamp.now(),
              'type': TransactionType.add,
              'customerId': order.customerId,
              'amount': 1.0,
            });
            Get.offAll(SuccessPage());
          },
        ));
  }

  Future<void> fetchOrderStream(String doc) async {
    var res = await OrderService.currentOrder(doc);
    _streamSubscriptionCurrentOrder = res.listen((r) {
      streamOrder = Order.fromJson(r.data() as Map<String, dynamic>);
      print("current order:: ${streamOrder?.status}::::: ${r.data()}");
      notifyListeners();
    });
  }

  disposeCurrentOrder() {
    _streamSubscriptionCurrentOrder?.cancel();
    _streamSubscriptionCurrentOrder = null;
    streamOrder = null;
  }
}
