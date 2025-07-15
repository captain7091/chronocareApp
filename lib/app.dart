import 'package:chronocare_app/core/services/auth_gate.dart';
import 'package:flutter/material.dart';
import 'package:chronocare_app/screens/splash/splash_screen.dart';

class ChronoCareApp extends StatelessWidget {
  const ChronoCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ChronoCare',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      home: const SplashScreen(),
    );
  }
} 