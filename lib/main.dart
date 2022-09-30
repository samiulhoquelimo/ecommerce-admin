import 'package:ecommerce_admin/pages/launcher_page.dart';
import 'package:ecommerce_admin/pages/login_page.dart';
import 'package:ecommerce_admin/providers/order_provider.dart';
import 'package:ecommerce_admin/providers/product_provider.dart';
import 'package:ecommerce_admin/providers/user_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import 'pages/category_page.dart';
import 'pages/dashboard_page.dart';
import 'pages/new_product_page.dart';
import 'pages/product_details_page.dart';
import 'pages/product_page.dart';
import 'pages/user_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => ProductProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => OrderProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => UserProvider(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: LauncherPage.routeName,
      builder: EasyLoading.init(),
      routes: {
        LauncherPage.routeName: (_) => const LauncherPage(),
        LoginPage.routeName: (_) => const LoginPage(),
        DashboardPage.routeName: (_) => const DashboardPage(),
        ProductPage.routeName: (_) => const ProductPage(),
        NewProductPage.routeName: (_) => const NewProductPage(),
        ProductDetailsPage.routeName: (_) => const ProductDetailsPage(),
        //OrderPage.routeName: (_) => OrderPage(),
        //OrderListPage.routeName: (_) => OrderListPage(),
        UserPage.routeName: (_) => const UserPage(),
        //SettingsPage.routeName: (_) => SettingsPage(),
        //ReportPage.routeName: (_) => ReportPage(),
        CategoryPage.routeName: (_) => CategoryPage(),
      },
    );
  }
}
