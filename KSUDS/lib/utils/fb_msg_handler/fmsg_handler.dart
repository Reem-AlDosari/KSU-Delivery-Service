import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kcds/src/base/carrier/carrier_base_view.dart';

import '../../main.dart';
import '../app_utils.dart';

/// top-level function to  handle  background/terminated messages will

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("message data background message ${message.data['type']}");
  switch (message.data['type']) {
    case "1":
      print("promo push notification background message");
      navigatorKey!.currentState!.pushReplacement(
          MaterialPageRoute(builder: (_) => CarrierBaseView()));
      break;
  }
  print('Handling a background message ${message.messageId}');
}

/// Create a [AndroidNotificationChannel] for heads up notifications
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description: 'This channel is used for important notifications.',
  importance: Importance.high,
);

/// Initialize the [FlutterLocalNotificationsPlugin] package.
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class Application extends StatefulWidget {
  final Widget page;
  Application({required this.page});
  @override
  State<StatefulWidget> createState() => _Application();
}

class _Application extends State<Application> {
  Future<void> requestPermissions() async {
    // NotificationSettings settings =
    await FirebaseMessaging.instance.requestPermission(
      announcement: true,
      carPlay: true,
      criticalAlert: true,
    );
  }

  getFcmToken() {
    FirebaseMessaging.instance.getToken().then((token) {
      print("fcm =  $token");
      AppUtils.myFcmToken = token!;
    });
  }

  Future<void> onInit() async {
    requestPermissions();

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    await FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        print("msg: $message");
        _handleMessage(message);
      }
    });
    getFcmToken();
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: '@mipmap/launcher_icon',
              ),
            ));
      }
      print("message data onMessage ${message.data['type']} ");
    });

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  Future<void> _handleMessage(RemoteMessage? message) async {
    print("message data ${message!.data['type']} ");
    switch (message.data['type']) {
      case "1":
        print("case 1 push notification");
        break;
    }
  }

  @override
  void didChangeDependencies() {
    onInit();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.page;
  }
}
