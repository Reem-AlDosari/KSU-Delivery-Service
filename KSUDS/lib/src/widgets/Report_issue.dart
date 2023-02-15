import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:get/get.dart';
import 'package:kcds/resources/resources.dart';
import 'package:kcds/src/auth/view_model/auth_vm.dart';
import 'package:kcds/src/widgets/heading.dart';
import 'package:kcds/src/widgets/my_button.dart';
import 'package:kcds/utils/show_message.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../utils/validator.dart';

class ReportAnIssue extends StatefulWidget {
  static String route = '/ReportAnIssue';
  const ReportAnIssue({Key? key}) : super(key: key);

  @override
  State<ReportAnIssue> createState() => _ReportAnIssueState();
}

class _ReportAnIssueState extends State<ReportAnIssue> {
  TextEditingController titleTC = TextEditingController();
  TextEditingController descriptionTC = TextEditingController();

  FocusNode emailFn = FocusNode();
  var authProvider = Provider.of<AuthVM>(Get.context!);
  TextEditingController confirmPassTC = TextEditingController();
  TextEditingController passwordTC = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          key: formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Heading(
                      title: 'Title:',
                    ),
                    TextFormField(
                      validator: (value) =>
                          FieldValidator.checkEmpty(titleTC.text),
                      decoration:
                          R.decorations.appFieldDecoration(null, " ", ' '),
                      controller: titleTC,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      style: R.textStyles.textFormFieldStyle(),
                    ),
                    const Heading(
                      title: 'Description:',
                    ),
                    TextFormField(
                      decoration:
                          R.decorations.appFieldDecoration(null, "", ' '),
                      controller: descriptionTC,
                      keyboardType: TextInputType.multiline,
                      maxLines: 10,
                      textInputAction: TextInputAction.done,
                      style: R.textStyles.textFormFieldStyle(),
                      validator: (value) =>
                          FieldValidator.checkEmpty(descriptionTC.text),
                    ),
                    R.sizedBox.sizedBox2h(),
                    MyButton(
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          sendEmail();
                        }
                      },
                      buttonText: "Send ",
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        alignment: Alignment.bottomRight,
        width: Get.width * .3,
        height: 10.h,
        child: Image.asset(R.images.layer),
      ),
    );
  }

  Future<void> sendEmail() async {
    final Email email = Email(
      body: descriptionTC.text,
      subject: titleTC.text,
      recipients: ['KSUDS.contact@gmail.com'],
      // cc: ['aa@gmail.com'],
      // bcc: ['bcc@example.com'],
      // attachmentPaths: ['/path/to/attachment.zip'],
      isHTML: false,
    );

    await FlutterEmailSender.send(email);
    Get.back();
    ShowMessage.toast('issue submitted ');
  }
}
