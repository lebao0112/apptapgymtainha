import 'package:flutter/material.dart';
import 'package:doan_tapgymtainha/service/api_challenge.dart';

class ChalprogressProvider with ChangeNotifier {
  List<dynamic> _chalprogresses = [];
  bool _isLoading = true;
  bool _isWaitingForCompleted = false;

  List<dynamic> get chalprogresses => _chalprogresses;
  bool get isLoading => _isLoading;
  bool get isWaitingForCompleted => _isWaitingForCompleted;

  ChalprogressProvider() {
    loadChalProgresses(); // Tự động tải dữ liệu khi khởi tạo provider
  }

  Future<void> loadChalProgresses() async {
    try {
      _chalprogresses = await ApiChallenge.fetchChallengeProgressData();
    } catch (error) {
      print("Error fetching chalprogress: $error");
    } finally {
      _isLoading = false;
      notifyListeners(); // Thông báo cho các widget đang lắng nghe cập nhật
    }
  }


  Future<void> increaseChalProgress(String chalprogressId) async {
    try {
      await ApiChallenge.increaseChalProgress(chalprogressId);
      loadChalProgresses();
    } catch (error) {
      print("Error fetching chalprogress: $error");
    } finally {
      _isLoading = false;
      notifyListeners(); // Thông báo cho các widget đang lắng nghe cập nhật
    }
  }

  Map<String, dynamic> getProgressForChallenge(String challengeId) {
    final chalprogress = _chalprogresses.firstWhere(
          (item) => item['ChallengeId'] == challengeId,
      orElse: () => null,
    );
    return chalprogress != null ? chalprogress : null;
  }
}