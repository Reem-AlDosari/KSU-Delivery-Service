import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:sizer/sizer.dart';

import '../../../../../../resources/resources.dart';

class AcceptRejectSheet extends StatefulWidget {
  final Function onTap;
  final bool accept;
  final bool cancel;
  const AcceptRejectSheet(
      {Key? key, this.accept = true, this.cancel = false, required this.onTap})
      : super(key: key);

  @override
  _AcceptRejectSheetState createState() => _AcceptRejectSheetState();
}

class _AcceptRejectSheetState extends State<AcceptRejectSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: Get.width * .07),
        decoration: BoxDecoration(
          color: R.colors.white,
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: .7.h,
            ),
            const Divider(
              thickness: 4.5,
              indent: 100,
              endIndent: 110,
            ),
            SizedBox(
              height: 4.h,
            ),
            Image.asset(
              R.images.question,
              scale: 3,
            ),
            SizedBox(
              height: 3.h,
            ),
            Text(
              "Are you sure?",
              style: R.textStyles
                  .robotoMedium()
                  .copyWith(color: R.colors.darkGrey, fontSize: 14.sp),
            ),
            SizedBox(
              height: 2.h,
            ),
            Text(
              widget.accept
                  ? "You want to accept this offer."
                  : widget.cancel
                      ? "You want to cancel this order."
                      : "You want to reject this offer.",
              style: R.textStyles
                  .robotoRegular()
                  .copyWith(color: R.colors.darkGrey, fontSize: 12.sp),
            ),
            SizedBox(
              height: 4.h,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      child: Text(
                        'No',
                        style: R.textStyles
                            .robotoMedium()
                            .copyWith(fontSize: 13.sp, color: R.colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        primary: R.colors.grey,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ),
                SizedBox(
                  width: 2.w,
                ),
                Expanded(
                  child: ElevatedButton(
                      child: Text(
                        'Yes',
                        style: R.textStyles
                            .robotoMedium()
                            .copyWith(fontSize: 13.sp, color: R.colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        primary: R.colors.theme,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                      ),
                      onPressed: () async {
                        widget.onTap();
                      }),
                ),
              ],
            ),
            SizedBox(
              height: 2.h,
            ),
          ],
        ));
  }
}
