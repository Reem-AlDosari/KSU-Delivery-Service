import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kcds/resources/resources.dart';
import 'package:sizer/sizer.dart';

class ProductWidget extends StatelessWidget {
  final String? image;
  final String name;
  final String? category;
  const ProductWidget({Key? key, this.image, this.category, required this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18), color: Color(0xffE0E8EB)),
      child: Card(
        child: Container(
          height: 28.w,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: Get.width * .03,
              ),
              Image.asset(
                image!,
                height: 60.sp,
              ),
              SizedBox(
                width: Get.width * .1,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    name,
                    style: R.textStyles.poppinsTitle1().copyWith(
                          fontSize: 12.sp,
                        ),
                  ),
                  SizedBox(
                    height: .2.h,
                  ),
                  Text(
                    category!,
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
    );
  }
}
