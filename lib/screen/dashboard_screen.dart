import 'package:flutter/material.dart';
import 'package:doan_tapgymtainha/screen/home_screen.dart'; // Màn hình Tập luyện
import 'package:doan_tapgymtainha/screen/profile_screen.dart'; // Màn hình Khám phá

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  // List of screens
  final List<Widget> _screens = [
    HomeScreen(),
    ProfileScreen(),
    // Thêm các màn hình khác nếu cần
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Nền đen cho toàn bộ màn hình
      body: _screens[_selectedIndex], // Hiển thị màn hình được chọn
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Trang chủ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore),
              label: 'Khám phá',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add), // Add a placeholder for FAB (Not clickable)
              label: 'Bắt đầu',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Hồ sơ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orange, // Màu cam cho mục đang chọn
        unselectedItemColor: Colors.grey, // Màu xám cho các mục không được chọn
        backgroundColor: Colors.black12, // Nền đen cho BottomNavigationBar
        type: BottomNavigationBarType.fixed, // Loại thanh điều hướng cố định
        onTap: _onItemTapped, // Xử lý sự kiện khi nhấn vào các mục
        selectedLabelStyle: TextStyle(color: Colors.orange), // Màu chữ cho mục chọn
        unselectedLabelStyle: TextStyle(color: Colors.white), // Màu chữ cho mục không chọn
      ),
    );
  }
}
