import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  String? fullName;
  String? fcmId;
  String? email;
  String? phoneNo;
  int? status;
  int? role;
  double? lat;
  double? long;
  String? Image;
  bool onRide;
  Timestamp? createdAt;
  UserData(
      {this.fullName,
      this.email,
      this.phoneNo,
      this.onRide = false,
      this.status,
      this.fcmId,
      this.Image,
      this.createdAt,
      this.role,
      this.lat,
      this.long
      });
  Map<String, dynamic> toJson() {
    return {
      "fullName": fullName,
      "onRide": onRide,
      "fcm_id": fcmId,
      "email": email,
      "phoneNo": phoneNo,
      "status": status,
      "role": role,
      "lat": lat,
      "long": long,
      "Image": Image,
      "createdAt": createdAt,
    };
  }

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      fullName: json["fullName"],
      onRide: json["onRide"],
      fcmId: json["fcm_id"],
      email: json["email"],
      phoneNo: json["phoneNo"],
      status: json["status"],
      role: json["role"],
      lat: json["lat"],
      long: json["long"],
      createdAt: json["createdAt"],
      Image: json["Image"],
    );
  }
}
