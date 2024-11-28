//ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, unused_field , unused_import

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/controller/wishlist-controller.dart';
import 'package:shopping_app/screens/auth-ui/welcome-screen.dart';
import 'package:shopping_app/screens/user/all-category.dart';
import 'package:shopping_app/widgets/bottom-navigation.dart';
import 'controller/cart-controller.dart';
import 'firebase_options.dart';
import 'screens/splash-scree.dart';
import 'screens/user/home-screen.dart';

void main() async {
  Stripe.publishableKey ="pk_test_51QOgAdAOzOvmGUXDbOb83pqlA0K1WlRnPfHfggtNBOHicJNmNJtrmCSMiIFpslkJLPlIoCbGjyeuT8XRCrEIYt7v00bmMSvsXB";
      // "pk_test_51PGXvy06xtEbkBYxUkFo4Sdng5zZTx4tcKZynJcUyAreSpphCrtXk8wOC54TXKTYMT4R6oVVcYpf0EZUEw1wTXZq00122GrocM";
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  BindingsBuilder(() {
    Get.put(CartController());
  });

  runApp(
    ChangeNotifierProvider(
      create: (context) => WishlistController(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (BuildContext context, Widget? child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TrendCart',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
