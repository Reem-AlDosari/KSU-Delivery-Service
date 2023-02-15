import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kcds/src/auth/view_model/auth_vm.dart';
import 'package:kcds/src/notifications/model/app_notification.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import '../../resources/resources.dart';
import '../../utils/fb_collections.dart';
import '../../utils/loader.dart';
import '../../utils/show_message.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final SlidableController slideAbleController = SlidableController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthVM>(builder: (context, model, _) {
      return ModalProgressHUD(
        inAsyncCall: isLoading,
        progressIndicator: MyLoader(),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: R.colors.theme,
            centerTitle: true,
            leading: Container(
              padding: const EdgeInsets.all(12),
              child: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: R.colors.white,
                      boxShadow: [
                        BoxShadow(color: R.colors.grey, blurRadius: 5)
                      ]),
                  child: Icon(
                    Icons.arrow_back_ios_rounded,
                    size: 20,
                    color: R.colors.black,
                  ),
                ),
              ),
            ),
            title: Text(
              "Notifications",
              style: R.textStyles.poppinsTitle1(),
            ),
          ),
          body: Container(
            margin: EdgeInsets.only(top: Get.height * .025),
            height: Get.height,
            child: StreamBuilder(
              stream: FBCollections.notifications
                  .where("notify_to", isEqualTo: model.appUser?.email)
                  .orderBy('created_at', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: MyLoader(),
                  );
                } else if (snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Image.asset(
                      R.images.emptyNotification,
                      scale: 5,
                    ),
                  );
                } else {
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot doc = snapshot.data!.docs[index];
                        AppNotification notification = AppNotification.fromJson(
                            doc.data() as Map<String, dynamic>);
                        return card(notification);
                      });
                }
              },
            ),
          ),
        ),
      );
    });
  }

  Widget card(AppNotification notification) {
    return Slidable(
      key: Key(notification.key!),
      actionExtentRatio: 0.2,
      controller: slideAbleController,
      actionPane: SlidableBehindActionPane(),
      child: InkWell(
        onTap: () async {
          await FBCollections.notifications
              .doc(notification.key)
              .update({"is_seen": true});
          switch (notification.notificationType) {
          }
        },
        child: Container(
          margin: EdgeInsets.symmetric(
              vertical: Get.height * .007, horizontal: Get.width * .05),
          padding: EdgeInsets.symmetric(
              horizontal: Get.width * .03, vertical: Get.height * .01),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0xff565656).withOpacity(.20),
                blurRadius: 18,
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 0,
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          color: Color(0xffD9EFFF),
                          borderRadius: BorderRadius.circular(8)),
                      child: Image.asset(
                        R.images.bellIconBlue,
                        scale: 4,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification.title!,
                          style: R.textStyles
                              .poppinsTitle1()
                              .copyWith(color: R.colors.theme),
                        ),
                        SizedBox(
                          height: Get.height * .005,
                        ),
                        Text(
                          DateFormat('dd-MM-yyyy - h:mm a')
                              .format(notification.createdAt!.toDate()),
                          style: R.textStyles
                              .text1()
                              .copyWith(color: R.colors.grey2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(top: Get.height * .01),
                      alignment: Alignment.bottomLeft,
                      child: RichText(
                        overflow: TextOverflow.fade,
                        text: TextSpan(
                          style: R.textStyles
                              .text1()
                              .copyWith(color: R.colors.black),
                          text: notification.message!,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      secondaryActions: <Widget>[
        IconSlideAction(
            color: Colors.transparent,
            iconWidget: Container(
              height: Get.height * .07,
              width: Get.width * .45,
              margin: EdgeInsets.only(right: 25),
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: InkWell(
                onTap: () async {
                  deleteNotification(notification);
                },
                child: Center(
                    child: Icon(
                  Icons.delete,
                  color: R.colors.white,
                )),
              ),
            ),
            onTap: () {}),
      ],
    );
  }

  deleteNotification(AppNotification notification) async {
    await FBCollections.notifications.doc(notification.key).delete();

    ShowMessage.toast("Notification deleted");
  }
}
