import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:doan_tapgymtainha/service/api_config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:doan_tapgymtainha/model/user.dart';
import 'package:http/http.dart' as http;

import '../cache/user_profile_cache.dart';
import '../shared/storage.dart';

class ApiUserService {
  static const String baseUrl = ApiConfig.baseUrl;
  static const storage = FlutterSecureStorage();

  static Future<String?> getToken() async {
    return await storage.read(key: "jwtToken");
  }

  static Future<void> deleteToken() async {
    await storage.delete(key: "jwtToken");
  }

  static Future<User> fetchSomeOneProfile(String id) async{
    String? token = await getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/user/someone-profile/${id}'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      return User.fromJson(data["userProfile"]);
    } else {
      throw Exception('Failed to load user profile');
    }
  }

  static Future<User> fetchUserProfile() async {
    String? token = await getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user/profile'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return User.fromJson(data['user']);
      } else {
        throw Exception('Failed to fetch user profile');
      }
    } catch (error) {
      print('Error in fetchUserProfile: $error');
      throw error;
    }
  }


  // static Future<Map<String, dynamic>> fetchUserProfile() async {
  //   String? token = await getToken();
  //
  //   if (token == null) {
  //     throw Exception('Token not found');
  //   }
  //
  //   // Kiểm tra kết nối internet
  //   var connectivityResult = await Connectivity().checkConnectivity();
  //   bool isOnline = connectivityResult.contains(ConnectivityResult.none);
  //   // bool isOnline = false;
  //   print(isOnline);
  //
  //   // Nếu không có internet, lấy dữ liệu từ cache
  //
  //   final cachedData = UserProfileCache.getUserProfile();
  //   if (cachedData != null) {
  //     return cachedData;
  //   }
  //
  //   // Nếu có internet, lấy dữ liệu từ API
  //   final response = await http.get(
  //     Uri.parse('$baseUrl/user/profile'),
  //     headers: {
  //       "Content-Type": "application/json",
  //       "Authorization": "Bearer $token",
  //     },
  //   );
  //   print('Status Code: ${response.statusCode}');
  //   print('Response Body: ${response.body}');
  //   if (response.statusCode == 200) {
  //     final profileData = jsonDecode(response.body);
  //
  //     // Lưu dữ liệu vào cache
  //     UserProfileCache.saveUserProfile(profileData);
  //
  //     return profileData;
  //   } else {
  //     throw Exception('Failed to load user profile');
  //   }
  // }

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

      //Clear dữ liệu cũ để cập nhật dữ liệu mới
      UserProfileCache.clearCache();
    } else {
      // Thất bại, có thể do lỗi từ phía server
      final errorResponse = jsonDecode(response.body);
      throw Exception(
          'Failed to update user name: ${errorResponse['message']}');
    }
  }

  static Future<void> updateProfile(
      String? name,
      String? email,
      String? height,
      String? weight,
      String? gender,
      String? dateOfBirth,
      String? avatarPath,
      ) async {
    try {
      String? token = await Storage.getToken();

      final uri = Uri.parse('${baseUrl}/user/update-profile');
      final request = http.MultipartRequest('PUT', uri);

      // Đính kèm các trường
      if (name != null) request.fields['name'] = name;
      if (email != null) request.fields['email'] = email;
      if (height != null) request.fields['height'] = height;
      if (weight != null) request.fields['weight'] = weight;
      if (gender != null) request.fields['gender'] = gender;
      if (dateOfBirth != null) request.fields['dateOfBirth'] = dateOfBirth;
      request.fields['Folder'] = "avatar";

      // Đính kèm file ảnh nếu có
      if (avatarPath != null && avatarPath.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath('avatar', avatarPath));
      }

      // Đính kèm token
      request.headers['Authorization'] = 'Bearer $token';

      // Gửi yêu cầu
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        print('Cập nhật thành công: $responseBody');
      } else {
        final responseBody = await response.stream.bytesToString();
        throw Exception(
            'Failed to update profile. Status code: ${response.statusCode}, Body: $responseBody');
      }
    } on TimeoutException {
      throw Exception('Kết nối tới máy chủ bị timeout. Vui lòng thử lại sau.');
    } on http.ClientException catch (e) {
      throw Exception('Lỗi kết nối mạng: $e');
    } catch (e) {
      throw Exception('Đã xảy ra lỗi không mong muốn: $e');
    }
  }

}
