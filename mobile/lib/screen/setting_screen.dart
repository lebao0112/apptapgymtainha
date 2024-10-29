import 'package:doan_tapgymtainha/cache/user_profile_cache.dart';
import 'package:doan_tapgymtainha/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'authentication/login_screen.dart';
import 'profile_screen.dart'; // Đảm bảo bạn đã tạo ProfileScreen

class SettingScreen extends StatelessWidget {
  final GoogleSignIn _googleSignIn = GoogleSignIn(); // Create a GoogleSignIn instance

  void _logout(BuildContext context) async {
    // Sign out from Google
    try {
      await _googleSignIn.signOut();
      print('Google user signed out.');
    } catch (e) {
      print('Error signing out from Google: $e');
    }

    UserProfileCache.clearCache();
    // Delete the JWT token from secure storage

    await ApiService.deleteToken();

    // Navigate back to the login screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );

    // Optionally, you can show a SnackBar to confirm the logout
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đăng xuất thành công'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CÀI ĐẶT',style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black, // Nền đen
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Profile Section
            ListTile(
              leading: Icon(Icons.person, color: Colors.orangeAccent),
              title: Text(
                'Hồ sơ cá nhân',
                style: TextStyle(color: Colors.white), // Chữ trắng
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
              },
            ),
            Divider(color: Colors.grey),

            // Notifications Section
            ListTile(
              leading: Icon(Icons.notifications, color: Colors.orangeAccent),
              title: Text(
                'Thông báo',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                // Điều hướng đến màn hình Notifications
              },
            ),
            Divider(color: Colors.grey),

            // Workout History Section
            ListTile(
              leading: Icon(Icons.history, color: Colors.orangeAccent),
              title: Text(
                'Lịch sử tập luyện',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                // Điều hướng đến màn hình Workout History
              },
            ),
            Divider(color: Colors.grey),

            // Workout Goals Section
            ListTile(
              leading: Icon(Icons.flag, color: Colors.orangeAccent),
              title: Text(
                'Mục tiêu tập luyện',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                // Điều hướng đến màn hình Workout Goals
              },
            ),
            Divider(color: Colors.grey),

            // Privacy Settings Section
            ListTile(
              leading: Icon(Icons.privacy_tip, color: Colors.orangeAccent),
              title: Text(
                'Quyền bảo mật và riêng tư',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                // Điều hướng đến cài đặt bảo mật
              },
            ),
            Divider(color: Colors.grey),

            // Appearance Section (Light/Dark Mode)
            ListTile(
              leading: Icon(Icons.brightness_6, color: Colors.orangeAccent),
              title: Text(
                'Chỉnh màu sáng/tối',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                // Điều hướng đến cài đặt chế độ sáng/tối
              },
            ),
            Divider(color: Colors.grey),

            // Language Section
            ListTile(
              leading: Icon(Icons.language, color: Colors.orangeAccent),
              title: Text(
                'Ngôn ngữ',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                // Xử lý logic cho lựa chọn ngôn ngữ
              },
            ),
            Divider(color: Colors.grey),

            // Support Section
            ListTile(
              leading: Icon(Icons.help, color: Colors.orangeAccent),
              title: Text(
                'Hỗ trợ',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                // Điều hướng đến mục hỗ trợ
              },
            ),
            Divider(color: Colors.grey),

            ListTile(
              leading: Icon(Icons.logout, color: Colors.orangeAccent),
              title: Text(
                'Đăng xuất',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                _logout(context);
              },
            ),


          ],
        ),
      ),
    );
  }
}
