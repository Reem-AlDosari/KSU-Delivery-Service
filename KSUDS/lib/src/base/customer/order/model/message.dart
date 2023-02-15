import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String? sender;
  String? receiver;

  Timestamp? createdAt;
  String? roomId;
  String? message;
  bool? isSeen;
  int type;
  MessageModel({
    this.sender,
    this.type = 0,
    this.receiver,
    this.createdAt,
    this.roomId,
    this.message,
    this.isSeen,
  });
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      sender: json["sender"],
      type: json["type"],
      receiver: json["receiver"],
      createdAt: json["createdAt"],
      roomId: json["roomId"],
      message: json["message"],
      isSeen: json["isSeen"],
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['sender'] = sender;
    data['type'] = type;
    data['receiver'] = receiver;
    data['createdAt'] = createdAt;
    data['roomId'] = roomId;
    data['message'] = message;
    data['isSeen'] = isSeen;
    return data;
  }
}
