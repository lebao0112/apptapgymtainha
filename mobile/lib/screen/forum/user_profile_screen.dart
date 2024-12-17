import 'package:doan_tapgymtainha/service/api_user_service.dart';
import 'package:flutter/material.dart';

import '../../model/user.dart';
import '../profile_screen.dart';

class UserProfileScreen extends StatefulWidget {
  final String userId;
  const UserProfileScreen({super.key, required this.userId});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late String userId = widget.userId;
  late final Future<User> user;

  @override
  void initState() {
    super.initState();
    this.user = _fetchSomeoneProfile(userId);
  }

  Future<User> _fetchSomeoneProfile(String id) async{
    return await ApiUserService.fetchSomeOneProfile(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hồ Sơ Người Dùng',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder<User>(
        future: user,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Hiển thị vòng quay khi đang tải
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Hiển thị thông báo lỗi
            return Center(
              child: Text(
                'Lỗi khi tải thông tin người dùng: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          } else if (!snapshot.hasData) {
            // Hiển thị khi không có dữ liệu
            return const Center(
              child: Text(
                'Không tìm thấy thông tin người dùng',
                style: TextStyle(color: Colors.white),
              ),
            );
          } else {
            // Hiển thị nội dung khi dữ liệu được tải thành công
            return ProfileContent(user: snapshot.data!);
          }
        },
      ),
    );
  }

}
