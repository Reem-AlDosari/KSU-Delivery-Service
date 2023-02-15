import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kcds/src/auth/view_model/auth_vm.dart';
import 'package:provider/provider.dart';

import '../../src/auth/model/user_data.dart';
import '../../src/notifications/model/app_notification.dart';
import '../fb_collections.dart';

class FBNotification {
  Future<void> notifyUser(AppNotification notification,
      {bool sendInApp = false, bool sendPush = false}) async {
    notification.key = Timestamp.now().millisecondsSinceEpoch.toString();
    if (sendInApp) {
      InAppNotifications.sendNotification(notification);
    }
    if (sendPush) {
      try {
        UserData? user = await Provider.of<AuthVM>(Get.context!, listen: false)
            .getUserFromDB(notification.receiver!);
        String fcm = user!.fcmId!;
        print("send notification to ${user.fullName}  fcm:${user.fcmId}");

        sendPushNotification(fcm, notification);
      } catch (e) {
        printError(info: e.toString());
      }
    }
  }

  sendPushNotification(
    String fcmToken,
    AppNotification message,
  ) async {
    Map<String, dynamic> notif = {
      'body': '${message.message}',
      'title': '${message.title}',
    };
    String body = jsonEncode(
      <String, dynamic>{
        'notification': notif,
        'priority': 'high',
        'data': <String, dynamic>{
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'id': '5',
          "sound": "default",
          'status': 'done',
          'type': message.notificationType,
        },
        'to': fcmToken,
      },
    );
    print(body);
    await http
        .post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization':
                'key=AAAA5cJVoL4:APA91bFmMEzq0umF8jeuO9QT3tkEtU9rfln9eRWdAhZ-e1Tf9OYQC8sszjqMy-W2NdRyzt2loj13oL98TETSD6T7-SML-X0gxRyGP8D7syuxHwiaWA5If-1WTD4yMinvJ1xK3IGEp5Un',
          },
          body: body,
        )
        .then((value) => print(value.statusCode));
  }
}

class InAppNotifications {
  static void sendNotification(AppNotification notification) async {
    await FBCollections.notifications
        .doc(notification.key)
        .set(notification.toJson())
        .then((value) {
      print('notification added');
    });
  }
}
