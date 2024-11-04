import 'dart:convert';
import 'package:doan_tapgymtainha/service/api_config.dart';
import 'package:doan_tapgymtainha/shared/storage.dart';
import 'package:http/http.dart' as http;

class ApiChallenge {
  static const String baseUrl = ApiConfig.baseUrl; // Your backend URL

  static Future<List<dynamic>> fetchChallenges() async {
    final response = await http.get(
      Uri.parse('$baseUrl/challenge/challenge-list'),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Trả về danh sách các bài tập
    } else {
      throw Exception('Failed to load exercises');
    }
  }

  static Future<Map<String, dynamic>> fetchChallengeWorkoutDetails(
      String workoutId) async {

    final response = await http.get(
      Uri.parse(
          '$baseUrl/challenge/get-challenge-workouts/$workoutId'), // Update this endpoint to the new route
      headers: {
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Return the workout details
    } else {
      print('Failed to fetch workout details: ${response.statusCode}');
      throw Exception('Failed to fetch workout details');
    }
  }

  static Future<void> createChalProgress(String challengeId) async {
    String? token = await Storage.getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/chalprogress/insert-chalprogress/$challengeId'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${token}"
      },
    );

    if (response.statusCode == 201) {
      print("Challenge progress created successfully");
    } else {
      throw Exception('Failed to create challenge progress');
    }
  }

  static Future<List<dynamic>> fetchChallengeProgressData() async {
    String? token = await Storage.getToken();
    print("token trong chalprogress $token");
    final response = await http.get(
      Uri.parse(
          '$baseUrl/chalprogress/chalprogress-list'), 
      headers: {
        "Content-Type": "application/json",
         "Authorization": "Bearer $token", 
      },
      
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); 
    } else {
      print('Failed to fetch workout details: ${response.statusCode}');
      throw Exception('Failed to fetch workout details');
    }
  }


  static Future<void>  increaseChalProgress(String? chalprogressId) async {
    if(chalprogressId == null || chalprogressId.isEmpty)
      return;

    String? token = await Storage.getToken();
    print("token trong chalprogress $token");
    final response = await http.put(
      Uri.parse(
          '$baseUrl/chalprogress/increase-chalprogress/$chalprogressId'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      print('cap nhat chalprogress thanh cong');
    } else {
      print('Failed to fetch workout details: ${response.statusCode}');
      throw Exception('Failed to fetch workout details');
    }
  }
}
