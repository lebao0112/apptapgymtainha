
import 'package:doan_tapgymtainha/screen/authentication/login_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async'; // Để sử dụng Timer

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Sử dụng Timer để điều hướng sau 2 giây
    Timer(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    });

    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image(
          image: AssetImage('assets/logo_app.png'),
          height: 120,
          width: 120,
        ), // Hiển thị hình ảnh/logo
      ),
    );
  }
}
