import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:doan_tapgymtainha/service/api_config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;

import '../cache/user_profile_cache.dart';

class ApiService {
  static const String baseUrl = ApiConfig.baseUrl; // Your backend URL
  static const storage = FlutterSecureStorage();// Tạo storage để đứa token
  // static final UserProfileCache _cache = UserProfileCache();
  // Updated method to include height and weight
  static Future<Map<String, dynamic>> registerUser(String name, String email,
      String password, double height, double weight, DateTime? dateOfBirth,
      String? gender) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user/register'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'Name': name,
        'Email': email,
        'Password': password,
        'Height': height, // Send height
        'Weight': weight,// Send weight
        'DateOfBirth': dateOfBirth.toString(),
        'Gender': gender
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

  static Future<Map<String, dynamic>> loginWithGoogle(String email, String name, String googleId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user/google-login'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'Email': email,
        'Name': name,
        'googleId': googleId,
      }),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      // Store the token in secure storage
      await storage.write(key: "jwtToken", value: data["token"]);

      return data;
    } else {
      throw Exception('Google login failed');
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

  static Future<List<dynamic>> fetchUserWorkouts() async {
    String? token = await getToken();

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/workout/user-workouts'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
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

  // Thêm bài tập cho người dùng (JWT token sẽ được tự động thêm vào header)
  static Future<void> addWorkoutWithToken(
      Map<String, dynamic> workoutData) async {
    String? token = await getToken(); // Lấy token từ storage

    if (token == null) {
      throw Exception('Token not found');
    }
    print('Workout Data: ${jsonEncode(workoutData)}');
    final response = await http.post(
      Uri.parse(
          '$baseUrl/workout/insert-workout'), // Đảm bảo đường dẫn chính xác
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token", // Đính kèm token trong header
      },
      body: jsonEncode(workoutData), // Gửi dữ liệu bài tập
    );

    // In ra status code và response body để debug
    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode != 201) {
      throw Exception('Failed to add workout: ${response.body}');
    }
  }

  static Future<void> deleteWorkoutWithToken(String workoutId) async {
    String? token = await getToken(); // Lấy token từ storage

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.delete(
      Uri.parse(
          '$baseUrl/workout/delete-workout/${workoutId}'), // Đảm bảo đường dẫn chính xác
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token", //
      },

    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add workout: ${response.body}');
    }
  }


  static Future<Map<String, dynamic>> fetchWorkoutDetails(
      String workoutId) async {
    String? token = await getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse(
          '$baseUrl/workout/workout/$workoutId'), // Update this endpoint to the new route
      headers: {
        "Content-Type": "application/json",
        "Authorization":
            "Bearer $token", // Ensure the token is passed correctly
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Return the workout details
    } else {
      print('Failed to fetch workout details: ${response.statusCode}');
      throw Exception('Failed to fetch workout details');
    }
  }

  static Future<Map<String, dynamic>> fetchWorkoutDetailsAvailable(
      String workoutId) async {
    String? token = await getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse(
          '$baseUrl/workout/workout-available/$workoutId'), // Update this endpoint to the new route
      headers: {
        "Content-Type": "application/json",
        "Authorization":
        "Bearer $token", // Ensure the token is passed correctly
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Return the workout details
    } else {
      print('Failed to fetch workout details: ${response.statusCode}');
      throw Exception('Failed to fetch workout details');
    }
  }
  static Future<void> updateUserName(String newName) async {
    String? token = await getToken();
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


  static Future<void> sendProgressData(Map<String, dynamic> data) async {
    String? token = await getToken();  // Retrieve the user's token if necessary

    final response = await http.post(
      Uri.parse('$baseUrl/progress/update-progress'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",  // If using JWT
      },
      body: jsonEncode(data),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send progress data');
    }
  }

  static Future<Map<String, dynamic>> addFoodToDiary(Map<String, dynamic> foodItem) async {
    String? token = await getToken();
    if (token == null) {
      throw Exception('Token not found');
    }
    print('foodItem: $foodItem');  // Kiểm tra xem dữ liệu có đúng không

    final response = await http.post(
      Uri.parse('$baseUrl/food-diary/create-or-update'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        'foodItem': foodItem,  // Đảm bảo foodItem chứa các trường như name, calories, fat, carbs, protein
      }),
    );
    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to add food to diary');
    }
  }


  static Future<Map<String, dynamic>> getFoodDiaryByDate(String date) async {
    String? token = await getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/food-diary/get/$date'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      // Nếu không tìm thấy nhật ký thực phẩm cho ngày này
      return {};
    } else {
      throw Exception('Failed to fetch food diary');
    }
  }

}
