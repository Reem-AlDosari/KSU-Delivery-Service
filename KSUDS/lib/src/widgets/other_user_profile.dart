import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:kcds/constants/enums.dart';
import 'package:kcds/resources/resources.dart';
import 'package:kcds/src/widgets/circle_avatar.dart';
import 'package:kcds/src/widgets/heading.dart';
import 'package:kcds/utils/fb_collections.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../utils/validator.dart';
import '../auth/view_model/auth_vm.dart';
import '../base/customer/order/model/order.dart';

class OtherUserProfile extends StatefulWidget {
  final String email;
  const OtherUserProfile({Key? key, required this.email}) : super(key: key);
  @override
  State<OtherUserProfile> createState() => _OtherUserProfileState();
}

class _OtherUserProfileState extends State<OtherUserProfile> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  //var currentUserReference;

//----------------------------Start
  var CurrentImage;
  String? CurrentImageURL;
  bool _loadingButton = false;
  TextEditingController nameTC = TextEditingController();
  TextEditingController emailTC = TextEditingController();
  TextEditingController numberTC = TextEditingController();
  // final scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  Future<void> initialize() async {
    //<--------- get the db reference for this user
    var currentUserReference = FBCollections.users.doc(widget.email);
//await currentUserReference.snapshots().listen((event)
    await currentUserReference.snapshots().listen((event) {
      setState(() {
        nameTC = new TextEditingController(text: event.get("fullName"));
        emailTC = new TextEditingController(text: event.get("email"));
        numberTC = new TextEditingController(text: event.get("phoneNo"));
        if (event.get("Image") != null) {
          CurrentImageURL = event.get("Image");
        } else if (event.get("Image") == null) {
          CurrentImageURL = 'https://i.postimg.cc/XXM98yBD/user-avatar.png';
        }

        //  return;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthVM>(builder: (context, model, _) {
      return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: R.colors.theme,
            centerTitle: true,
            leading: Container(
              child: IconButton(
                  alignment: Alignment.topCenter,
                  iconSize: 40,
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context, true);
                  }),
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
            child: Form(
              key: _key,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: Get.width * .9999,
                      //  height: 40.h,
                      child: Image.asset(R.images.blue),
                    ),
                  ),
                  Center(
                    child: StreamBuilder(
                      stream: FBCollections.ratings
                          .where('rate_to', isEqualTo: model.appUser?.email)
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return SizedBox();
                        } else if (snapshot.data!.docs.isEmpty) {
                          return Center(
                            child: Text("0"),
                          );
                        } else {
                          double rating = 0.0;
                          snapshot.data?.docs.forEach((element) {
                            rating =
                                rating + double.parse("${element['rating']}");
                          });
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RatingBar.builder(
                                ignoreGestures: true,
                                initialRating:
                                    rating / (snapshot.data?.docs.length)!,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: 1.0),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  size: 5,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {},
                              ),
                              Text(
                                "(${snapshot.data?.docs.length})",
                                style: TextStyle(color: R.colors.white),
                              )
                            ],
                          );
                        }
                      },
                    ),
                  ),
                  Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(10, 80, 10, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            //  height: 40.h,
                            child: Column(
                              children: [
                                Icon(
                                  Icons.attach_money,
                                  color: R.colors.white,
                                ),
                                Text(
                                  model.appUser?.role == UserType.carrier.index
                                      ? "Total Earning"
                                      : "Reward Points",
                                  style: R.textStyles.poppinsTitle1().copyWith(
                                      color: R.colors.white, fontSize: 11.sp),
                                ),
                                model.appUser?.role == UserType.carrier.index
                                    ? StreamBuilder(
                                        stream: model.appUser?.role ==
                                                UserType.carrier.index
                                            ? FBCollections.orders
                                                .where('carrierId',
                                                    isEqualTo:
                                                        model.appUser?.email)
                                                .where('status',
                                                    isEqualTo: OrderStatus
                                                        .delivered.index)
                                                .snapshots()
                                            : FBCollections.orders
                                                .where('customerId',
                                                    isEqualTo:
                                                        model.appUser?.email)
                                                .where('status',
                                                    isEqualTo: OrderStatus
                                                        .delivered.index)
                                                .snapshots(),
                                        builder: (context,
                                            AsyncSnapshot<QuerySnapshot>
                                                snapshot) {
                                          if (!snapshot.hasData) {
                                            return SizedBox();
                                          } else if (snapshot
                                              .data!.docs.isEmpty) {
                                            return Center(
                                              child: Text("0"),
                                            );
                                          } else {
                                            double amount = 0.0;
                                            snapshot.data?.docs
                                                .forEach((element) {
                                              Order order = Order.fromJson(
                                                  element.data()
                                                      as Map<String, dynamic>);
                                              amount = amount +
                                                  double.parse(
                                                      order.totalPrice!);
                                            });
                                            return Text("$amount SR",
                                                style: R.textStyles
                                                    .poppinsTitle1()
                                                    .copyWith(
                                                        color: R.colors.white));
                                          }
                                        },
                                      )
                                    : StreamBuilder(
                                        stream: FBCollections.wallet
                                            .where('customerId',
                                                isEqualTo: model.appUser?.email)
                                            .snapshots(),
                                        builder: (context,
                                            AsyncSnapshot<QuerySnapshot>
                                                snapshot) {
                                          if (!snapshot.hasData) {
                                            return SizedBox();
                                          } else if (snapshot
                                              .data!.docs.isEmpty) {
                                            return Center(
                                              child: Text(
                                                "0",
                                                style: TextStyle(
                                                    color: R.colors.white),
                                              ),
                                            );
                                          } else {
                                            double amount = 0.0;
                                            snapshot.data?.docs
                                                .forEach((element) {
                                              if (element['type'] ==
                                                  TransactionType.add) {
                                                amount = amount +
                                                    double.parse(
                                                        "${element['amount']}");
                                              } else {
                                                amount = amount -
                                                    double.parse(
                                                        "${element['amount']}");
                                              }
                                            });
                                            return Text("$amount SR",
                                                style: R.textStyles
                                                    .poppinsTitle1()
                                                    .copyWith(
                                                        color: R.colors.white));
                                          }
                                        },
                                      ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              // color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(1.0, 3.0),
                                    blurRadius: 7,
                                    color: Color.fromARGB(255, 131, 131, 131),
                                    spreadRadius: 2)
                              ],
                            ),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: CircleAvatar(
                                radius: 75,
                                backgroundColor: Colors.white,
                                // height: 20.h,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: AppCircleAvatar(
                                    networkImage: true,
                                    image: CurrentImageURL ?? "",
                                    radius: 70,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            //  height: 40.h,
                            child: Column(
                              children: [
                                Icon(
                                  Icons.delivery_dining,
                                  color: R.colors.white,
                                ),
                                Text(
                                  "Total Orders",
                                  style: R.textStyles.poppinsTitle1().copyWith(
                                      color: R.colors.white, fontSize: 11.sp),
                                ),
                                StreamBuilder(
                                  stream: model.appUser?.role ==
                                          UserType.carrier.index
                                      ? FBCollections.orders
                                          .where('carrierId',
                                              isEqualTo: model.appUser?.email)
                                          .where('status',
                                              isEqualTo:
                                                  OrderStatus.delivered.index)
                                          .snapshots()
                                      : FBCollections.orders
                                          .where('customerId',
                                              isEqualTo: model.appUser?.email)
                                          .where('status',
                                              isEqualTo:
                                                  OrderStatus.delivered.index)
                                          .snapshots(),
                                  builder: (context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (!snapshot.hasData) {
                                      return SizedBox();
                                    } else if (snapshot.data!.docs.isEmpty) {
                                      return Center(
                                        child: Text("0"),
                                      );
                                    } else {
                                      return Text(
                                        "${snapshot.data?.docs.length}",
                                        style: R.textStyles
                                            .poppinsTitle1()
                                            .copyWith(
                                              color: R.colors.white,
                                            ),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                  Container(
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(100, 190, 0, 0),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: RawMaterialButton(
                            fillColor: const Color(0xff78BBD5),
                            child: Icon(
                              Icons.add_photo_alternate_rounded,
                              color: Colors.white,
                            ),
                            elevation: 8,
                            onPressed: () {},
                            padding: EdgeInsets.all(0),
                            shape: CircleBorder(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(13, 240, 0, 0),
                    child: Row(
                      children: [
                        const Heading(
                          title: 'Full name',
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(13, 280, 0, 0),
                    child: SizedBox(
                      width: 370,
                      child: TextFormField(
                        decoration: R.decorations.appFieldDecoration(
                            null, "Full name", 'John green'),
                        controller: nameTC,
                        validator: (value) =>
                            FieldValidator.validateName(nameTC.text),
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        style: R.textStyles.textFormFieldStyle(),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(13, 350, 0, 0),
                    child: Row(
                      children: [
                        const Heading(
                          title: 'Email',
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(13, 380, 0, 0),
                    child: SizedBox(
                      width: 370,
                      child: TextFormField(
                        enabled: false,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        controller: emailTC,
                        validator: (value) =>
                            FieldValidator.validateEmail(emailTC.text),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        style: R.textStyles.textFormFieldStyle(),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(13, 440, 0, 0),
                    child: Row(
                      children: [
                        const Heading(
                          title: 'Phone number',
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(13, 475, 0, 0),
                    child: SizedBox(
                      width: 370,
                      child: TextFormField(
                        decoration: R.decorations.appFieldDecoration(
                            null, "Full name", '(966) 555-0113'),
                        controller: numberTC,
                        validator: (value) =>
                            FieldValidator.validatePhoneNumber(numberTC.text),
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        style: R.textStyles.textFormFieldStyle(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ));
    });
  }
}
