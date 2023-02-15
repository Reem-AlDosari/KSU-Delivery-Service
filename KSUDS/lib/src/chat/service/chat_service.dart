import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:kcds/src/auth/view_model/auth_vm.dart';
import 'package:kcds/src/base/customer/order/model/message.dart';
import 'package:kcds/src/chat/model/chat_room_model.dart';
import 'package:provider/provider.dart';

class ChatService {
  static Future<Stream<List<MessageModel>>> messages(String roomId) async {
    var ref = FirebaseFirestore.instance
        .collection("chats")
        .where('roomId', isEqualTo: roomId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .asBroadcastStream();
    var x = ref.map((event) =>
        event.docs.map((e) => MessageModel.fromJson(e.data())).toList());
    return x;
  }
}

class InitiateChat {
  String peerId;
  String roomId;
  InitiateChat({
    required this.peerId,
    required this.roomId,
  });
  List<ChatRoomModel> chatRooms = [];
  DocumentSnapshot? myChatRoom;
  var db = FirebaseFirestore.instance;
  Future<ChatRoomModel> now() async {
    QuerySnapshot querySnapshot = await db.collection("ChatRooms").get();
    for (var element in querySnapshot.docs) {
      chatRooms.add(ChatRoomModel.fromJson(element));
    }
    if (!EmptyList.isTrue(querySnapshot.docs)) {
      List<ChatRoomModel> roomInfo = chatRooms
          .where((element) =>
              (element.createdBy ==
                      Provider.of<AuthVM>(Get.context!, listen: false)
                          .appUser
                          ?.email ||
                  element.createdBy == peerId) &&
              (element.peerId == peerId ||
                  element.peerId ==
                      Provider.of<AuthVM>(Get.context!, listen: false)
                          .appUser
                          ?.email))
          .toList();
      if (EmptyList.isTrue(roomInfo)) {
        myChatRoom = await getRoomDoc(roomId);
        return ChatRoomModel.fromJson(myChatRoom?.data());
      } else {
        return roomInfo[0];
      }
    } else {
      DocumentSnapshot doc = await getRoomDoc(roomId);

      return ChatRoomModel.fromJson(doc);
    }
  }

  Future<DocumentSnapshot> getRoomDoc(String docId) async {
    ChatRoomModel chatRoomModel = ChatRoomModel(
      createdAt: Timestamp.now(),
      createdBy:
          Provider.of<AuthVM>(Get.context!, listen: false).appUser?.email,
      roomId: docId,
      peerId: peerId,
      users: [
        Provider.of<AuthVM>(Get.context!, listen: false).appUser?.email,
        peerId
      ],
    );
    print(chatRoomModel.toJson());
    await db.collection("ChatRooms").doc(docId).set(chatRoomModel.toJson());
    DocumentSnapshot chatRoomDoc =
        await db.collection("ChatRooms").doc(docId).get();
    return chatRoomDoc;
  }
}

class EmptyList {
  static bool isTrue(List list) {
    if (list == null || list.isEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
