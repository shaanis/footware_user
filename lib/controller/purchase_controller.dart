import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:footware_user/controller/login_controller.dart';
import 'package:footware_user/models/user/user.dart';
import 'package:footware_user/pages/home_page.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../models/order/order.dart';

class PurchasCtrl extends GetxController {
  Map<String, dynamic>? paymentIntent;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference orderCollection;

  TextEditingController addressCtrl = TextEditingController();
  double orderPrice = 0;
  String itemName = '';
  String orderAddress = '';
  List<orders> order =[];
  @override
  void onInit() {
    orderCollection = firestore.collection('orders');
    update();
    super.onInit();
  }

  submitOrder(
      {required double price,
      required String item,
      required String description}) {
    orderPrice = price;
    itemName = item;
    orderAddress = addressCtrl.text;

    Razorpay razorpay = Razorpay();
    var options = {
      'key': 'rzp_test_WdLrdY8amkg6XV',
      'amount': price * 100,
      'name': itemName,
      'description': description,
    };

    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorpay.open(options);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    orderSuccess(transactionId: response.paymentId);
    Get.snackbar('Success', 'Payment Successfull', colorText: Colors.green);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    Get.snackbar('Failed', '${response.message}', colorText: Colors.red);
  }

  Future<void> orderSuccess({required String? transactionId}) async {
    User? loginUser = Get.find<LoginController>().loginUser;
    try {
      if (transactionId != null) {
        DocumentReference docRef = await orderCollection.add({
          'customer': loginUser?.name,
          'phone': loginUser?.mobile,
          'item': itemName,
          'price': orderPrice,
          'address': orderAddress,
          'transactionId': transactionId,
          'dateTime': DateTime.now().toString()
        });
        ShowDialog(docRef.id);
      }
    } catch (e) {
    }
  }

  Future<void>fetchOrder({required String? id})async{
    User? loginUser = Get.find<LoginController>().loginUser;
    try {
      QuerySnapshot ordersSnapshot = await orderCollection.get();
      final List<orders> retrieveorders = ordersSnapshot.docs
          .map((doc) => orders.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      order.clear();
      order.assignAll(retrieveorders);

    } on Exception catch (e) {
      Get.snackbar('Error!', e.toString(), colorText: Colors.red);
    } finally {
      update();
    }
    // Get.snackbar('Success', 'successfully added', colorText: Colors.green);
  }

  void ShowDialog(String orderId){
    Get.defaultDialog(title: "Order Success",content: Text('Your orderId is $orderId'),
    confirm: ElevatedButton(onPressed: (){
      Get.to(HomePage());
    }, child: Text('Close'))
    );
  }
}
