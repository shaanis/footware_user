import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:footware_user/models/user/user.dart';
import 'package:footware_user/pages/home_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:otp_text_field_v2/otp_text_field_v2.dart';

class LoginController extends GetxController {
  final GetStorage box = GetStorage();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference userCollection;

  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  TextEditingController loginNoController = TextEditingController();

  OtpFieldControllerV2 otpController = OtpFieldControllerV2();
  bool otpFieldShown = false;
  int? otpSend;
  int? otpEntered;

  User? loginUser;

  @override
  void onReady() {
    Map<String, dynamic>? user = box.read('loginUser');
    if (user != null) {
      loginUser = User.fromJson(user);
      Get.to(HomePage());
    }
    super.onReady();
  }

  @override
  void onInit() {
    userCollection = firestore.collection('users');
    super.onInit();
  }

  addUser() {
    try {
      if (otpSend == otpEntered) {
        DocumentReference doc = userCollection.doc();
        User user = User(
            id: doc.id,
            name: nameController.text,
            mobile: int.parse(mobileController.text));

        final userJson = user.toJson();
        doc.set(userJson);
        Get.snackbar('Done', 'user added successfully',
            colorText: Colors.green);
        nameController.clear();
        mobileController.clear();
        otpController.clear();
      } else {
        Get.snackbar('Error', 'Otp is incorrect', colorText: Colors.red);
      }
    } on Exception catch (e) {
      Get.snackbar('Error', e.toString(), colorText: Colors.red);
    }
  }

  sendOtp() {
    try {
      if (nameController.text.isEmpty || nameController.text.isEmpty) {
        Get.snackbar('ERROR', 'Please fill all fields',
            colorText: Colors.green);
      }
      final random = Random();
      int otp = 1000 + random.nextInt(9000);
      print(otp);
      //will otp send or not
      // ignore: unnecessary_null_comparison
      if (otp != null) {
        otpFieldShown = true;
        otpSend = otp;
        Get.snackbar('Done', 'your otp is : $otp',
            colorText: Colors.red, duration: Duration(seconds: 10));
      } else {
        Get.snackbar('Error', 'otp not send', colorText: Colors.red);
      }
    } on Exception catch (e) {
    } finally {
      update();
    }
  }

  Future<void> loginWithPhone() async {
    try {
      String phoneNumber = loginNoController.text;
      if (phoneNumber.isNotEmpty) {
        var querySnapshot = await userCollection
            .where('number', isEqualTo: num.tryParse(phoneNumber))
            .limit(1)
            .get();
        if (querySnapshot.docs.isNotEmpty) {
          var userDoc = querySnapshot.docs.first;
          var userData = userDoc.data() as Map<String, dynamic>;
          box.write('loginUser', userData);
          loginNoController.clear();
          Get.to(const HomePage());

          Get.snackbar('Success', 'Login successful', colorText: Colors.green);
        } else {
          Get.snackbar('Error', 'User not found, please register first',
              colorText: Colors.red);
        }
      } else {
        Get.snackbar('Error', 'Please enter a phone number',
            colorText: Colors.red);
      }
    } on FirebaseException catch (e) {
      print("Firebase Exception: $e");
      Get.snackbar('Error', 'Failed to login. Please try again later.',
          colorText: Colors.red);
    } on Exception catch (e) {
      print("Exception: $e");
      Get.snackbar('Error', 'An unexpected error occurred.',
          colorText: Colors.red);
    }
  }
}
