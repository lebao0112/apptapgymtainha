import 'package:flutter/material.dart';

class WorkoutTimerProvider with ChangeNotifier {
  DateTime? _startTime;
  Duration _totalTime = Duration.zero;

  void startTimer() {
    _startTime = DateTime.now();
  }

  void stopTimer() {
    if (_startTime != null) {
      _totalTime = DateTime.now().difference(_startTime!);
      _startTime = null; // Reset thời gian bắt đầu sau khi dừng
    }
    notifyListeners();
  }

  int get totalTime => _totalTime.inSeconds;
}
