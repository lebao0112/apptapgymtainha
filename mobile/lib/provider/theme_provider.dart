import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//extends ChangeNotifier cap nhat ui  khi thay doi provider
class ThemeProvider extends ChangeNotifier {
  //false = sang
  bool _isDarkMode = false;

  //getter
  bool get isDarkMode => _isDarkMode;

  //constructor
  ThemeProvider() {
    _loadTheme();
  }

  void toggleTheme(bool isOn) {
    _isDarkMode = isOn;
    _saveTheme(isOn);
    //thong bao den cac widget dang lang nghe
    notifyListeners();
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    //dam bao giao dien cap nhat
    notifyListeners();
  }

  void _saveTheme(bool isOn) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', isOn);
  }
}
