import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:footware_user/controller/purchase_controller.dart';
import 'package:get/get.dart';


import '../controller/home_controller.dart';

class MyOrderPage extends StatelessWidget {
  const MyOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PurchasCtrl>(builder: (ctrl) {
      return RefreshIndicator(
        onRefresh: () async{ ctrl.fetchOrder(id: "id"); },
        child: Scaffold(
          backgroundColor: Color.fromARGB(255, 209, 224, 226),
          appBar: AppBar(
            title: const Text(
              "Orders",
              style: TextStyle(fontSize: 17),
            ),
          ),
          body: ListView.builder(
            itemCount:ctrl.order.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title:Text(ctrl.order[index].item?? ''),
                  subtitle:Text((ctrl.order[index].price ?? 0).toString()),

                ),
              );
            },
          ),
        ),
      );
    });
  }
}
