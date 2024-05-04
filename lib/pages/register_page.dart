import 'package:flutter/material.dart';
import 'package:footware_user/controller/login_controller.dart';
import 'package:footware_user/pages/home_page.dart';
import 'package:footware_user/pages/login_page.dart';
import 'package:footware_user/widgets/otp_txt_field.dart';
import 'package:get/get.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      builder: (ctrl) {
        return Scaffold(
            body: Container(
          width: double.maxFinite,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.blueGrey[50]),
          child: Form(
            key: _key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Create Your Account !!",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      color: Colors.deepPurple),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  keyboardType: TextInputType.name,
                  controller: ctrl.nameController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: Icon(Icons.person_2),
                      labelText: 'Name',
                      hintText: 'Enter your name '),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  controller: ctrl.mobileController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: Icon(Icons.phone_android),
                      labelText: 'Mobile number',
                      hintText: 'Enter your mobile number'),
                ),
                const SizedBox(
                  height: 15,
                ),
                OtpTextField(
                  otpController: ctrl.otpController,
                  visible: ctrl.otpFieldShown,
                  onComplete: (otp) {
                    ctrl.otpEntered = int.tryParse(otp!);
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (ctrl.otpFieldShown) {
                      ctrl.addUser();
                      Get.to(HomePage());
                    } else {
                      ctrl.sendOtp();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple),
                  child: Text(
                    ctrl.otpFieldShown ? 'Register' : 'Send OTP',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                  child: Text('Login'),
                  onPressed: () {
                    Get.to(const LoginPage());
                  },
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ));
      },
    );
  }
}
