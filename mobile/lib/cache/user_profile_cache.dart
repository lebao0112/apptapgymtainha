import 'package:hive/hive.dart';

class UserProfileCache {
  static final Box _userProfileBox = Hive.box('userProfileBox');

  // Lưu userProfile vào cache
  static void saveUserProfile(Map<String, dynamic> userProfile) {
    _userProfileBox.put('userProfile', userProfile);
  }

  // Lấy userProfile từ cache
  static Map<String, dynamic>? getUserProfile() {
    final cachedData = _userProfileBox.get('userProfile');

    // Chuyển đổi dữ liệu nếu nó tồn tại
    if (cachedData != null && cachedData is Map) {
      return Map<String, dynamic>.from(cachedData);
    }

    return null;
    // return _userProfileBox.get('userProfile');
  }

  // Xóa cache của userProfile
  static void clearCache() {
    _userProfileBox.delete('userProfile');
  }
}
