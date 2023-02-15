import 'package:cloud_firestore/cloud_firestore.dart';

class AppNotification {
  String? sender;
  String? key;
  String? receiver;
  Timestamp? createdAt;
  String? title;
  int? notificationType;
  String? message;
  bool isSeen = false;

  AppNotification(
      {this.sender,
      this.receiver,
      this.createdAt,
      this.key,
      this.notificationType,
      this.title,
      this.message,
      this.isSeen = false});

  AppNotification.fromJson(Map<String, dynamic> json) {
    sender = json['notify_by'];
    key = json['key'];
    receiver = json['notify_to'];
    createdAt = json['created_at'];
    title = json['title'];
    message = json['message'];
    isSeen = json['is_seen'];
    notificationType = json['notification_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notify_by'] = this.sender;
    data['key'] = this.key;
    data['notify_to'] = this.receiver;
    data['created_at'] = this.createdAt;
    data['title'] = this.title;
    data['message'] = this.message;
    data['notification_type'] = this.notificationType;
    data['is_seen'] = this.isSeen;
    return data;
  }
}
