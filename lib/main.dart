import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() async {
  runApp(TaksiApp());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

class TaksiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Taksim Kapımda',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: SplashScreen(), // SplashScreen'i ilk ekran olarak ayarlıyoruz
    );
  }
}
