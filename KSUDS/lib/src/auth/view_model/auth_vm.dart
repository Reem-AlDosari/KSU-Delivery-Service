import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kcds/constants/enums.dart';
import 'package:kcds/services/auth_service.dart';
import 'package:kcds/src/Landing_pages/landing_page.dart';
import 'package:kcds/src/auth/model/user_data.dart';
import 'package:kcds/src/auth/view/auth_view.dart';
import 'package:kcds/src/base/carrier/carrier_base_view.dart';
import 'package:kcds/src/widgets/registration_successful.dart';
import 'package:kcds/utils/fb_collections.dart';
import 'package:kcds/utils/show_message.dart';
import 'package:location/location.dart';

import '../../../utils/app_utils.dart';
import '../../base/customer/base_view.dart';

class AuthVM extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  UserData? appUser = UserData();
  BaseAuth? baseAuth = Auth();
  // Stream<LocationDto>? locationStream;
  // StreamSubscription<LocationDto>? locationSubscription;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  TextEditingController phoneNumberController = TextEditingController();

  // PageController tabController = new PageController();

  bool isLoading = false;
  bool signup = false;
  bool passMatch = false;
  bool termsCheck = false;
  int signUpIndex = 0;
  int userTYpe = UserType.customer.index;
  bool isObSecure = true;
  bool isObSecure2 = true;

  Future acceptTerms() async {
    termsCheck = !termsCheck;
    notifyListeners();
  }

  void toggleObSecure(bool isPassword) {
    if (isPassword) {
      isObSecure = !isObSecure;
    } else {
      isObSecure2 = !isObSecure2;
    }

    notifyListeners();
  }

  void startLoader() {
    isLoading = true;
    notifyListeners();
  }

  void stopLoader() {
    isLoading = false;
    notifyListeners();
  }

  void goToSignup() {
    signup = !signup;
    signUpIndex = 0;
    notifyListeners();
  }

  void changeSignUpPageIndex(int index) {
    if (index == 0) {
      signUpIndex = 1;
    } else {
      signUpIndex = 0;
    }

    notifyListeners();
  }

  void update() {
    notifyListeners();
  }

  Future<void> registerUser(UserData userData, String password) async {
    startLoader();
    DocumentSnapshot userDocument =
        await FBCollections.users.doc(userData.email!).get();
    stopLoader();
    if (userDocument.exists) {
      log("user exist");
      ShowMessage.inSnackBar("Error", "User already exists");
    } else {
      startLoader();
      log("user does not exist");
      baseAuth
          ?.createUserWithEmailPassword(userData.email!, password)
          .then((value) async {
        log(value);
        await FBCollections.users
            .doc(userData.email)
            .set(userData.toJson())
            .then((value) async {
          appUser = await getUserFromDB(userData.email!);
          stopLoader();
          Get.offAllNamed(RegistrationSuccessful.route);
          ShowMessage.inSnackBar("Congrats", "Signup Successful");
        });
      });
    }
  }

  Future<UserData?> getUserFromDB(String docId) async {
    startLoader();
    DocumentSnapshot doc = await FBCollections.users.doc(docId).get();
    stopLoader();
    if (!doc.exists) {
      return null;
    }
    UserData user = UserData.fromJson(doc.data() as Map<String, dynamic>);
    return user;
  }

  Future signInNow(String email, String password) async {
    startLoader();
    baseAuth?.signInWithEmailPassword(email, password).then((value) async {
      log("sign in response::::$value");

      if (value.toString() == "0") {
        stopLoader();
      } else if (value.toString() == "1") {
        stopLoader();
        ShowMessage.inSnackBar(
          "Verification Error",
          "please verify your email through link",
        );
      } else {
        await handleSignIn(email: email);
      }
    });
  }

  Future<void> handleSignIn({String? email, bool isSplash = false}) async {
    log("handle sign in");
    startLoader();
    log("get user from db");
    appUser = (await getUserFromDB(email!));
    stopLoader();
    log("user found = ${appUser?.toJson()}");
    log("got user from db");

    if (appUser?.status == UserStatus.active.index) {
      if (appUser?.role == UserType.customer.index) {
        await Get.offAllNamed(BaseView.route)?.then((value) async {
          await updateFcm(email);
        });
      } else {
        await getBackgroundLocation();
        await Get.offAllNamed(CarrierBaseView.route)?.then((value) async {
          await updateFcm(email);
        });
      }
    } else {
      if (isSplash) {
        await Get.offAll(() => const AuthView(),
            transition: Transition.leftToRightWithFade);
      }
      ShowMessage.inSnackBar(
        "Blocked",
        "User is blocked and cannot sign in",
      );
    }
  }

  Future<void> getCurrentUser() async {
    await checkPermissions();
    var user = await baseAuth?.getCurrentUser();
    if (user != null) {
      var userData = await getUserFromDB(user.email!);
      if (userData != null) {
        handleSignIn(email: user.email, isSplash: true);
      } else {
        await auth.signOut();
        await Get.offAllNamed(
          LandingPage.route,
        );
      }
    } else {
      await auth.signOut();
      await Get.offAllNamed(
        LandingPage.route,
      );
    }
  }

  Future<void> updateFcm(String docID) {
    var fcm =
        FBCollections.users.doc(docID).update({"fcm_id": AppUtils.myFcmToken});
    return fcm;
  }

  Future<bool> checkPermissions() async {
    return true;
  }

  getBackgroundLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    location.enableBackgroundMode(enable: true);

    var locationStreamSubscription =
        location.onLocationChanged.listen((locationData) {
      onData(locationData); //your function for handling location updates
    });
    print(locationStreamSubscription);
  }

  void onData(LocationData dto) {
    // print(dtoToString(dto));
    FBCollections.users
        .doc(_firebaseAuth.currentUser?.email)
        .update({"lat": dto.latitude, "long": dto.longitude}).then(
            (value) => print([value]));
  }

  // /// Is "location always" permission granted?
  // Future<bool> isLocationAlwaysGranted() async =>
  //     await Permission.locationAlways.isGranted;
  //
  // /// Tries to ask for "location always" permissions from the user.
  // /// Returns `true` if successful, `false` othervise.
  // Future<bool> askForLocationAlwaysPermission() async {
  //   bool granted = await Permission.locationAlways.isGranted;
  //
  //   if (!granted) {
  //     granted =
  //         await Permission.locationAlways.request() == PermissionStatus.granted;
  //   }
  //
  //   return granted;
  // }
}
