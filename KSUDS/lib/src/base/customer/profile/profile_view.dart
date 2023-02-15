import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kcds/constants/enums.dart';
import 'package:kcds/resources/resources.dart';
import 'package:kcds/utils/fb_collections.dart';
import 'package:path/path.dart' as Path;
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../utils/validator.dart';
import '../../../auth/view_model/auth_vm.dart';
import '../../../widgets/circle_avatar.dart';
import '../../../widgets/heading.dart';
import '../../../widgets/my_button.dart';
import '../order/model/order.dart';

class ProfileView extends StatefulWidget {
  //static String route = '/profileView';
  const ProfileView({Key? key}) : super(key: key);
  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  //var currentUserReference;

  //<--------- Async Method to get the current logged user's email
  Future<String?> getCurrentUserEmail() async {
    String? user = _firebaseAuth.currentUser?.email;
    return user;
  }

  Future<void> _editrecord() async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
    Future<String?> getCurrentUserEmail() async {
      String? user = _firebaseAuth.currentUser?.email;
      return user;
    }

    String? currentUserEmail = await getCurrentUserEmail();
    var currentUserReference = FBCollections.users.doc(currentUserEmail);
    currentUserReference.update({
      'fullName': nameTC.text,
      'email': emailTC.text,
      'phoneNo': numberTC.text,
      "Image": imageURL,
    });

    setState(() => _loadingButton = true);
    try {
      await showDialog(
        context: context,
        builder: (alertDialogContext) {
          return AlertDialog(
            title: Text('your profile is updated successfully'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(alertDialogContext),
                child: Text('Ok'),
              ),
            ],
          );
        },
      );
    } finally {
      setState(() => _loadingButton = false);
    }
  }

// Image Picker

  File? selected_image; // Used only if you need a single picture

  Future getImage(bool gallery) async {
    ImagePicker picker = ImagePicker();
    PickedFile? pickedFile;
    // Let user select photo from gallery
    if (gallery) {
      pickedFile = await picker.getImage(
        source: ImageSource.gallery,
      );
    }
    // Otherwise open camera to get new photo
    else {
      pickedFile = await picker.getImage(
        source: ImageSource.camera,
      );
    }

    setState(() {
      if (pickedFile != null) {
        //  _images.add(File(pickedFile.path));
        selected_image =
            File(pickedFile.path); // Use if you only need a single picture
      }
    });
  }

  DocumentReference usersRef =
      FirebaseFirestore.instance.collection('users').doc();

  Future<String?> uploadFile(File _image) async {
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('users/${Path.basename(_image.path)}');
    await storageReference.putFile(_image);

    print('File Uploaded');
    String? returnURL;
    await storageReference.getDownloadURL().then((fileURL) {
      returnURL = fileURL;
    });
    return returnURL;
  }

  String imageURL = '';

  Future<void> saveImages(File _image, DocumentReference ref) async {
    if (_image != null) {
      imageURL = (await uploadFile(_image))!;
    } else {
      imageURL = "";
    }
  }

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
    //<--------- get current logged user's email
    String? currentUserEmail = await getCurrentUserEmail();

    //<--------- get the db reference for this user
    var currentUserReference = FBCollections.users.doc(currentUserEmail);
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
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return SizedBox();
                    } else if (snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Text("Not rated yet"),
                      );
                    } else {
                      double rating = 0.0;
                      snapshot.data?.docs.forEach((element) {
                        rating = rating + double.parse("${element['rating']}");
                        print("total $rating i ${element['rating']}");
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
                            itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
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
                  padding: const EdgeInsetsDirectional.fromSTEB(10, 80, 10, 0),
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
                                        double amount = 0.0;
                                        snapshot.data?.docs.forEach((element) {
                                          Order order = Order.fromJson(element
                                              .data() as Map<String, dynamic>);
                                          amount = amount +
                                              double.parse(order.totalPrice!);
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
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (!snapshot.hasData) {
                                        return SizedBox();
                                      } else if (snapshot.data!.docs.isEmpty) {
                                        return Center(
                                          child: Text(
                                            "0",
                                            style: TextStyle(
                                                color: R.colors.white),
                                          ),
                                        );
                                      } else {
                                        double amount = 0.0;
                                        snapshot.data?.docs.forEach((element) {
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
                              child: selected_image != null
                                  ? CircleAvatar(
                                      radius: 70,
                                      backgroundImage:
                                          FileImage(selected_image!),

                                      //    NetworkImage(CurrentImageURL),
                                    )
                                  : AppCircleAvatar(
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
                              stream:
                                  model.appUser?.role == UserType.carrier.index
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
                                    child: Text(
                                      "0",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  );
                                } else {
                                  return Text(
                                    "${snapshot.data?.docs.length}",
                                    style:
                                        R.textStyles.poppinsTitle1().copyWith(
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
                  padding: const EdgeInsetsDirectional.fromSTEB(100, 190, 0, 0),
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
                        onPressed: () {
                          getImage(true);
                        },
                        padding: EdgeInsets.all(0),
                        shape: CircleBorder(),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(13, 240, 0, 0),
                child: Row(
                  children: [
                    const Heading(
                      title: 'Full name',
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(13, 280, 0, 0),
                child: SizedBox(
                  width: 370,
                  child: TextFormField(
                    decoration: R.decorations
                        .appFieldDecoration(null, "Full name", 'John green'),
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
                padding: const EdgeInsetsDirectional.fromSTEB(13, 350, 0, 0),
                child: Row(
                  children: [
                    const Heading(
                      title: 'Email',
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(13, 380, 0, 0),
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
                padding: const EdgeInsetsDirectional.fromSTEB(13, 440, 0, 0),
                child: Row(
                  children: [
                    const Heading(
                      title: 'Phone number',
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(13, 475, 0, 0),
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
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(50, 520, 0, 0),
                child: SizedBox(
                  width: 290,
                  // height: 9,
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: MyButton(
                      onTap: () async {
                        if (_key.currentState!.validate()) {
                          await saveImages(selected_image!, usersRef);
                          await _editrecord();
                        }

                        ////--------------
                      },
                      buttonText: "Save",
                    ),
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
