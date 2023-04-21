import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import './providers/cart.dart';
// import './providers/auth.dart';
// import './providers/products_provider.dart';
// import './providers/orders.dart';
// import './routes/products_overview_screen.dart';
// import './routes/product_detail_screen.dart';
// import './routes/orders_screen.dart';
// import './routes/user_product_screen.dart';
// import './routes/edit_product_screen.dart';
// import './routes/cart_screen.dart';
// import './routes/auth_screen.dart';
import './routes/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
    );
    //provider=======================================================
    //   MultiProvider(
    //   providers: [
    //     ChangeNotifierProvider(
    //       create: (ctx) => Auth(),
    //     ),
    //     ChangeNotifierProxyProvider<Auth, Products>(
    //       create: (ctx) => Products('', '', []),
    //       update: (ctx, auth, previousProducts) => Products(
    //         auth.token.toString(),
    //         auth.userId.toString(),
    //         previousProducts == null ? [] : previousProducts.items,
    //       ),
    //     ),
    //     ChangeNotifierProvider(
    //       create: (ctx) => Cart(),
    //     ),
    //     ChangeNotifierProxyProvider<Auth, Orders>(
    //       create: (ctx) => Orders('', '', []),
    //       update: (ctx, auth, previousOrders) => Orders(
    //         auth.token.toString(),
    //         auth.userId,
    //         previousOrders == null ? [] : previousOrders.orders,
    //       ),
    //     ),
    //   ],
    //   child: Consumer<Auth>(
    //     builder: (ctx, auth, _) => MaterialApp(
    //       title: 'OnLearning',
    //       theme: ThemeData(
    //         primarySwatch: Colors.blue,
    //       ),
    //       home: auth.isAuth
    //           ? const ProductsOverViewScreen()
    //           : FutureBuilder(
    //               future: auth.tryAutologin(),
    //               builder: (ctx, authSnapshot) =>
    //                   authSnapshot.connectionState == ConnectionState.waiting
    //                       ? const SplashScreen()
    //                       : const AuthScreen(),
    //             ),
    //       routes: {
    //         // ProductsOverViewScreen.rout
    //         ProductsOverViewScreen.routeName: (ctx) =>
    //             const ProductsOverViewScreen(),
    //         ProductDetailScreen.routeName: (ctx) => const ProductDetailScreen(),
    //         CartScreen.routeName: (ctx) => const CartScreen(),
    //         OrdersScreen.routeName: (ctx) => const OrdersScreen(),
    //         UserProductsScreen.routeName: (ctx) => const UserProductsScreen(),
    //         EditProductScreen.routeName: (ctx) => const EditProductScreen(),
    //       },
    //     ),
    //   ),
    // );
  }
}
