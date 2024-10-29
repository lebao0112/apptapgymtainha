import 'package:flutter/material.dart';
import 'package:doan_tapgymtainha/service/api_service.dart';

class WorkoutDetailsPvd extends ChangeNotifier{
  Map<String, dynamic> workoutDetail;

  WorkoutDetailsPvd(this.workoutDetail);

  Future<void> fetchData(String workoutId) async {
    try{
      final data = await ApiService.fetchWorkoutDetails(workoutId);

      this.workoutDetail = data;
      notifyListeners();
    }catch (error) {
      print('Failed to fetch workout details data: $error');
    }
  }

  void updateWorkoutDetail( Map<String, dynamic> newWorkoutDetail) {
    this.workoutDetail = newWorkoutDetail;
    notifyListeners();
  }
}