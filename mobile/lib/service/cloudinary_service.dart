import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CloudinaryService {
  static const String cloudinaryUrl =
      "https://api.cloudinary.com/v1_1/YOUR_CLOUD_NAME/image/upload";
  static const String cloudinaryPreset =
      "YOUR_UPLOAD_PRESET"; // Lấy từ Cloudinary settings

  static Future<String?> uploadImageToCloudinary(File imageFile) async {
    final request = http.MultipartRequest('POST', Uri.parse(cloudinaryUrl));
    request.fields['upload_preset'] = cloudinaryPreset;
    request.files
        .add(await http.MultipartFile.fromPath('file', imageFile.path));

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await http.Response.fromStream(response);
        final jsonResponse = jsonDecode(responseData.body);
        return jsonResponse['secure_url']; // URL của ảnh sau khi tải lên
      } else {
        throw Exception('Failed to upload image to Cloudinary');
      }
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }
}
