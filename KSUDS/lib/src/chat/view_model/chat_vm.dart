import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kcds/src/base/customer/order/model/message.dart';
import 'package:kcds/src/chat/service/chat_service.dart';

class ChatVM extends ChangeNotifier {
  StreamSubscription? streamSubscriptionChat;
  List<MessageModel> chatList = [];
  void sendMessage(MessageModel msg) {
    var documentReference = FirebaseFirestore.instance
        .collection('chats')
        .doc(DateTime.now().millisecondsSinceEpoch.toString());
    documentReference.set(msg.toJson());
    chatList.insert(0, msg);

    notifyListeners();
  }

  Future<void> fetchChat(String roomId, bool isFirstTime, String peerID) async {
    log("fetching chat ");
    var value = await ChatService.messages(roomId);
    streamSubscriptionChat ??= value.listen((event) {
      chatList = event;
      log("length of messages ${chatList.length} } ");
      // if (isFirstTime) {
      //   MessageModel msg = MessageModel(
      //     receiver:
      //         Provider.of<AuthVM>(Get.context!, listen: false).appUser?.email,
      //     sender: peerID,
      //     roomId: roomId,
      //     createdAt: Timestamp.now(),
      //     isSeen: false,
      //   );
      //
      //   sendMessage(
      //     msg,
      //   );
      // }
      notifyListeners();
    });
  }
}
