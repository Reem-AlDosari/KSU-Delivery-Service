import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  String? id;
  String? customerId;
  String? carrierId;
  String? orderDetail;
  String? dropAddress;
  String? pickAddress;
  String? note;
  String? price;
  String? deliveryPrice;
  String? totalPrice;
  Timestamp? createdAt;
  int status;
  int? requestExpiry;
  int? storeId;
  int paymentStatus;
  double? dropLat;
  double? pickLat;
  double? pickLng;
  double? dropLng;
  Order(
      {this.id,
      this.orderDetail,
      this.requestExpiry,
      this.storeId,
      this.deliveryPrice,
      this.totalPrice,
      this.createdAt,
      this.customerId,
      this.carrierId,
      this.dropAddress,
      this.pickLat,
      this.pickLng,
      this.pickAddress,
      this.note,
      this.price,
      this.status = 0,
      this.paymentStatus = 0,
      this.dropLat,
      this.dropLng});
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "storeId": storeId,
      "requestExpiry": requestExpiry,
      "createdAt": createdAt,
      "deliveryPrice": deliveryPrice,
      "totalPrice": totalPrice,
      "price": price,
      "pickLat": pickLat,
      "pickLng": pickLng,
      "customerId": customerId,
      "orderDetail": orderDetail,
      "carrierId": carrierId,
      "dropAddress": dropAddress,
      "status": status,
      "pickAddress": pickAddress,
      "payment_status": paymentStatus,
      "dropLat": dropLat,
      "dropLng": dropLng,
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json["id"],
      storeId: json["storeId"],
      requestExpiry: json["requestExpiry"],
      pickLat: json["pickLat"],
      totalPrice: json["totalPrice"],
      deliveryPrice: json["deliveryPrice"],
      createdAt: json["createdAt"],
      pickLng: json["pickLng"],
      pickAddress: json["pickAddress"],
      price: json["price"],
      customerId: json["customerId"],
      orderDetail: json["orderDetail"],
      status: json["status"],
      carrierId: json["carrierId"],
      paymentStatus: json["payment_status"],
      dropLat: json["dropLat"],
      dropLng: json["dropLng"],
      dropAddress: json["dropAddress"],
    );
  }
}
