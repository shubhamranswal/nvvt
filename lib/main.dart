import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nakshatra_vatika/splash_screen/splash.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nakshatra Vatika',
      theme: ThemeData(
        fontFamily: 'TiltNeon',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
        useMaterial3: true,
      ),
      home: const SplashScreen()
    );
  }
}