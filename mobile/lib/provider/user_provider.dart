import 'package:flutter/material.dart';
import 'package:doan_tapgymtainha/model/user.dart';
import 'package:doan_tapgymtainha/service/api_user_service.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = true;
  // Lấy thông tin user hiện tại
  User? get user => _user;
  bool get isLoading => _isLoading;

  UserProvider() {
    loadUserProfile();
  }

  // Cập nhật thông tin user
  void setUser(User newUser) {
    _user = newUser;
    _isLoading = false;
    notifyListeners();
  }

  // Xóa thông tin user
  void clearUser() {
    _user = null;
    _isLoading = false;
    notifyListeners();
  }

  // Lấy user từ JSON API
  // void setUserFromJson(Map<String, dynamic> json) {
  //   _user = User.fromJson(json);
  //   notifyListeners();
  // }

  Future<void> loadUserProfile() async {
    _isLoading = true;
    notifyListeners();
    try {
      final user = await ApiUserService.fetchUserProfile();
      setUser(user); // Cập nhật trạng thái user trong Provider
    } catch (error) {
      _isLoading = false;
      print('Error in loadUserProfile: $error');
      throw error;
    }
  }

  Future<void> updateProfile(
      String? name,
      String? email,
      String? height,
      String? weight,
      String? gender,
      String? dateOfBirth,
      String? avatarPath,
      ) async {
    try {
      _isLoading = true;
      notifyListeners();

      await ApiUserService.updateProfile(
          name, email, height, weight, gender, dateOfBirth, avatarPath);

      _user = await ApiUserService.fetchUserProfile();
    } catch (e) {
      print('Lỗi khi cập nhật thông tin trong Provider: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
