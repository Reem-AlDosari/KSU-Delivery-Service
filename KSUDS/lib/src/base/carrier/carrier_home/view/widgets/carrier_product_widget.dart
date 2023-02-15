import 'package:flutter/material.dart';
import 'package:kcds/resources/resources.dart';
import 'package:sizer/sizer.dart';

class CarrierProductWidget extends StatelessWidget {
  const CarrierProductWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: const Color(0xffE0E8EB)),
      child: Card(
        child: Container(
          height: 28.w,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                R.images.subway,
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
                    'Time:10-20 min',
                    style: R.textStyles.poppinsTitle1().copyWith(
                        fontSize: 12.sp, color: const Color(0xff667C8A)),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    R.images.pin,
                    height: 25.sp,
                  ),
                  R.sizedBox.sizedBox1h(),
                  Text(
                    '0.7km',
                    style: R.textStyles.poppinsTitle1(),
                  ),
                ],
              )
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
