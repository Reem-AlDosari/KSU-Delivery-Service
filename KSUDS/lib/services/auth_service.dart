import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:kcds/utils/show_message.dart';

abstract class BaseAuth {
  Future<String> signInWithEmailPassword(String email, String password);
  Future<String> createUserWithEmailPassword(String email, String password);
  Future<User?> getCurrentUser();
  Future<void> signOut();
  Future<void> sendResetPassEmail(String email);
  Future<void> getLocations();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<String> createUserWithEmailPassword(
      String email, String password) async {
    var val;
    try {
      var user = (await _firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;
      try {
        await user!.sendEmailVerification();
        return user.uid;
      } catch (e) {
        ShowMessage.inSnackBar(
          "Error",
          "An error occurred while trying to send email  verification",
        );
        print("An error occurred while trying to send email  verification");
        print(e);
      }
    } catch (e) {
      print(" Creating user Error \n\n\n $e");
      if (e.toString().contains("email-already-in-use")) {
        return "0";
      } else {
        Fluttertoast.showToast(msg: "${e.toString()}");
        return "1";
      }
    }
    return val;
  }

  @override
  Future<User?> getCurrentUser() async {
    var user = _firebaseAuth.currentUser;
    return user;
  }

  @override
  Future<String> signInWithEmailPassword(String email, String password) async {
    print("sign in method");
    try {
      var user = (await _firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;
      if (user!.emailVerified) {
        return user.uid;
      } else {
        return "1";
      }
    } catch (e) {
      String error = e.toString();
      print("sign in error $e");
      if (error.contains("too-many-requests")) {
        Get.snackbar("Try Again Later",
            "This Device is blocked for some time due to unusual activity. ",
            colorText: Colors.white,
            backgroundColor: Colors.red,
            margin: EdgeInsets.symmetric(
                vertical: Get.height * 0.02, horizontal: Get.width * 0.03));
      } else if (error.contains("wrong-password")) {
        Get.snackbar("Wrong Password", "ENTER CORRECT PASSWORD",
            colorText: Colors.white,
            backgroundColor: Colors.red,
            margin: EdgeInsets.symmetric(
                vertical: Get.height * 0.02, horizontal: Get.width * 0.03));
      } else if (error.contains("user-not-found")) {
        Get.snackbar("Wrong Email", "No User found against this email.",
            colorText: Colors.white,
            backgroundColor: Colors.red,
            margin: EdgeInsets.symmetric(
                vertical: Get.height * 0.02, horizontal: Get.width * 0.03));
      }
      return "0";
    }
  }

  Future<String> signInWithPhoneNumber(
    PhoneAuthCredential authCredential,
  ) async {
    try {
      var user =
          (await _firebaseAuth.signInWithCredential(authCredential)).user;
      return user!.uid;
    } catch (e) {
      String error = e.toString();
      print("sign in error $e");
      if (error.contains("too-many-requests")) {
        Get.snackbar("Try Again Later",
            "This Device is blocked for some time due to unusual activity. ",
            colorText: Colors.white,
            backgroundColor: Colors.red,
            margin: EdgeInsets.symmetric(
                vertical: Get.height * 0.02, horizontal: Get.width * 0.03));
      }
      if (error.contains("session-expired")) {
        Get.snackbar("OTP Expired", "Please resend code ,session is expired",
            colorText: Colors.white,
            backgroundColor: Colors.red,
            margin: EdgeInsets.symmetric(
                vertical: Get.height * 0.02, horizontal: Get.width * 0.03));
      }
      if (error.contains("invalid-verification-code")) {
        Get.snackbar("Invalid OTP", "The OTP you entered is invalid.",
            colorText: Colors.white,
            backgroundColor: Colors.red,
            margin: EdgeInsets.symmetric(
                vertical: Get.height * 0.02, horizontal: Get.width * 0.03));
      }
      return "0";
    }
  }

  Future<String> signUpWithPhoneNumber(
    PhoneAuthCredential authCredential,
  ) async {
    try {
      var user =
          (await _firebaseAuth.signInWithCredential(authCredential)).user;
      return user!.uid;
    } catch (e) {
      String error = e.toString();
      print("sign up error $e");
      if (error.contains("too-many-requests")) {
        Get.snackbar("Try Again Later",
            "This Device is blocked for some time due to unusual activity. ",
            colorText: Colors.white,
            backgroundColor: Colors.red,
            margin: EdgeInsets.symmetric(
                vertical: Get.height * 0.02, horizontal: Get.width * 0.03));
      }
      if (error.contains("session-expired")) {
        Get.snackbar("OTP Expired", "Please try again ,session is expired",
            colorText: Colors.white,
            backgroundColor: Colors.red,
            margin: EdgeInsets.symmetric(
                vertical: Get.height * 0.02, horizontal: Get.width * 0.03));
      }
      if (error.contains("invalid-verification-code")) {
        Get.snackbar("Invalid OTP", "The OTP you entered is invalid.",
            colorText: Colors.white,
            backgroundColor: Colors.red,
            margin: EdgeInsets.symmetric(
                vertical: Get.height * 0.02, horizontal: Get.width * 0.03));
      }
      return "0";
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<void> sendResetPassEmail(String email) async {
    FirebaseAuth.instance.sendPasswordResetEmail(email: '$email').then((value) {
      print("success");
      ShowMessage.inSnackBar(
        'success',
        "Password reset Link sent Successfully,\n Please check your mail box",
      );
    }).catchError((e) {
      String error = e.toString();
      print(error);

      if (error.contains('USER_NOT_FOUND')) {
        ShowMessage.toast(
          'Email not registered',
        );
      } else {
        print(e.toString());
        ShowMessage.toast(
          e.toString(),
        );
      }
    });
  }

  @override
  Future<void> getLocations() {
    // TODO: implement getLocations
    throw UnimplementedError();
  }
}
