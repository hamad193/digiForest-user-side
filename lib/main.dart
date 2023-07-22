import 'package:digi_forest/Screens/ChatScreen.dart';
import 'package:digi_forest/Screens/MapScreen.dart';
import 'package:digi_forest/Screens/StatsScreen.dart';
import 'package:digi_forest/Screens/splash_screen.dart';
import 'package:digi_forest/bottom_nav_bar.dart';
import 'package:digi_forest/Screens/home_screen.dart';
import 'package:digi_forest/Screens/login_screen.dart';
import 'package:digi_forest/Screens/signup_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
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
      // home: BottomNavigationBarScreen(),
      home: SplashScreen(),
      builder: EasyLoading.init(),
    );
  }
}

