import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:doan_tapgymtainha/provider/user_provider.dart';
import 'package:doan_tapgymtainha/model/user.dart';

import '../provider/theme_provider.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final User? user = userProvider.user;
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Hồ Sơ Cá Nhân',
          style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
        ),
      ),
      body: userProvider.user == null && userProvider.isLoading
          ? Center(
        child: CircularProgressIndicator(), // Hiển thị khi đang tải dữ liệu
      )
          : user == null
          ? Center(
        child: Text(
          'Không tìm thấy thông tin người dùng',
          style: TextStyle(color: Colors.white),
        ),
      )
          : ProfileContent(user: user),
    );
  }
}

class ProfileContent extends StatelessWidget {
  final User user;

  const ProfileContent({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final profileHeight = 144.0;

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (user.id == userProvider.user!.id) Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
              onPressed: () {
                _showEditOptions(context, userProvider ,user.name ?? '');
              },
              icon: Icon(Icons.edit, color: Colors.grey),
            ),
          ),


          CircleAvatar(
            radius: profileHeight / 2,
            backgroundColor: Colors.grey.shade800,
            backgroundImage: (user.avatarUrl != null && user.avatarUrl!.isNotEmpty)
                ? NetworkImage(user.avatarUrl!)
                : AssetImage("assets/default_avatar.png") as ImageProvider,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                user.gender == 'male' ? Icons.male : Icons.female,
                color: user.gender == 'male' ? Colors.blue : Colors.pink,
                size: 24,
              ),
              Text(
                user.name ?? 'Tên không xác định',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                  fontSize: 18,
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
                    calculateAge(user.dateOfBirth).toString(),
                  ),
                ),
                Expanded(
                  child: buildInfoBox('Chiều cao', '${user.height ?? 'N/A'} cm'),
                ),
                Expanded(
                  child: buildInfoBox('Cân nặng', '${user.weight ?? 'N/A'} kg'),
                ),
              ],
            ),
          ),
          Column(

          )
        ],
      ),
    );
  }

  int calculateAge(DateTime? dateOfBirth) {
    if (dateOfBirth == null) return 0;
    DateTime today = DateTime.now();
    int age = today.year - dateOfBirth.year;
    if (today.month < dateOfBirth.month ||
        (today.month == dateOfBirth.month && today.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }

  void _showEditOptions(BuildContext context, UserProvider userProvider, String currentName) {
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
                  Navigator.of(context).pop(); // Đóng modal
                  _editAvatar(context, userProvider);
                },
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Chỉnh sửa Tên'),
                onTap: () {
                  Navigator.of(context).pop(); // Đóng modal
                  _editName(context, userProvider, currentName); // Hàm chỉnh sửa tên
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

  void _editName(BuildContext context,UserProvider userProvider, String currentName) {
    final _nameController = TextEditingController(text: currentName);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Chỉnh sửa tên'),
          content: TextField(
            controller: _nameController,
            decoration: InputDecoration(hintText: 'Nhập tên mới'),
            autofocus: true,
          ),
          actions: [
            TextButton(
              child: Text('Hủy'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Lưu'),
              onPressed: () async {
                final newName = _nameController.text.trim();
                if (newName.isNotEmpty) {
                  try {
                    // Gọi phương thức cập nhật tên và chờ phản hồi
                    await userProvider.updateProfile(newName, "", "", "", "", "", "");

                    // Đóng dialog nếu thành công
                    Navigator.of(context).pop();

                    // Hiển thị SnackBar thông báo thành công
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Tên đã được cập nhật!', style: TextStyle(color: Colors.white)),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } catch (error) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Đã xảy ra lỗi: $error', style: TextStyle(color: Colors.white)),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Tên không được để trống', style: TextStyle(color: Colors.white),),
                      backgroundColor: Colors.orange,
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _editAvatar(BuildContext context, UserProvider userProvider) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        cropStyle: CropStyle.circle,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1), // Crop thành hình vuông
        compressFormat: ImageCompressFormat.jpg, // Format sau khi crop
        compressQuality: 100, // Chất lượng ảnh
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cắt ảnh',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            title: 'Cắt ảnh',
          ),
        ],
      );
      if (croppedFile != null) {
        await userProvider.updateProfile("","","","","","",croppedFile.path);
      }else{
        return;
      }
      // Gọi hàm cập nhật avatar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ảnh đại diện đã được cập nhật!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Không chọn ảnh nào'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  Widget buildInfoBox(String label, String value) {
    return Column(
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
    );
  }
}
