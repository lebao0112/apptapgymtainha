import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Storage {
  static const storage = FlutterSecureStorage();

  static Future<String?> getToken() async {
    return await storage.read(key: "jwtToken");
  }

  // To delete the token (e.g., on logout)
  static Future<void> deleteToken() async {
    await storage.delete(key: "jwtToken");
  }
}