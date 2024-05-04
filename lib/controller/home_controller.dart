import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:footware_user/models/product/product.dart';
import 'package:footware_user/models/productCategory/product_category.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference productCollection;
  late CollectionReference categoryCollection;

  List<Product> products = [];
  List<Product> productShowinUi = [];
  List<ProductCategory> productCategories = [];

  @override
  Future<void> onInit() async {
    productCollection = firestore.collection('products');
    categoryCollection = firestore.collection('category');
    await fetchCategory();
    await fetchProducts();
    super.onInit();
  }

//
  fetchProducts() async {
    try {
      QuerySnapshot productSnapshot = await productCollection.get();
      final List<Product> retrieveProducts = productSnapshot.docs
          .map((doc) => Product.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      products.clear();
      products.assignAll(retrieveProducts);
      productShowinUi.assignAll(products);
      // Get.snackbar('Success', 'successfully added', colorText: Colors.green);
    } catch (e) {
      Get.snackbar('Error!', e.toString(), colorText: Colors.red);
    } finally {
      update();
    }
  }

  fetchCategory() async {
    try {
      QuerySnapshot categorySnapshot = await categoryCollection.get();
      final List<ProductCategory> retrieveCategories = categorySnapshot.docs
          .map((doc) =>
              ProductCategory.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      productCategories.clear();
      productCategories.assignAll(retrieveCategories);
    } catch (e) {
      Get.snackbar('Error!', e.toString(), colorText: Colors.red);
    } finally {
      update();
    }
  }

  filterByCategory(String category) {
    productShowinUi.clear();
    productShowinUi =
        products.where((Product) => Product.category == category).toList();
    update();
  }

  filterByBrand(List<String> brand) {
    if (brand.isEmpty) {
      productShowinUi = products.toList(); // Convert products to a list
    } else {
      List<String> lowerCaseBrands =
          brand.map((brand) => brand.toLowerCase()).toList();
      productShowinUi = products
          .where((product) =>
              lowerCaseBrands.contains(product.brand?.toLowerCase()))
          .toList(); // Convert iterable to a list
    }
    update();
  }

  sortByPrice({required bool ascending}) {
    List<Product> sortedProducts = List<Product>.from(productShowinUi);
    sortedProducts.sort(((a, b) => ascending
        ? a.price!.compareTo(b.price!)
        : b.price!.compareTo(a.price!)));
    productShowinUi = sortedProducts;
    update();
  }
}
