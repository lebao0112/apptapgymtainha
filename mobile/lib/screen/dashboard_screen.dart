import 'package:doan_tapgymtainha/screen/statistics_sreen.dart';
import 'package:flutter/material.dart';
import 'package:doan_tapgymtainha/screen/start_screen.dart'; // Import StartScreen
import 'package:doan_tapgymtainha/screen/home_screen.dart';
import 'package:doan_tapgymtainha/screen/profile_screen.dart';
import 'package:doan_tapgymtainha/screen/explore_screen.dart';
import 'package:doan_tapgymtainha/screen/setting_screen.dart';

class DashboardScreen extends StatefulWidget {
  final String userId; // Add the userId field

  const DashboardScreen({Key? key, required this.userId})
      : super(key: key); // Pass the userId in constructor

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  late List<Widget> _screens;
  bool _startScreenLoaded = false; // Track if StartScreen is loaded

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(),
      ExploreScreen(),
      Container(),
      StatisticsSreen(), // Placeholder for StartScreen until it's loaded
      SettingScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 2 && !_startScreenLoaded) {
        // Lazy load StartScreen when selected
        _screens[2] = StartScreen(
            userId: widget.userId); // Use widget.userId to pass userId
        print("userId $widget.userId");
        _startScreenLoaded = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _screens[_selectedIndex],
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
            icon: Icon(Icons.add),
            label: 'Bắt đầu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.report),
            label: 'Thống kê',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Cài đặt',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.black12,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
        selectedLabelStyle: TextStyle(color: Colors.orange),
        unselectedLabelStyle: TextStyle(color: Colors.white),
      ),
    );
  }
}
