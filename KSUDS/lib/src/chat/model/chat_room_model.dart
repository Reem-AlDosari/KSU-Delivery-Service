import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomModel {
  Timestamp? createdAt;
  String? createdBy;
  String? peerId;
  String? roomId;
  List? users;

  ChatRoomModel({
    this.createdAt,
    this.createdBy,
    this.peerId,
    this.roomId,
    this.users,
  });

  ChatRoomModel.fromJson(dynamic json) {
    createdAt = json["createdAt"];
    createdBy = json["createdBy"];
    peerId = json["peerId"];
    roomId = json["roomId"];
    users = json["users"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["createdAt"] = createdAt;
    map["createdBy"] = createdBy;
    map["peerId"] = peerId;
    map["roomId"] = roomId;
    map["users"] = users;
    return map;
  }
}
