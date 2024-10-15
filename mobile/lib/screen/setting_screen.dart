import 'package:flutter/material.dart';
import 'profile_screen.dart'; // Đảm bảo bạn đã tạo ProfileScreen

class SettingScreen extends StatelessWidget {
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

          ],
        ),
      ),
    );
  }
}
