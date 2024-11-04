import 'package:flutter/material.dart';
import '../service/api_service.dart';

class WorkoutProvider with ChangeNotifier {
  List<dynamic> _workouts = [];
  bool _isLoading = false;

  List<dynamic> get workouts => _workouts;
  bool get isLoading => _isLoading;

  WorkoutProvider() {
    loadWorkouts();
  }

  Future<void> loadWorkouts() async {
    _isLoading = true;
    notifyListeners();
    try {
      _workouts = await ApiService.fetchUserWorkouts();
    } catch (error) {
      print("Error loading workouts: $error");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addWorkout(Map<String, dynamic> workout) async {
    // Thêm workout và tải lại danh sách workouts
    _workouts.add(workout);
    notifyListeners();
  }

  Future<void> deleteWorkout(String workoutId) async {
    try {
      await ApiService.deleteWorkoutWithToken(workoutId);
      loadWorkouts();
      notifyListeners(); // Cập nhật giao diện
    } catch (error) {
      print("Error deleting workout: $error");
    }
  }
}
