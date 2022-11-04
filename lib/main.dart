import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Detección de Artritis',
        home: AnimatedSplashScreen(
          splash: 'icon/SeekPng.com_praying-hands-png_70937.png',
          duration: 2000,
          splashTransition: SplashTransition.scaleTransition,
          backgroundColor: const Color.fromARGB(255, 45, 66, 99),
          nextScreen: ShowCaseWidget(
              builder: Builder(
            builder: (context) => Home(),
          )),
        ));
  }
}
