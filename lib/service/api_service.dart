import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://192.168.31.218:3000"; // Your backend URL

  // Updated method to include height and weight
  static Future<Map<String, dynamic>> registerUser(String name, String email, String password, double height, double weight) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user/register'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'Name': name,
        'Email': email,
        'Password': password,
        'Height': height,  // Send height
        'Weight': weight   // Send weight
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to register user');
    }
  }

  static Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user/login'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'Email': email,
        'Password': password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Login failed');
    }
  }

  // Fetch workouts for a specific user
  static Future<List<dynamic>> fetchUserWorkouts(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/workout/user-workouts/$userId'),  // Đảm bảo userId được truyền đúng vào API
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
  static Future<void> addWorkout(String userId, Map<String, dynamic> workoutData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/workout/insert-workout/$userId'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(workoutData),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add workout');
    }
  }
}
