import 'package:doan_tapgymtainha/screen/checkcalories/trackfoodcalories.dart';
import 'package:flutter/material.dart';
import 'package:doan_tapgymtainha/screen/start_screen.dart'; // Import StartScreen
import 'package:doan_tapgymtainha/screen/home_screen.dart';
import 'package:doan_tapgymtainha/screen/profile_screen.dart';
import 'package:doan_tapgymtainha/screen/explore_screen.dart';
import 'package:doan_tapgymtainha/screen/setting_screen.dart';
import 'counter_steps/counter_steps_screen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  Widget _getScreen(int index) {
    switch (index) {
      case 0:
        return HomeScreen();
      case 1:
        return HomeScreen();
      case 2:
        return StartScreen(); // StartScreen will be created anew each time the tab is selected
      case 3:
        return CounterStepsScreen();
      case 4:
        return SettingScreen();
      default:
        return HomeScreen();
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getScreen(_selectedIndex), // Get screen from _getScreen method
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Check Calories',
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
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.black54
            : Colors.white,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
  }
}
