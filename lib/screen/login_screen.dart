import 'package:flutter/material.dart';
import 'package:doan_tapgymtainha/screen/dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        // dùng pushReplacement không cho quay lại màn hình trước đó.
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đăng nhập thành công'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Hình nền toàn màn hình
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/AnhnenTapGym.png'), // Hình nền gym
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            // Màn che màu gradient
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.7),
                  Colors.black.withOpacity(0.3),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    elevation: 12,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Text(
                              'Đăng nhập',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 25),
                            TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                labelText: "Tên đăng nhập",
                                prefixIcon: Icon(Icons.person),
                                filled: true,
                                fillColor: Colors.grey[200],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Vui lòng nhập tên đăng nhập';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: "Mật khẩu",
                                prefixIcon: Icon(Icons.lock),
                                filled: true,
                                fillColor: Colors.grey[200],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Vui lòng nhập mật khẩu';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 30),
                            ElevatedButton(
                              onPressed: _login,
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  vertical: 16.0,
                                  horizontal: 50.0,
                                ),
                                backgroundColor: Colors.orangeAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                              child: Text(
                                "Đăng nhập",
                                style: TextStyle(fontSize: 18, color: Colors.white),
                              ),
                            ),

                            SizedBox(height: 20),
                            Text("Hoặc đăng nhập với"),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    // Thêm chức năng đăng nhập bằng Google
                                  },
                                  icon: Image.asset(
                                    'assets/google.png', // Đường dẫn đến icon Google
                                    width: 35,
                                  ),
                                ),
                                SizedBox(width: 20),
                                IconButton(
                                  onPressed: () {
                                    // Thêm chức năng đăng nhập bằng Facebook
                                  },
                                  icon: Image.asset(
                                    'assets/facebook.png', // Đường dẫn đến icon Facebook
                                    width: 35,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            GestureDetector(
                              onTap: () {
                                // Thêm chức năng "Đăng ký" tại đây
                              },
                              child: Text(
                                "Chưa có tài khoản? Đăng ký ngay",
                                style: TextStyle(
                                  color: Colors.orangeAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
