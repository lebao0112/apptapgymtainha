import 'package:doan_tapgymtainha/service/api_history.dart';
import 'package:doan_tapgymtainha/shared/format.dart';
import 'package:flutter/material.dart';

class WorkoutTimerProvider with ChangeNotifier {
  DateTime? _startTime;
  Duration _totalTime = Duration.zero;
  List<dynamic> _histories = [];
  bool _isLoading = true;

  String _currentWorkoutName = '';
  String _currentWorkoutId = '';
  int _currentCalories = 0;

  String get currentWorkoutName => _currentWorkoutName;
  String get currentWorkoutId => _currentWorkoutId;
  int get currentCalories => _currentCalories;
  int get totalTime => _totalTime.inSeconds;

  List<dynamic> get histories => _histories;
  bool get isLoading => _isLoading;

  WorkoutTimerProvider(){
    loadHistory();
  }

  void startTimer(String workoutName, String workoutId, int calories) {
    _currentWorkoutName = workoutName;
    _currentWorkoutId = workoutId;
    _currentCalories = calories;
    _startTime = DateTime.now();
    _totalTime = Duration.zero;
    notifyListeners();
  }

  void stopTimer() {
    if (_startTime != null) {
      _totalTime = DateTime.now().difference(_startTime!);
      _startTime = null; // Reset thời gian bắt đầu sau khi dừng
    }
    notifyListeners();
  }


  Future<void> addHistory() async {
    final totalTimeFormatted = Format.formatDuration(_totalTime.inSeconds);
    await ApiHistory.addHistory(
      workoutName: _currentWorkoutName,
      workoutId: _currentWorkoutId,
      totalTime: totalTimeFormatted,
      calories: _currentCalories,
    );
    loadHistory();
  }

  Future<void> loadHistory() async {
    try {
      _histories = await ApiHistory.fetchUserHistory();
      print(_histories);
    } catch (error) {
      print("Error fetching histories: $error");
    } finally {
      _isLoading = false;
      notifyListeners(); // Thông báo cho các widget đang lắng nghe cập nhật
    }
  }

}
