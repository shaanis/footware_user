import 'package:flutter/material.dart';
import 'package:footware_user/controller/home_controller.dart';
import 'package:footware_user/controller/purchase_controller.dart';
import 'package:footware_user/pages/MyOrders.dart';
import 'package:footware_user/pages/login_page.dart';
import 'package:footware_user/pages/product_descrption.dart';
import 'package:footware_user/widgets/dropdownbutton.dart';
import 'package:footware_user/widgets/product_card.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../widgets/multiselectdropbtn.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PurchasCtrl>(builder: (logic) {
      return GetBuilder<HomeController>(
        builder: (ctrl) {
          return RefreshIndicator(
            onRefresh: () async {
              ctrl.fetchProducts();
            },
            child: Scaffold(
              appBar: AppBar(
                actions: [
                  IconButton(
                      onPressed: () {
                        final GetStorage box = GetStorage();
                        box.erase();
                        Get.offAll(LoginPage());
                      },
                      icon: Icon(Icons.logout)),
                  IconButton(
                      onPressed: () {
                        logic.order;
                        Get.to(() => MyOrderPage());
                      },
                      icon: Icon(Icons.blur_on_outlined))
                ],
                title: const Center(
                  child: Text(
                    'Footware Store',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              body: Column(
                children: [
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: ctrl.productCategories.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              ctrl.filterByCategory(
                                  ctrl.productCategories[index].name ?? '');
                              //print('object');
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Chip(
                                  label: Text(
                                      ctrl.productCategories[index].name ??
                                          'Error')),
                            ),
                          );
                        }),
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: CustomDropButton(
                            items: ['sort', 'low to high', 'high to low'],
                            selectedValue: 'sort',
                            onSelected: (selected) {
                              ctrl.sortByPrice(
                                  ascending:
                                  selected == 'low to high' ? true : false);
                            }),
                      ),
                      Flexible(
                          child: Multidropbtn(
                            items: ['Adidas', 'Puma', 'Clarks', 'Nike'],
                            onSelectionChanged: (selectedItems) {
                              //print(selectedItems);
                              ctrl.filterByBrand(selectedItems);
                            },
                          )),
                    ],
                  ),
                  Expanded(
                    child: GridView.builder(
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: ctrl.productShowinUi.length,
                        itemBuilder: (context, index) {
                          return ProductCard(
                            imageUrl: ctrl.productShowinUi[index].image ?? 'aa',
                            offerTag: '20 % off',
                            price: ctrl.productShowinUi[index].price.toString(),
                            name: ctrl.productShowinUi[index].name ?? 'aa',
                            onTap: () {
                              Get.to(const ProductDescription(), arguments: {
                                'data': ctrl.productShowinUi[index]
                              });
                            },
                          );
                        }),
                  )
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
