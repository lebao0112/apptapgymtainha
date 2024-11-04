import 'package:flutter/material.dart';

class CompleteWorkoutStatusProvider with ChangeNotifier {
  bool _isCompleted = false;

  bool get isCompleted => _isCompleted;

  void markCompleted() {
    _isCompleted = true;
    notifyListeners();
  }
}