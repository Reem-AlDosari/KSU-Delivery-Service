import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kcds/src/chat/view_model/chat_vm.dart';
import 'package:kcds/utils/fb_collections.dart';
import 'package:kcds/utils/show_message.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:path/path.dart' as Path;
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../resources/fonts.dart';
import '../../../resources/resources.dart';
import '../../../utils/loader.dart';
import '../../../utils/validator.dart';
import '../../base/customer/order/model/message.dart';
import '../../base/customer/order/model/order.dart';
import '../../widgets/my_button.dart';

class ExportBill extends StatefulWidget {
  final Order order;
  final String name;

  const ExportBill({Key? key, required this.order, required this.name})
      : super(key: key);

  @override
  _ExportBillState createState() => _ExportBillState();
}

class _ExportBillState extends State<ExportBill> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;
  TextEditingController priceTC = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      progressIndicator: MyLoader(),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 9.h,
          elevation: 0.7,
          backgroundColor: R.colors.theme,
          title: Text(
            "KSUDS",
            style: MyTextStyle().poppinsTitle1().copyWith(fontSize: 24),
          ),
          centerTitle: true,
          leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: R.colors.white,
                  boxShadow: [BoxShadow(color: R.colors.grey, blurRadius: 10)]),
              width: 2.h,
              height: 2.h,
              margin: EdgeInsets.only(left: 4.w, top: 1.5.h, bottom: 1.5.h),
              child: Icon(
                Icons.arrow_back_ios_rounded,
                color: R.colors.darkGrey,
              ),
            ),
          ),
          actions: [
            Container(
              padding: EdgeInsets.only(top: 2.h, bottom: 2.h, right: 2.w),
              child: Image.asset(
                R.images.logo,
                height: 20.sp,
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: ListView(
              //  mainAxisAlignment: MainAxisAlignment.start,
              //// crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "Export Bill",
                    style: MyTextStyle().heading1(),
                  ),
                ),
                R.sizedBox.sizedBox2h(),
                Text(
                  "Customer:${widget.name}",
                  style: MyTextStyle().poppinsTitle1(),
                ),
                R.sizedBox.sizedBox2h(),
                Text(
                  "Delivery Price:${widget.order.deliveryPrice} SR",
                  style: MyTextStyle().poppinsTitle1(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      "Order Price:",
                      style: R.textStyles
                          .poppinsTitle1()
                          .copyWith(color: const Color(0xff667C8A)),
                    ),
                  ),
                ),
                TextFormField(
                  decoration:
                      R.decorations.appFieldDecoration(null, "price", 'Price'),
                  controller: priceTC,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  style: R.textStyles.textFormFieldStyle(),
                  validator: (value) => FieldValidator.checkEmpty(priceTC.text),
                ),
                R.sizedBox.sizedBox3h(),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 1.h),
                  child: MyButton(
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          widget.order.totalPrice =
                              (double.parse(widget.order.deliveryPrice!) +
                                      double.parse(priceTC.text))
                                  .toString();
                          widget.order.price = priceTC.text;
                          setState(() {});
                        }
                      },
                      buttonText: "Calculate"),
                ),
                R.sizedBox.sizedBox3h(),
                Center(
                  child: Text(
                    "Total Price:${widget.order.totalPrice ?? ""} SR",
                    style: MyTextStyle().poppinsTitle1(),
                  ),
                ),
                R.sizedBox.sizedBox3h(),
                Align(
                  alignment: Alignment.topCenter,
                  child: InkWell(
                    onTap: () {
                      getImage(true);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: selected_image != null
                          ? Image.file(
                              selected_image!,
                              fit: BoxFit.cover,
                              height: 250,
                            )
                          : Image.asset(
                              R.images.upload,
                              height: 150,
                            ),
                    ),
                  ),
                ),
                R.sizedBox.sizedBox3h(),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 1.h),
                  child: MyButton(
                      onTap: () {
                        if (formKey.currentState!.validate() &&
                            widget.order.totalPrice != null) {
                          if (selected_image != null) {
                            exportBill(imageURL);
                          } else {
                            ShowMessage.toast("Please add a bill receipt");
                          }
                        } else {
                          ShowMessage.toast("Please calculate price");
                        }
                      },
                      buttonText: "Export Bill"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
        .child('orders/${Path.basename(_image.path)}');
    await storageReference.putFile(_image);

    print('File Uploaded');
    String? returnURL;
    await storageReference.getDownloadURL().then((fileURL) {
      returnURL = fileURL;
    });
    return returnURL;
  }

  String imageURL = '';

  Future<void> uploadImage(File _image, DocumentReference ref) async {
    if (_image != null) {
      imageURL = (await uploadFile(_image))!;
      MessageModel msg = MessageModel(
        type: 1,
        message: imageURL,
        receiver: widget.order.customerId,
        sender: widget.order.carrierId,
        roomId: widget.order.id,
        createdAt: Timestamp.now(),
        isSeen: false,
      );

      Provider.of<ChatVM>(context, listen: false).sendMessage(
        msg,
      );
    } else {
      imageURL = "";
    }
  }

  Future<void> exportBill(String image) async {
    setState(() {
      isLoading = true;
    });
    await uploadImage(selected_image!, usersRef);
    await FBCollections.orders.doc(widget.order.id).update({
      'payment_status': 1,
      'price': priceTC.text,
      'totalPrice': widget.order.totalPrice,
    });
    widget.order.paymentStatus = 1;
    setState(() {
      isLoading = false;
    });
    Get.back();
  }
}
