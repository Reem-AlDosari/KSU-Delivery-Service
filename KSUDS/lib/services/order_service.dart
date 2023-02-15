import 'package:cloud_firestore/cloud_firestore.dart';

import '../src/base/customer/order/model/order.dart';
import '../utils/fb_collections.dart';

class OrderService {
  static Future<Stream<List<Order>>> customerOrders(String userEmail) async {
    var ref = FBCollections.orders
        .where("customerId", isEqualTo: userEmail)
        .snapshots()
        .asBroadcastStream();
    var x = ref.map((event) => event.docs
        .map((e) => Order.fromJson(e.data() as Map<String, dynamic>))
        .toList());
    return x;
  }

  static Future<Stream<List<Order>>> carrierOrders(String userEmail) async {
    var ref = FBCollections.orders
        .where("carrierId", isEqualTo: userEmail)
        .snapshots()
        .asBroadcastStream();
    var x = ref.map((event) => event.docs
        .map((e) => Order.fromJson(e.data() as Map<String, dynamic>))
        .toList());
    return x;
  }

  static Future<Stream<List<Order>>> packageRequests(String location) async {
    var ref = FBCollections.orders
        .where("status", isEqualTo: 0)
        .snapshots()
        .asBroadcastStream();

    var x = ref.map((event) => event.docs
        .map((e) => Order.fromJson(e.data() as Map<String, dynamic>))
        .toList());
    return x;
  }

  static Future<Stream<DocumentSnapshot>> currentOrder(String doc) async {
    var ref = FBCollections.orders.doc(doc).snapshots().asBroadcastStream();
    var x = ref;
    return x;
  }
}
