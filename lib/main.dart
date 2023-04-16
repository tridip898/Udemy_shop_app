import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/provider/auth.dart';
import 'package:shop_app/provider/orders.dart';
import 'package:shop_app/view/auth_screen.dart';
import 'package:shop_app/view/edit_product_screen.dart';
import 'package:shop_app/view/order_screen.dart';
import 'package:shop_app/view/product_overview_screen.dart';
import 'package:shop_app/view/user_products_screen.dart';
import './view/product_detail_screen.dart';
import 'package:provider/provider.dart';
import './provider/product_provider.dart';
import './provider/cart.dart';
import './view/cart_screen.dart';
import 'firebase_options.dart';
import './view/auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => Auth()),
          ChangeNotifierProvider(create: (context)=>ProductProvider()),
          ChangeNotifierProvider(create: (context) => Cart()),
          ChangeNotifierProvider(create: (context) => Orders()),
        ],
        child: Consumer<Auth>(
          builder: (context, auth, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: auth.isAuth ? ProductOverviewScreen() : AuthScreen(),
              routes: {
                '/product-overview': (context) => ProductOverviewScreen(),
                '/product-detail': (context) => ProductDetailScreen(),
                '/cart': (context) => CartScreen(),
                '/order-screen': (context) => OrdersScreen(),
                '/user-products': (context) => UserProductsScreen(),
                '/edit-product': (context) => EditProductScreen(),
                '/auth': (context) => AuthScreen()
              },
            );
          },
        ));
  }
}
