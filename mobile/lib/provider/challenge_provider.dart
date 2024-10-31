import 'package:flutter/material.dart';
import 'package:doan_tapgymtainha/service/api_challenge.dart';

class ChallengeProvider with ChangeNotifier {
  List<dynamic> _chalprogress = [];
  bool _isLoading = true;

  List<dynamic> get chalprogress => _chalprogress;
  bool get isLoading => _isLoading;

  ChallengeProvider() {
    loadChallenges(); // Tự động tải dữ liệu khi khởi tạo provider
  }

  Future<void> loadChallenges() async {
    try {
      _chalprogress = await ApiChallenge.fetchChallenges();
    } catch (error) {
      print("Error fetching workouts: $error");
    } finally {
      _isLoading = false;
      notifyListeners(); // Thông báo cho các widget đang lắng nghe cập nhật
    }
  }
}
