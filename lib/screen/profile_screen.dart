import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Dữ liệu mẫu cho người dùng
  String userName = 'Nguyễn Văn A';
  String email = 'nguyenvana@example.com';
  String phoneNumber = '0123456789';
  File? _avatarImage;

  final picker = ImagePicker();

  // Hàm chọn ảnh từ thư viện
  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _avatarImage = File(pickedFile.path);
      }
    });
  }

  // Hàm để mở hộp thoại chỉnh sửa thông tin người dùng
  Future<void> _editProfileField(String field, String currentValue, Function(String) onSave) async {
    TextEditingController controller = TextEditingController(text: currentValue);
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],  // Nền của dialog
          title: Text(
            'Chỉnh sửa $field',
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: controller,
            style: TextStyle(color: Colors.white),  // Màu chữ trong textfield
            decoration: InputDecoration(
              hintText: 'Nhập $field mới',
              hintStyle: TextStyle(color: Colors.grey),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Hủy', style: TextStyle(color: Colors.blue)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Lưu', style: TextStyle(color: Colors.blue)),
              onPressed: () {
                onSave(controller.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HỒ SƠ CÁ NHÂN', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black,  // Màu nền của AppBar
      ),
      body: Container(
        color: Colors.black,  // Màu nền đen
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            // Avatar người dùng
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _avatarImage == null
                    ? AssetImage('assets/avatar_placeholder.png') // Avatar mặc định
                    : FileImage(_avatarImage!) as ImageProvider,
              ),
            ),
            SizedBox(height: 20),
            // Thông tin người dùng với icon chỉnh sửa
            _buildProfileField('Tên tài khoản', userName, (newName) {
              setState(() {
                userName = newName;
              });
            }),
            _buildProfileField('Email', email, (newEmail) {
              setState(() {
                email = newEmail;
              });
            }),
            _buildProfileField('Số điện thoại', phoneNumber, (newPhoneNumber) {
              setState(() {
                phoneNumber = newPhoneNumber;
              });
            }),
          ],
        ),
      ),
    );
  }

  // Widget xây dựng trường thông tin người dùng với icon chỉnh sửa
  Widget _buildProfileField(String field, String value, Function(String) onSave) {
    return ListTile(
      title: Text(
        field,
        style: TextStyle(color: Colors.white),  // Màu chữ trắng
      ),
      subtitle: Text(
        value,
        style: TextStyle(color: Colors.grey),  // Màu chữ của giá trị
      ),
      trailing: IconButton(
        icon: Icon(Icons.edit, color: Colors.blue),  // Màu của icon chỉnh sửa
        onPressed: () {
          _editProfileField(field, value, onSave);
        },
      ),
    );
  }
}
