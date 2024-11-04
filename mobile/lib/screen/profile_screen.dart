import 'package:flutter/material.dart';
import 'package:doan_tapgymtainha/service/api_user_service.dart'; // Import service của bạn
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<Map<String, dynamic>> _userProfile;
  final _nameController = TextEditingController();
  final picker = ImagePicker();
  final double profileHeight = 144;

  @override
  void initState() {
    super.initState();
    _userProfile =
        ApiUserService.fetchUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hồ Sơ Cá Nhân',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _userProfile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load profile  ${snapshot.error}'));
          } else {
            final profile = snapshot.data!['userProfile'];
            final String name = profile['Name'];
            final String email = profile['Email'];
            final int height = profile['Height'];
            final int weight = profile['Weight'];
            final String dateOfBirth = profile['DateOfBirth'] ?? "";
            final String gender = profile['Gender'] ?? "unknown";
            final String? avatarUrl = profile['AvatarUrl'];
            return Container(
              color: Colors.black,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                        onPressed: () {
                          _showEditOptions(context, name);
                        },
                        icon: Icon(Icons.edit, color: Colors.grey)),
                  ),
                  CircleAvatar(
                    radius: profileHeight / 2,
                    backgroundColor: Colors.grey.shade800,
                    backgroundImage: avatarUrl == null
                        ? AssetImage("assets/default_avatar.png")
                        : NetworkImage(avatarUrl!) as ImageProvider,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        gender == 'male'
                            ? Icons.male // Icon cho nam
                            : Icons.female, // Icon cho nữ
                        color: gender == 'male'
                            ? Colors.blue
                            : Colors.pink, // Màu sắc theo giới tính
                        size: 24, // Kích thước icon
                      ),
                      Text(
                        name, // Tên người dùng
                        style: TextStyle(
                          color: Colors.white, // Màu chữ
                          fontSize: 18, // Kích thước chữ
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: buildInfoBox(
                              'Tuổi',
                              calculateAge(DateTime.parse(dateOfBirth))
                                  .toString()),
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

  int calculateAge(DateTime dateOfBirth) {
    DateTime today = DateTime.now();
    int age = today.year - dateOfBirth.year;

    if (today.month < dateOfBirth.month ||
        (today.month == dateOfBirth.month && today.day < dateOfBirth.day)) {
      age--;
    }

    return age;
  }

  void _showEditOptions(BuildContext context, String currentName) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.image),
                title: Text('Chỉnh sửa Avatar'),
                onTap: () {
                  // _editAvatarUrl(context, currenAvatarUrl);
                }, // Thay đổi avatar
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Chỉnh sửa Tên'),
                onTap: () {
                  _editName(context, currentName); // Thay đổi tên
                },
              ),
              ListTile(
                leading: Icon(Icons.close),
                title: Text('Đóng'),
                onTap: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
    );
  }

  void _editName(BuildContext context, String currentName) {
    _nameController.text = currentName; // Hiển thị tên hiện tại
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Chỉnh sửa tên'),
          content: TextField(
            controller: _nameController,
            decoration: InputDecoration(hintText: 'Nhập tên mới'),
          ),
          actions: [
            TextButton(
              child: Text('Hủy'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Lưu'),
              onPressed: () {
                // Gọi API để lưu tên mới
                ApiUserService.updateUserName(_nameController.text).then((value) {
                  // Hiển thị snackbar thông báo thành công
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Cập nhật tên thành công!'),
                      backgroundColor: Colors.green,
                    ),
                  );

                  // Đóng modal chỉnh sửa hiện tại và cả modal showEditOptions
                  Navigator.of(context).pop(); // Đóng Dialog hiện tại
                  Navigator.of(context).pop(); // Đóng Modal showEditOptions

                  // Cập nhật lại thông tin người dùng trên màn hình
                  setState(() {
                    _userProfile = ApiUserService
                        .fetchUserProfile(); // Tải lại thông tin người dùng
                  });
                }).catchError((error) {
                  // Hiển thị thông báo lỗi nếu cập nhật thất bại
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Cập nhật thất bại: $error'),
                      backgroundColor: Colors.red,
                    ),
                  );
                });
              },
            ),
          ],
        );
      },
    );
  }

  // Future<void> _editAvatar() async {
  //   final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     // Gọi API để tải ảnh lên Cloudinary và cập nhật avatarUrl
  //     final uploadedUrl =
  //         await ApiService.uploadAvatarToCloudinary(pickedFile.path);
  //     setState(() {
  //       avatarUrl = uploadedUrl; // Cập nhật ảnh đại diện
  //     });
  //     // Cập nhật avatarUrl vào database
  //     await ApiService.updateAvatarUrl(uploadedUrl);
  //   }
  // }

  Widget buildInfoBox(String label, String value) {
    return Container(
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
