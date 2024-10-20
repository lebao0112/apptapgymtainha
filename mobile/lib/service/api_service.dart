import 'dart:convert';
import 'package:doan_tapgymtainha/service/api_config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = ApiConfig.baseUrl; // Your backend URL
  static const storage = FlutterSecureStorage(); // Tạo storage để đứa token

  // Updated method to include height and weight
  static Future<Map<String, dynamic>> registerUser(
      String name,
      String email,
      String password,
      double height,
      double weight,
      DateTime? dateOfBirth,
      String? gender) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user/register'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'Name': name,
        'Email': email,
        'Password': password,
        'Height': height, // Send height
        'Weight': weight,
        'DateOfBirth': dateOfBirth.toString(),
        'Gender': gender // Send weight
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to register user');
    }
  }

  static Future<Map<String, dynamic>> loginUser(
      String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user/login'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'Email': email,
        'Password': password,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      // Store the token in secure storage
      await storage.write(key: "jwtToken", value: data["token"]);

      return data;
    } else {
      throw Exception('Login failed');
    }
  }

  static Future<void> logout() async {
    deleteToken();
  }

  // To retrieve the token
  static Future<String?> getToken() async {
    return await storage.read(key: "jwtToken");
  }

  // To delete the token (e.g., on logout)
  static Future<void> deleteToken() async {
    await storage.delete(key: "jwtToken");
  }

  // static Future<Map<String, dynamic>> loginUser(
  //     String email, String password) async {
  //   final response = await http.post(
  //     Uri.parse('$baseUrl/user/login'),
  //     headers: {"Content-Type": "application/json"},
  //     body: jsonEncode({
  //       'Email': email,
  //       'Password': password,
  //     }),
  //   );

  //   if (response.statusCode == 200) {
  //     return jsonDecode(response.body);
  //   } else {
  //     throw Exception('Login failed');
  //   }
  // }

  // Fetch workouts for a specific user
  static Future<List<dynamic>> fetchUserWorkouts(String userId) async {
    final response = await http.get(
      Uri.parse(
          '$baseUrl/workout/user-workouts/$userId'), // Đảm bảo userId được truyền đúng vào API
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final List<dynamic> workouts = jsonDecode(response.body);
      return workouts;
    } else {
      throw Exception('Failed to load workouts');
    }
  }

  // Method to add a workout for a specific user
  static Future<void> addWorkout(
      String userId, Map<String, dynamic> workoutData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/workout/insert-workout/$userId'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(workoutData),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add workout');
    }
  }

  //code exercise
  static Future<List<dynamic>> fetchExercises() async {
    final response = await http.get(
      Uri.parse('$baseUrl/exercise/exercise-list'),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Trả về danh sách các bài tập
    } else {
      throw Exception('Failed to load exercises');
    }
  }

  static Future<Map<String, dynamic>> fetchUserProfile() async {
    // Lấy JWT token từ storage
    String? token = await storage.read(key: 'jwtToken');

    if (token == null) {
      throw Exception('Token not found');
    }

    // Gửi yêu cầu tới server để lấy thông tin người dùng
    final response = await http.get(
      Uri.parse('$baseUrl/user/profile'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token", // Gửi token qua header
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load user profile');
    }
  }

  static Future<void> updateUserName(String newName) async {
    String? token = await storage.read(key: 'jwtToken');

    if (token == null) {
      throw Exception('Token not found');
    }

    // Gửi yêu cầu tới server để cập nhật tên người dùng
    final response = await http.put(
      Uri.parse('$baseUrl/user/update-username'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token", // Gửi token qua header
      },
      body: jsonEncode({
        'newName': newName,
      }),
    );

    // Kiểm tra phản hồi từ server
    if (response.statusCode == 200) {
      // Thành công
      print('User name updated successfully');
    } else {
      // Thất bại, có thể do lỗi từ phía server
      final errorResponse = jsonDecode(response.body);
      throw Exception(
          'Failed to update user name: ${errorResponse['message']}');
    }
  }
}
