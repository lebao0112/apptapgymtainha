import 'package:flutter/material.dart';
import 'login_screen.dart'; // Import the LoginScreen
import '../../service/api_service.dart'; // Import the API service for backend calls
import 'package:scroll_date_picker/scroll_date_picker.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String? _selectedGender;

  void _register() async {
    if (_formKey.currentState!.validate()) {
      try {
        final result = await ApiService.registerUser(
          _nameController.text,
          _emailController.text,
          _passwordController.text,
          double.parse(_heightController.text),
          double.parse(_weightController.text),
          _selectedDate,
          _selectedGender,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đăng ký thành công!'),
            backgroundColor: Colors.greenAccent,
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đăng ký thất bại: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  void _showDatePickerModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        DateTime tempPickedDate = _selectedDate;

        return Container(
          padding: const EdgeInsets.all(16.0),
          height: 300,
          child: Column(
            children: [
              Expanded(
                child: ScrollDatePicker(
                  selectedDate: tempPickedDate,
                  minimumDate: DateTime(1900),
                  maximumDate: DateTime(2100),
                  locale: Locale('vi'),
                  onDateTimeChanged: (DateTime value) {
                    tempPickedDate = value;
                  },
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedDate = tempPickedDate;
                  });

                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      },
    );
  }

  String? _validateDateOfBirth() {
    if (_selectedDate == null) {
      return 'Vui lòng chọn ngày sinh.';
    }
    return null;
  }

  // Hàm kiểm tra nếu giới tính chưa được chọn
  String? _validateGender() {
    if (_selectedGender == null) {
      return 'Vui lòng chọn giới tính.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Đăng ký'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Đăng ký tài khoản',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập tên đăng nhập.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập email.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Mật khẩu',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập mật khẩu.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _heightController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Chiều cao (cm)',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập chiều cao.';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Chiều cao phải là một số hợp lệ.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _weightController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Cân nặng (kg)',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập cân nặng.';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Cân nặng phải là một số hợp lệ.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    // Nút chọn ngày sinh
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          _showDatePickerModal(
                              context); // Hiển thị modal khi nhấn vào nút
                        },
                        child: Container(
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.purple),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Text(
                            _selectedDate == null
                                ? 'Chọn ngày sinh'
                                : 'Ngày sinh: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                        width:
                            20), // Khoảng cách giữa nút chọn ngày sinh và checkbox giới tính
                    // Lựa chọn giới tính
                    Expanded(
                      child: Row(
                        children: [
                          Radio<String>(
                            value: 'male',
                            groupValue: _selectedGender,
                            onChanged: (value) {
                              setState(() {
                                _selectedGender = value;
                              });
                            },
                          ),
                          const Text('Nam'),
                          Radio<String>(
                            value: 'female',
                            groupValue: _selectedGender,
                            onChanged: (value) {
                              setState(() {
                                _selectedGender = value;
                              });
                            },
                          ),
                          const Text('Nữ'),
                        ],
                      ),
                    ),
                  ],
                ),
                if (_validateDateOfBirth() != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _validateDateOfBirth()!,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                if (_validateGender() != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _validateGender()!,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _register,
                  child: const Text('Đăng ký'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 15.0),
                    backgroundColor: Colors.orangeAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
