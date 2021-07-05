import 'package:flutter/material.dart';
import 'package:new_dish_admin_panlel/main_page.dart';
import 'package:new_dish_admin_panlel/provider/bill_man_provider.dart';
import 'package:new_dish_admin_panlel/provider/billing_provider.dart';
import 'package:new_dish_admin_panlel/provider/customer_provider.dart';
import 'package:new_dish_admin_panlel/provider/head_provider.dart';
import 'package:new_dish_admin_panlel/provider/public_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  firebase_core.Firebase.initializeApp();
  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  Map<int, Color> color = {
    //RGB Color Code (0, 194, 162)
    50: Color.fromRGBO(22, 43, 54, .1),
    100: Color.fromRGBO(22, 43, 54, .2),
    200: Color.fromRGBO(22, 43, 54, .3),
    300: Color.fromRGBO(22, 43, 54, .4),
    400: Color.fromRGBO(22, 43, 54, .5),
    500: Color.fromRGBO(22, 43, 54, .6),
    600: Color.fromRGBO(22, 43, 54, .7),
    700: Color.fromRGBO(22, 43, 54, .8),
    800: Color.fromRGBO(22, 43, 54, .9),
    900: Color.fromRGBO(22, 43, 54, 1),
  };
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=>PublicProvider()),
        ChangeNotifierProvider(create: (context)=>CustomerProvider()),
        ChangeNotifierProvider(create: (context)=>BillManProvider()),
        ChangeNotifierProvider(create: (context)=>HeadProvider()),
        ChangeNotifierProvider(create: (context)=>BillingProvider())
      ],
      child: MaterialApp(
        title: 'Dhaka Fiber Link LTD',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          backgroundColor: Colors.blueGrey.shade50,
          primarySwatch: MaterialColor(0xff162B36, color),
          canvasColor: Colors.transparent
        ),
        home: MainPage(),
      ),
    );
  }
}