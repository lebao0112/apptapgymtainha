import 'package:doan_tapgymtainha/screen/home_screen.dart';
import 'package:doan_tapgymtainha/screen/splash_screen.dart';
import 'package:doan_tapgymtainha/screen/trainingprogram_screen.dart';
import 'package:flutter/material.dart';
import 'package:doan_tapgymtainha/screen/dashboard_screen.dart';
import 'package:doan_tapgymtainha/screen/authentication/register_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}
