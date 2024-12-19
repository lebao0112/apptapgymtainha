import 'package:doan_tapgymtainha/cache/user_profile_cache.dart';
import 'package:doan_tapgymtainha/screen/checkcalories/fooddiary.dart';
import 'package:doan_tapgymtainha/screen/workout_history_screen.dart';
import 'package:doan_tapgymtainha/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../provider/theme_provider.dart';
import 'authentication/login_screen.dart';
import 'checkcalories/trackfoodcalories.dart';
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('CÀI ĐẶT',style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color)),
      ),
      body: Container(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Profile Section
            ListTile(
              leading: Icon(Icons.person, color: Colors.orangeAccent),
              title: Text(
                'Hồ sơ cá nhân',
                style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color), // Chữ trắng
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
                style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
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
                style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WorkoutHistoryScreen()),
                );
              },
            ),
            Divider(color: Colors.grey),

            // Workout Goals Section
            ListTile(
              leading: Icon(Icons.fastfood, color: Colors.orangeAccent),
              title: Text(
                'Kiểm tra calories thức ăn',
                style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
              ),
              onTap: () {
                // Điều hướng đến màn hình
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FoodDiary()),
                );
              },
            ),
            Divider(color: Colors.grey),

            // Appearance Section (Light/Dark Mode)
            ListTile(
              leading: Icon(Icons.brightness_6, color: Colors.orangeAccent),
              title: Text(
                'Chỉnh màu sáng/tối',
                style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
              ),
              trailing: Switch(
                value: themeProvider.isDarkMode,
                onChanged: (value) {
                  themeProvider.toggleTheme(value);
                },
                activeColor: Colors.orange,
              ),
            ),
            Divider(color: Colors.grey),

            // Language Section
            ListTile(
              leading: Icon(Icons.language, color: Colors.orangeAccent),
              title: Text(
                'Ngôn ngữ',
                style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
              ),
              onTap: () {
                // Xử lý logic cho lựa chọn ngôn ngữ
              },
            ),
            Divider(color: Colors.grey),

            ListTile(
              leading: Icon(Icons.logout, color: Colors.orangeAccent),
              title: Text(
                'Đăng xuất',
                style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
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
