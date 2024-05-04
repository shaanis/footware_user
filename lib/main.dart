import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:footware_user/controller/home_controller.dart';
import 'package:footware_user/controller/login_controller.dart';
import 'package:footware_user/controller/purchase_controller.dart';
import 'package:footware_user/pages/home_page.dart';
import 'package:footware_user/pages/login_page.dart';
import 'package:footware_user/pages/product_descrption.dart';
import 'package:footware_user/pages/register_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'firebase_options.dart';

Future<void> main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(LoginController());
  Get.put(HomeController());
  Get.put(PurchasCtrl());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Footware',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/HomePage': (context) => const HomePage(),
        '/RegisterPage': (context) => RegisterPage(),
        '/ProductDescription': (context) => ProductDescription()
        // Add more routes here if needed
      },
      // home:  RegisterPage(),
    );
  }
}
