import 'package:doan_tapgymtainha/screen/excercise_screen.dart';
import 'package:doan_tapgymtainha/screen/trainingprogram_screen.dart';
import 'package:flutter/material.dart';
import 'package:doan_tapgymtainha/screen/login_screen.dart';
import 'package:doan_tapgymtainha/screen/dashboard_screen.dart';
import 'package:doan_tapgymtainha/screen/register_screen.dart';

void main() {
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
      home: const TrainingProgramScreen(),
    );
  }
}