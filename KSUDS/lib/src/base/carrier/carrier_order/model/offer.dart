import 'package:cloud_firestore/cloud_firestore.dart';

class Offer {
  String? customerId;
  String? carrierId;
  String? orderDetail;
  String? orderId;
  String? price;
  Timestamp? createdAt;
  int status;

  Offer({
    this.createdAt,
    this.customerId,
    this.carrierId,
    this.orderId,
    this.orderDetail,
    this.price,
    this.status = 0,
  });
  Map<String, dynamic> toJson() {
    return {
      "orderDetail": orderDetail,
      "createdAt": createdAt,
      "orderId": orderId,
      "price": price,
      "customerId": customerId,
      "carrierId": carrierId,
      "status": status,
    };
  }

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      orderDetail: json["orderDetail"],
      createdAt: json["createdAt"],
      orderId: json["orderId"],
      price: json["price"],
      customerId: json["customerId"],
      status: json["status"],
      carrierId: json["carrierId"],
    );
  }
}
