
import 'package:doan_tapgymtainha/screen/authentication/login_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'dashboard_screen.dart'; // Để sử dụng Timer

class SplashScreen extends StatelessWidget {
  final _storage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    // Use Timer to delay navigation
    Timer(Duration(seconds: 2), () async {
      String? token = await _storage.read(key: 'jwtToken');
      if (token != null) {
        // Token exists, navigate to home screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => DashboardScreen(userId: 'someUserId'),
          ),
        );
      } else {
        // No token, navigate to login screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
        );
      }
    });

    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image(
          image: AssetImage('assets/logo_app.png'),
          height: 120,
          width: 120,
        ), // Display your logo/image
      ),
    );
  }
}
