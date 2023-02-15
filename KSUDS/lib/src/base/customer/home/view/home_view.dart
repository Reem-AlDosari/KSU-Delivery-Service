import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kcds/resources/resources.dart';
import 'package:kcds/src/base/customer/home/model/category.dart';
import 'package:kcds/src/base/customer/home/view/widgets/category_widget.dart';
import 'package:kcds/src/base/customer/home/view/widgets/product_widget.dart';
import 'package:kcds/src/base/customer/home/view_model/home_vm.dart';
import 'package:kcds/src/widgets/dunkin_page.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../location/view_model/location_viewmodal.dart';
import '../../../../widgets/subway_page.dart';

class HomeView extends StatefulWidget {
  static String route = '/HomeView';
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  TextEditingController searchTC = TextEditingController();

  late RoomProvider _roomProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _roomProvider = Provider.of<RoomProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeVM>(builder: (context, model, _) {
      return SingleChildScrollView(
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
                      return CategoryWidget(
                        category: category,
                      );
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
              GestureDetector(
                onTap: () {
                  _roomProvider.selectedStore = 0;
                  Get.toNamed(DunkinView.route);
                },
                child: ProductWidget(
                  name: "Dunkin Donuts",
                  image: R.images.cup,
                  category: 'Coffee',
                ),
              ),
              R.sizedBox.sizedBox1h(),
              GestureDetector(
                onTap: () {
                  _roomProvider.selectedStore = 1;
                  Get.toNamed(SubwayView.route);
                },
                child: ProductWidget(
                  name: 'Subway',
                  image: R.images.subway,
                  category: "Food",
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
