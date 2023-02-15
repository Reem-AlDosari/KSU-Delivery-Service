import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kcds/resources/resources.dart';
import 'package:kcds/src/base/carrier/carrier_home/view/carrier_home_view.dart';
import 'package:kcds/src/base/carrier/carrier_order/view/carrier_order_view.dart';
import 'package:kcds/src/base/carrier/history/carrier_history_view.dart';
import 'package:kcds/src/base/customer/base_vm.dart';
import 'package:kcds/src/base/customer/profile/profile_view.dart';
import 'package:kcds/src/notifications/notifications_page.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/signout_sheet.dart';

class CarrierBaseView extends StatefulWidget {
  final int page;
  static String route = '/CarrierBaseView';
  const CarrierBaseView({Key? key, this.page = 0}) : super(key: key);

  @override
  State<CarrierBaseView> createState() => _CarrierBaseViewState();
}

class _CarrierBaseViewState extends State<CarrierBaseView> {
  late PageController controller;
  BaseVM baseVm = Provider.of<BaseVM>(Get.context!);
  @override
  void initState() {
    // TODO: implement initState
    controller = PageController(initialPage: widget.page);
    baseVm.page = widget.page;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BaseVM>(builder: (context, model, _) {
      return Scaffold(
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
                Get.to(() => NotificationPage());
              },
            ),
          ),
          title: Text(
            model.page == 3 ? 'Profile' : "KSUDS",
            style: R.textStyles.poppinsHeading1().copyWith(
                color: model.page == 3 ? Colors.white : R.colors.themeBlack),
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
                : Card(
                    color: R.colors.theme,
                    child: Image.asset(R.images.logo),
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
            CarrierHomeView(),
            CarrierOrderView(),
            CarrierHistoryView(),
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
