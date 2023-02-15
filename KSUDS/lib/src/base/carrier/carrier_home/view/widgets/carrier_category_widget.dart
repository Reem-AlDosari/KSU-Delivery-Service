import 'package:flutter/material.dart';
import 'package:kcds/resources/resources.dart';
import 'package:kcds/src/base/customer/home/model/category.dart';
import 'package:sizer/sizer.dart';

class CarrierCategoryWidget extends StatelessWidget {
  Category category;
  CarrierCategoryWidget({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
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
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: R.colors.black),
            )
          ],
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
    );
  }
}
