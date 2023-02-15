// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_rating_stars/flutter_rating_stars.dart';
// import 'package:get/get.dart';
// import 'package:kcds/resources/resources.dart';
// import 'package:kcds/src/base/view/base_view.dart';
// import 'package:kcds/src/widgets/my_button.dart';
// import 'package:rating_dialog/rating_dialog.dart';
// import 'package:sizer/sizer.dart';
//
// class rating extends StatefulWidget {
//   static String route = '/AuthView';
//   const rating({Key? key}) : super(key: key);
//
//   @override
//   State<rating> createState() => _ratingState();
// }
//
// class _ratingState extends State<rating> {
//   bool _loadingButton = false;
//   double value = 3.5;
//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Form(
//           key: formKey,
//           autovalidateMode: AutovalidateMode.disabled,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: Container(
//                   width: Get.width * .4,
//                   height: 20.h,
//                   child: Image.asset(R.images.layer2),
//                 ),
//               ),
//
//               /*   Align(
//                 alignment: Alignment.center,
//                 child: Container(
//                   width: Get.width * .4,
//                   height: 20.h,
//                   //edit this one
//                   child: Image.asset(R.images.layer4),
//                 ),
//               ),*/
//               /*   Padding(
//                 padding: EdgeInsetsDirectional.fromSTEB(15, 15, 0, 0),
//                 child: FFButtonWidget(
//                   onPressed: () {
//                     //print('Button pressed ...');
//                     show();
//                   },
//                   text: 'Rate us',
//                   options: FFButtonOptions(
//                     width: 340,
//                     height: 60,
//                     color: Color(0xFF0D67B5),
//                     elevation: 2,
//                     borderSide: BorderSide(
//                       color: Colors.transparent,
//                       width: 1,
//                     ),
//                     borderRadius: 8,
//                   ),
//                   loading: _loadingButton,
//                 ),
//               ),*/
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 5.w),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding:
//                           const EdgeInsetsDirectional.fromSTEB(15, 15, 0, 0),
//                       child: Text(
//                         "How was your order?",
//                         style:
//                             R.textStyles.heading4().copyWith(fontSize: 36.sp),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                     Padding(
//                       padding:
//                           const EdgeInsetsDirectional.fromSTEB(20, 30, 0, 0),
//                       child: Container(
//                         // width: 200.0,
//                         height: 160.0,
//                         decoration: new BoxDecoration(
//                           color: Color(0xFF78bbd5),
//                           shape: BoxShape.circle,
//                         ),
//                         child: Padding(
//                           padding:
//                               const EdgeInsetsDirectional.fromSTEB(0, 0, 60, 0),
//                           child: RatingStars(
//                             value: value,
//                             onValueChanged: (v) {
//                               //
//                               setState(() {
//                                 value = v;
//                               });
//                             },
//                             starBuilder: (index, color) => Icon(
//                               Icons.star,
//                               size: 45.0,
//                               color: color,
//                             ),
//                             starCount: 5,
//                             starSize: 40,
//                             valueLabelColor: const Color(0xff9b9b9b),
//                             valueLabelTextStyle: const TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.w400,
//                                 fontStyle: FontStyle.normal,
//                                 fontSize: 12.0),
//                             valueLabelRadius: 10,
//                             maxValue: 5,
//                             starSpacing: 2,
//                             maxValueVisibility: true,
//                             valueLabelVisibility: true,
//                             animationDuration: Duration(milliseconds: 1000),
//                             valueLabelPadding: const EdgeInsets.symmetric(
//                                 vertical: 1, horizontal: 8),
//                             valueLabelMargin: const EdgeInsets.only(right: 8),
//                             starOffColor: const Color(0xffe7e8ea),
//                             starColor: Color.fromARGB(255, 255, 170, 59),
//                           ),
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsetsDirectional.fromSTEB(18, 60, 0, 0),
//                       child: MyButton(
//                         onTap: () {
//                           if (formKey.currentState!.validate()) {
//                             Get.toNamed(BaseView.route);
//                           }
//                         },
//                         buttonText: "Submit",
//                       ),
//                     )
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: Container(
//         alignment: Alignment.bottomRight,
//         width: Get.width * .3,
//         height: 10.h,
//         child: Image.asset(R.images.layer),
//       ),
//     );
//   }
//
//   void show() {
//     showDialog(
//         context: context,
//         barrierDismissible: true,
//         builder: (context) {
//           return RatingDialog(
//               title: Text(""),
//               message: Text("How was your order?"),
//               image: Icon(
//                 Icons.star,
//                 size: 100,
//                 color: Color.fromARGB(255, 255, 251, 0),
//               ),
//               submitButtonText: "Submit",
//               onSubmitted: (response) async {
//                 await showDialog(
//                   context: context,
//                   builder: (alertDialogContext) {
//                     return AlertDialog(
//                       title: Text('Thankyou for your rating'),
//                       // content: Text('adding trip is succsseful'),
//                       actions: [
//                         TextButton(
//                           onPressed: () => Navigator.pop(alertDialogContext),
//                           child: Text('Ok'),
//                         ),
//                       ],
//                     );
//                   },
//                 );
//               });
//         });
//   }
// }
