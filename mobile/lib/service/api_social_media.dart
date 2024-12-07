import 'dart:convert';
import 'package:doan_tapgymtainha/service/api_config.dart';
import 'package:doan_tapgymtainha/shared/storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'dart:io';

import '../model/comment.dart';


class ApiSocialMedia {
  static const String baseUrl = ApiConfig.baseUrl;



  static Future<dynamic> fetchPosts(int page) async {
    String? token = await Storage.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/post/get-posts?page=${page}'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch posts');
    }
  }

  static Future<bool> createPost({
    required String content,
    required String mediaType,
    List<File>? files,
  }) async {
    String? token = await Storage.getToken();
    final String url = '${baseUrl}/post/create-post';

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url))
        ..headers['Authorization'] = 'Bearer $token'
        ..fields['Content'] = content
        ..fields['MediaType'] = mediaType
        ..fields['Folder'] = "post";

      // Thêm file vào multipart request nếu có
      if (files != null && files.isNotEmpty) {
        for (var file in files) {
          request.files.add(await http.MultipartFile.fromPath(
            'files',
            file.path,
          ));
        }
      }

      // Gửi request
      var response = await request.send();

      // Xử lý response
      if (response.statusCode == 201) {
        var responseData = await http.Response.fromStream(response);
        var responseBody = jsonDecode(responseData.body);
        return true;
      } else {
        var responseData = await http.Response.fromStream(response);
        var error = jsonDecode(responseData.body);
        print('Failed to create post: ${error['message']}');
        return false;
      }
    } catch (e) {
      print('Error creating post: $e');
      return false;
    }
  }

  static Future<bool> checkIfUserLiked(String postId, String? commentId) async{
    String? token = await Storage.getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/like/check-like'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "postId": postId,
        "commentId": commentId
      })
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["isLiked"];
    } else {
      throw Exception('Failed to check like');
    }
  }

  static Future<bool> toggleLike(String postId, String? commentId) async{
    String? token = await Storage.getToken();

    final response = await http.put(
        Uri.parse('$baseUrl/like/like-post'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "postId": postId,
          "commentId": commentId
        })
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<CommentResponse> fetchCommentsForPost(String postId) async {
    String? token = await Storage.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/comment/get-comments-by-post/${postId}'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      // Ánh xạ JSON thành CommentResponse
      return CommentResponse.fromJson(data);
    } else {
      throw Exception('Failed to fetch comments for post');
    }
  }

  static Future<bool> sendComment({
    required String postId,
    required String content,
    String? parentId,
  }) async {
    String? token = await Storage.getToken();
    final String url = '$baseUrl/comment/create-comment';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "PostId": postId,
          "Content": content,
          "ParentId": parentId,
        }),
      );

      if (response.statusCode == 201) {
        // Bình luận được tạo thành công
        return true;
      } else {
        // Thất bại, in thông báo lỗi từ API
        final errorData = jsonDecode(response.body);
        print("Failed to send comment: ${errorData['message']}");
        return false;
      }
    } catch (error) {
      print("Error sending comment: $error");
      return false;
    }
  }

  static Future<bool> sendReplyComment({
    required String postId,
    required String content,
    required String parentId,
  }) async {
    String? token = await Storage.getToken();
    final String url = '$baseUrl/comment/create-comment';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "PostId": postId,
          "Content": content,
          "ParentId": parentId,
        }),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        final errorData = jsonDecode(response.body);
        print("Failed to send reply comment: ${errorData['message']}");
        return false;
      }
    } catch (error) {
      print("Error sending reply comment: $error");
      return false;
    }
  }

}