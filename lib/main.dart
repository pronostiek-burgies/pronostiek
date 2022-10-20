import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pronostiek/colors.dart/wc_background.dart';
import 'package:pronostiek/colors.dart/wc_red.dart';
import 'package:pronostiek/pages/splash.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pronostiek Burgies',
      theme: ThemeData(
        primarySwatch: wcRed,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: wcRed,
          backgroundColor: wcBackground
          ),
        scaffoldBackgroundColor: wcBackground,
        cardColor: const Color(0xFFF7F6E9),
      ),
      home: const SplashPage(),
    );
  }
}


