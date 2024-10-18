import 'package:doan_tapgymtainha/screen/authentication/login_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'dashboard_screen.dart'; // Để sử dụng Timer

class SplashScreen extends StatelessWidget {
  final _storage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    // Sử dụng Timer để điều hướng sau 2 giây
    Timer(Duration(seconds: 2), () async {
      // Lấy token từ bộ nhớ bảo mật
      String? token = await _storage.read(key: 'jwtToken');

      if (token != null) {
        // Kiểm tra nếu token đã hết hạn
        bool isTokenExpired = JwtDecoder.isExpired(token);

        if (!isTokenExpired) {
          // Token hợp lệ, điều hướng đến Dashboard
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => DashboardScreen(userId: 'someUserId'),
            ),
          );
        } else {
          _showSessionExpiredDialog(context);
          // Navigator.of(context).pushReplacement(
          //   MaterialPageRoute(
          //     builder: (context) => LoginScreen(),
          //   ),
          // );
        }
      } else {
        // Không có token, điều hướng đến màn hình đăng nhập
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
        ), // Hiển thị hình ảnh/logo
      ),
    );
  }

  void _showSessionExpiredDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Phiên đăng nhập đã hết hạn'),
        content: Text('Vui lòng đăng nhập lại để tiếp tục.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Chuyển đến màn hình đăng nhập sau khi người dùng bấm OK
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ),
              );
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
