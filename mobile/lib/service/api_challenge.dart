import 'dart:convert';
import 'package:doan_tapgymtainha/service/api_config.dart';
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
}
