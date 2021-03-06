import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodstack/src/blocs/auth_blocs.dart';
import 'package:foodstack/src/providers/cartProvider.dart';
import 'package:foodstack/src/providers/menuProvider.dart';
import 'package:foodstack/src/providers/orderProvider.dart';
import 'package:foodstack/src/providers/paymentProvider.dart';
import 'package:foodstack/src/providers/ratingProvider.dart';
import 'package:foodstack/src/providers/userLocator.dart';
import 'package:foodstack/src/providers/restaurantProvider.dart';
import 'package:foodstack/src/screens/address.dart';
import 'package:foodstack/src/screens/authentication/login.dart';
import 'package:foodstack/src/screens/authentication/reset.dart';
import 'package:foodstack/src/screens/authentication/signup.dart';
import 'package:foodstack/src/screens/authentication/verify.dart';
import 'package:foodstack/src/screens/cart.dart';
import 'package:foodstack/src/screens/checkout.dart';
import 'package:foodstack/src/screens/details.dart';
import 'package:foodstack/src/screens/favourites.dart';
import 'package:foodstack/src/screens/home.dart';
import 'package:foodstack/src/screens/joinOrders.dart';
import 'package:foodstack/src/screens/menu.dart';
import 'package:foodstack/src/screens/newOrder.dart';
import 'package:foodstack/src/screens/orderSummary.dart';
import 'package:foodstack/src/screens/profile.dart';
import 'package:foodstack/src/screens/recentOrders.dart';
import 'package:foodstack/src/screens/track.dart';
import 'package:foodstack/src/screens/wait.dart';
import 'package:foodstack/src/screens/welcome.dart';
import 'package:foodstack/src/services/analyticsService.dart';
import 'package:foodstack/src/services/firestoreUsers.dart';
import 'package:foodstack/src/services/notifications.dart';
import 'package:foodstack/src/styles/themeColors.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  final StatefulWidget home;

  const App({this.home});
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserLocator()),
        ChangeNotifierProvider(create: (context) => RestaurantProvider()),
        ChangeNotifierProvider(create: (context) => MenuProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => OrderProvider()),
        ChangeNotifierProvider(create: (context) => PaymentProvider()),
        ChangeNotifierProvider(create: (context) => NotificationService()),
        ChangeNotifierProvider(create: (context) => RatingProvider()),
        Provider(create: (context) => AuthBloc())
      ],
      child: FutureBuilder(future: Future(() async {
        final auth = FirebaseAuth.instance;
        bool isOnline = true;

        // isOnline = await InternetConnectionChecker().hasConnection;
        if (auth.currentUser != null && isOnline) {
          final firestoreService = FirestoreUsers();
          await firestoreService.saveDeviceToken();
          await firestoreService.setUserProperties();
          await Future.delayed(Duration(milliseconds: 500));
        } else {
          await Future.delayed(Duration(seconds: 1));
        }
        return;
      }), builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
              debugShowCheckedModeBanner: false, home: SplashScreen());
        } else {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'FoodStack',
            home: widget.home,
            routes: {
              '/login': (context) => LoginScreen(),
              '/signup': (context) => SignUpScreen(),
              '/verifyEmail': (context) => VerifyScreen(),
              '/resetPassword': (context) => ResetScreen(),
              '/pickAddress': (context) => AddressScreen(),
              '/cart': (context) => CartScreen(),
              '/checkout': (context) => CheckoutScreen(null),
              '/details': (context) => DetailsScreen(),
              '/favourites': (context) => FavouritesScreen(),
              '/home': (context) => HomeScreen(),
              '/joinOrders': (context) => JoinOrdersScreen(),
              '/menu': (context) => MenuScreen(),
              '/newOrder': (context) => NewOrderScreen(),
              '/orderSummary': (context) => SummaryScreen(),
              '/profile': (context) => ProfileScreen(),
              '/recentOrders': (context) => RecentOrdersScreen(),
              '/trackOrder': (context) => TrackScreen(),
              '/wait': (context) => WaitScreen(),
              '/welcome': (context) => WelcomeScreen(),
            },
            navigatorObservers: [AnalyticsService().getAnalyticsObserver()],
          );
        }
      }),
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.oranges,
      body: Center(
        child: Image.asset(
          'images/FoodStack_Logo_Orange_Fast.gif',
          width: MediaQuery.of(context).size.width / 1.5,
        ),
      ),
    );
  }
}
