import 'dart:convert';
import 'package:doan_tapgymtainha/service/api_config.dart';
import 'package:doan_tapgymtainha/shared/storage.dart';
import 'package:http/http.dart' as http;

class ApiHistory {
  static const String baseUrl = ApiConfig.baseUrl; // URL của server

  // Hàm thêm lịch sử tập luyện mới
  static Future<void> addHistory({
    required String workoutName,
    required String workoutId,
    required String totalTime,
    required int calories,
  }) async {
    String? token = await Storage.getToken();

    print("${workoutName} ${workoutId} ${totalTime}, ${calories}");
    final response = await http.post(
      Uri.parse('$baseUrl/history/add-history'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "WorkoutName": workoutName,
        "WorkoutId": workoutId,
        "Date": DateTime.now().toIso8601String(),
        "TotalTime": totalTime,
        "Calories": calories,
      }),
    );

    if (response.statusCode == 201) {
      print("History added successfully");

    } else {
      throw Exception('Failed to add history');
    }
  }

  // Hàm lấy lịch sử tập luyện của người dùng
  static Future<List<dynamic>> fetchUserHistory() async {
    String? token = await Storage.getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/history/user-history'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch user history');
    }
  }

  // Hàm xóa một lịch sử tập luyện dựa trên historyId
  static Future<void> deleteHistory(String historyId) async {
    String? token = await Storage.getToken();

    final response = await http.delete(
      Uri.parse('$baseUrl/history/delete-history/$historyId'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      print("History deleted successfully");
    } else {
      throw Exception('Failed to delete history');
    }
  }
}
