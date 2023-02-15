import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kcds/resources/resources.dart';
import 'package:kcds/src/base/customer/base_vm.dart';
import 'package:kcds/src/base/customer/history/history_view.dart';
import 'package:kcds/src/base/customer/home/view/home_view.dart';
import 'package:kcds/src/base/customer/order/view/order_view.dart';
import 'package:kcds/src/base/customer/order/view_model/order_vm.dart';
import 'package:kcds/src/base/customer/profile/profile_view.dart';
import 'package:kcds/src/chat/view_model/chat_vm.dart';
import 'package:kcds/utils/loader.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../notifications/notifications_page.dart';
import '../../widgets/signout_sheet.dart';

class BaseView extends StatefulWidget {
  final int page;
  static String route = '/BaseView';
  const BaseView({Key? key, this.page = 0}) : super(key: key);

  @override
  State<BaseView> createState() => _BaseViewState();
}

class _BaseViewState extends State<BaseView> {
  bool isLoading = false;
  late PageController controller;
  OrderVM orderVm = Provider.of<OrderVM>(Get.context!);
  BaseVM baseVm = Provider.of<BaseVM>(Get.context!);
  @override
  void initState() {
    // TODO: implement initState
    controller = PageController(initialPage: widget.page);
    baseVm.page = widget.page;
    // orderVm.streamOrder
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<BaseVM, ChatVM>(builder: (context, model, chatVM, _) {
      return ModalProgressHUD(
        inAsyncCall: isLoading,
        progressIndicator: MyLoader(
          color: R.colors.theme,
        ),
        child: Scaffold(
          appBar: AppBar(
            elevation: model.page == 3 ? 0 : 10,
            backgroundColor: R.colors.theme,
            centerTitle: true,
            leading: Container(
              padding: const EdgeInsets.all(12),
              child: IconButton(
                icon: Icon(
                  Icons.notifications,
                  color: R.colors.black,
                  size: 30,
                ),
                onPressed: () {
                  Get.to(NotificationPage());
                },
              ),
            ),
            title: Text(
              "KSUDS",
              style: R.textStyles.poppinsHeading1(),
            ),
            actions: [
              model.page == 3
                  ? TextButton(
                      onPressed: () {
                        Get.bottomSheet(const SignOutBottomSheet());
                      },
                      child: Text(
                        "Logout ",
                        style: TextStyle(color: R.colors.white),
                      ),
                    )
                  : InkWell(
                      onTap: () {},
                      child: Card(
                        color: R.colors.theme,
                        child: Image.asset(R.images.logo),
                      ),
                    )
            ],
          ),
          body: PageView(
            controller: controller,
            onPageChanged: (page) {
              model.page = page;
              setState(() {});
            },
            children: const [
              HomeView(),
              OrderView(),
              HistoryView(),
              ProfileView(),
            ],
          ),
          bottomNavigationBar: Container(
            width: Get.width,
            padding: const EdgeInsets.only(
              top: 5,
              left: 10,
              right: 10,
            ),
            height: 7.h,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: _bottomItems(0, model, R.images.dashboard, "Home"),
                ),
                Expanded(
                  flex: 1,
                  child: _bottomItems(1, model, R.images.cart, "Order"),
                ),
                Expanded(
                  flex: 1,
                  child: _bottomItems(2, model, R.images.history, "History"),
                ),
                Expanded(
                  flex: 1,
                  child: _bottomItems(3, model, R.images.user, "Profile"),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _bottomItems(int id, BaseVM model, String image, String title) {
    return GestureDetector(
      onTap: () {
        model.selectPage(id);
        controller.jumpToPage(id);
      },
      child: Container(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            id == 2
                ? Icon(
                    Icons.more_horiz_rounded,
                    color: model.page == id
                        ? R.colors.theme
                        : const Color(0xff667C8A),
                    size: 20,
                  )
                : Image.asset(
                    image,
                    height: 20,
                    color: model.page == id
                        ? R.colors.theme
                        : const Color(0xff667C8A),
                  ),
            Expanded(
              child: Text(
                title,
                style: R.textStyles.poppinsTitle1().copyWith(
                      color: model.page == id
                          ? R.colors.theme
                          : const Color(0xff667C8A),
                      fontSize: 12.sp,
                    ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
