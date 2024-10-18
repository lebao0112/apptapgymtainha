import 'package:flutter/material.dart';
import 'package:doan_tapgymtainha/service/api_service.dart'; // Import service của bạn

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  late Future<Map<String, dynamic>> _userProfile;
  final double profileHeight = 144;

  @override
  void initState() {
    super.initState();
    _userProfile = ApiService.fetchUserProfile(); // Gọi API để lấy thông tin người dùng
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hồ Sơ Cá Nhân',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _userProfile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load profile'));
          } else {
            final profile = snapshot.data!['userProfile'];
            final String name = profile['Name'];
            final String email = profile['Email'];
            final int height = profile['Height'];
            final int weight = profile['Weight'];

            return Container(
              color: Colors.black,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Avatar và tên người dùng
                  CircleAvatar(
                    radius: profileHeight / 2,
                    backgroundColor: Colors.grey.shade800, // Background color cho avatar
                    backgroundImage: NetworkImage(
                      'https://minimomonimi.com/cdn/shop/products/simple-avatar-minimomonimi-cartoonish-minimalist-01.png?v=1664979841', // Avatar của người dùng từ URL
                    ),
                  ),
                  const SizedBox(height: 8), // Khoảng cách giữa avatar và tên
                  Text(
                    name, // Tên người dùng
                    style: TextStyle(
                      color: Colors.white, // Màu chữ
                      fontSize: 18, // Kích thước chữ
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40), // Khoảng cách giữa avatar và thông tin người dùng

                  // Thông tin Tuổi, Chiều cao, Cân nặng
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: buildInfoBox('Tuổi', '28'),
                        ),
                        Expanded(
                          child: buildInfoBox('Chiều cao', '$height cm'),
                        ),
                        Expanded(
                          child: buildInfoBox('Cân nặng', '$weight kg'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildInfoBox(String label, String value) {
    return Container(
      // decoration: BoxDecoration(
      //   color: Colors.white,
      //   borderRadius: BorderRadius.circular(8), // Rounded corners
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.black.withOpacity(0.2),
      //       blurRadius: 5,
      //       offset: Offset(0, 3),
      //     ),
      //   ],
      // ),
      // padding: EdgeInsets.all(16),
      // margin: EdgeInsets.all(8),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.orange,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
