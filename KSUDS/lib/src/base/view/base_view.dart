import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kcds/resources/resources.dart';
import 'package:kcds/src/base/model/category.dart';
import 'package:kcds/src/base/view_model/base_vm.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class BaseView extends StatefulWidget {
  static String route = '/BaseView';
  const BaseView({Key? key}) : super(key: key);

  @override
  State<BaseView> createState() => _BaseViewState();
}

class _BaseViewState extends State<BaseView> {
  TextEditingController searchTC = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Consumer<BaseVM>(builder: (context, model, _) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: R.colors.theme,
          centerTitle: true,
          leading: Container(
            padding: const EdgeInsets.all(12),
            child: Image.asset(
              R.images.menu,
            ),
          ),
          title: Text(
            "KSUDS",
            style: R.textStyles.poppinsHeading1(),
          ),
          actions: [
            Card(
              color: R.colors.theme,
              child: Image.asset(R.images.logo),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hey!",
                  style: R.textStyles.poppinsHeading1(),
                ),
                Text(
                  "Let’s get your order",
                  style: R.textStyles
                      .poppinsTitle1()
                      .copyWith(color: const Color(0xff667C8A)),
                ),
                Card(
                  child: TextFormField(
                    decoration: R.decorations.appFieldDecoration2(
                      "what are you looking for",
                    ),
                    controller: searchTC,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    style: R.textStyles.textFormFieldStyle(),
                  ),
                ),
                SizedBox(
                  height: 25.h,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: model.categories.length,
                      itemBuilder: (context, index) {
                        Category category = model.categories[index];
                        return categoryWidget(category);
                      }),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Popular!",
                      style: R.textStyles
                          .poppinsHeading1()
                          .copyWith(fontSize: 16.sp),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "View all >",
                        style: R.textStyles
                            .poppinsTitle1()
                            .copyWith(fontSize: 10.sp, color: R.colors.theme),
                      ),
                    ),
                  ],
                ),
                productWidget(1),
                R.sizedBox.sizedBox1h(),
                productWidget(2),
              ],
            ),
          ),
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

  Widget categoryWidget(Category category) {
    return InkWell(
      child: Card(
        child: Container(
          width: 28.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                category.image!,
                height: 40.sp,
              ),
              Text(
                category.name!,
                style: R.textStyles.poppinsTitle1(),
              ),
              Container(
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: R.colors.white,
                  size: 18,
                ),
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: R.colors.black),
              )
            ],
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
    );
  }

  Widget productWidget(int id) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18), color: Color(0xffE0E8EB)),
        child: Card(
          child: Container(
            height: 28.w,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(
                  id == 1 ? R.images.cup : R.images.subway,
                  height: 60.sp,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Delivery:15SR',
                      style: R.textStyles.poppinsTitle1().copyWith(
                            fontSize: 12.sp,
                          ),
                    ),
                    SizedBox(
                      height: .2.h,
                    ),
                    Text(
                      id == 1 ?'Coffee':'Food',
                      style: R.textStyles.poppinsTitle1().copyWith(
                          fontSize: 12.sp, color: const Color(0xff667C8A)),
                    ),
                  ],
                ),

              ],
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
        ),
      ),
    );
  }
}
