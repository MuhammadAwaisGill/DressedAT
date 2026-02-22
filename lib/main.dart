import 'package:flutter/material.dart';
import 'shared/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DressedAT',
      theme: ThemeData.dark(),
      home: const SplashScreen(),
    );
  }
}