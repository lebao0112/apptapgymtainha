import 'package:flutter/material.dart';
import 'dashboard_screen.dart';  // Assuming this is your DashboardScreen

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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
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
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/AnhnenTapGym.png'),  // Ensure the path is correct
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Gradient overlay
          Container(
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
                            const Text(
                              'Đăng nhập',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 25),
                            // Username Field
                            TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                labelText: "Tên đăng nhập",
                                prefixIcon: const Icon(Icons.person),
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
                            const SizedBox(height: 20),
                            // Password Field
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: "Mật khẩu",
                                prefixIcon: const Icon(Icons.lock),
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
                            const SizedBox(height: 30),
                            // Login Button
                            ElevatedButton(
                              onPressed: _login,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16.0,
                                  horizontal: 50.0,
                                ),
                                backgroundColor: Colors.orangeAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                              child: const Text(
                                "Đăng nhập",
                                style: TextStyle(fontSize: 18, color: Colors.white),
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text("Hoặc đăng nhập với"),
                            const SizedBox(height: 20),
                            // Social Login Buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    // Add Google login functionality
                                  },
                                  icon: Image.asset(
                                    'assets/google.png',  // Ensure the path is correct
                                    width: 35,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                IconButton(
                                  onPressed: () {
                                    // Add Facebook login functionality
                                  },
                                  icon: Image.asset(
                                    'assets/facebook.png',  // Ensure the path is correct
                                    width: 35,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            // Register Option
                            GestureDetector(
                              onTap: () {
                                // Add "Register" functionality here
                              },
                              child: const Text(
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
