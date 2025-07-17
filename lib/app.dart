import 'package:chronocare_app/core/services/auth_gate.dart';
import 'package:flutter/material.dart';
import 'package:chronocare_app/screens/splash/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:chronocare_app/providers/auth_provider.dart';

class ChronoCareApp extends StatefulWidget {
  const ChronoCareApp({super.key});

  static _ChronoCareAppState? of(BuildContext context) => context.findAncestorStateOfType<_ChronoCareAppState>();

  @override
  State<ChronoCareApp> createState() => _ChronoCareAppState();
}

class _ChronoCareAppState extends State<ChronoCareApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthProvider>(
      create: (_) {
        final provider = AuthProvider();
        provider.setUser(null); // Optionally set initial user
        return provider;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ChronoCare',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blue,
        ),
        themeMode: _themeMode,
        home: const SplashScreen(),
      ),
    );
  }
} 