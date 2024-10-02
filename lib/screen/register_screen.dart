import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();
  int _currentPage = 0;

  String? _gender;
  String? _focusArea;
  String? _goal;
  String? _height;
  String? _weight;
  String? _exerciseFrequency;
  String? _exerciseTime;
  String? _motivation;
  String? _expectation;
  String _username = '';
  String _email = '';
  String _password = '';

  void _nextPage() {
    if ((_currentPage == 0 && _gender == null) ||
        (_currentPage == 1 && _focusArea == null) ||
        (_currentPage == 2 && _goal == null) ||
        (_currentPage == 3 && _height == null) ||
        (_currentPage == 4 && _weight == null) ||
        (_currentPage == 5 && _exerciseFrequency == null) ||
        (_currentPage == 6 && _exerciseTime == null) ||
        (_currentPage == 7 && _motivation == null) ||
        (_currentPage == 8 && _expectation == null) ||
        (_currentPage == 9 && (_username.isEmpty || _email.isEmpty || _password.isEmpty))) { // Thêm kiểm tra cho trang đăng ký
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Vui lòng nhập đầy đủ thông tin trước khi tiếp tục.'),
        ),
      );
    } else {
      if (_currentPage < 9) { // Cập nhật điều kiện kiểm tra
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        setState(() {
          _currentPage++;
        });
      } else {
        _register();
      }
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentPage--;
      });
    }
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 10),
              Text('Đăng ký thành công'),
            ],
          ),
          backgroundColor: Colors.greenAccent,
        ),
      );
    }
  }

  Widget _buildOption(String title, String? groupValue, ValueChanged<String?> onChanged) {
    bool isSelected = title == groupValue;
    return GestureDetector(
      onTap: () => onChanged(title),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.lightBlueAccent : Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey,
            width: 2.0,
          ),
        ),
        padding: EdgeInsets.all(16.0),
        margin: EdgeInsets.symmetric(vertical: 8.0),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng ký'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          _buildGenderPage(),
          _buildFocusAreaPage(),
          _buildGoalPage(),
          _buildHeightPage(),
          _buildWeightPage(),
          _buildExerciseFrequencyPage(),
          _buildExerciseTimePage(),
          _buildMotivationPage(),
          _buildExpectationPage(),
          _buildRegistrationPage()
        ],
      ),
    );
  }

  Widget _buildGenderPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Giới tính của bạn là gì?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _buildOption('Nam', _gender, (value) {
              setState(() {
                _gender = value;
              });
            }),
            _buildOption('Nữ', _gender, (value) {
              setState(() {
                _gender = value;
              });
            }),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _previousPage,
                  child: Text(
                    'Quay lại',
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                    backgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _nextPage,
                  child: Text(
                    'Tiếp theo',
                    style: TextStyle(color: Colors.white, fontSize: 17), // Đặt màu chữ thành trắng
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                    backgroundColor: Colors.orangeAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFocusAreaPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Chọn vùng tập trung để tập:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _buildOption('Toàn thân', _focusArea, (value) {
              setState(() {
                _focusArea = value;
              });
            }),
            _buildOption('Cánh tay', _focusArea, (value) {
              setState(() {
                _focusArea = value;
              });
            }),
            _buildOption('Ngực', _focusArea, (value) {
              setState(() {
                _focusArea = value;
              });
            }),
            _buildOption('Bụng', _focusArea, (value) {
              setState(() {
                _focusArea = value;
              });
            }),
            _buildOption('Chân', _focusArea, (value) {
              setState(() {
                _focusArea = value;
              });
            }),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _previousPage,
                  child: Text(
                    'Quay lại',
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                    backgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _nextPage,
                  child: Text(
                    'Tiếp theo',
                    style: TextStyle(color: Colors.white, fontSize: 17), // Đặt màu chữ thành trắng
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                    backgroundColor: Colors.orangeAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Mục tiêu chính của bạn là gì?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _buildOption('Giảm cân', _goal, (value) {
              setState(() {
                _goal = value;
              });
            }),
            _buildOption('Xây dựng cơ bắp', _goal, (value) {
              setState(() {
                _goal = value;
              });
            }),
            _buildOption('Duy trì dáng', _goal, (value) {
              setState(() {
                _goal = value;
              });
            }),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _previousPage,
                  child: Text(
                    'Quay lại',
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                    backgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _nextPage,
                  child: Text(
                    'Tiếp theo',
                    style: TextStyle(color: Colors.white, fontSize: 17), // Đặt màu chữ thành trắng
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                    backgroundColor: Colors.orangeAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeightPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Chiều cao của bạn (cm):',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _buildOption("160 cm", _height, (value) {
              setState(() {
                _height = value;
              });
            }),
            _buildOption("170 cm", _height, (value) {
              setState(() {
                _height = value;
              });
            }),
            _buildOption("180 cm", _height, (value) {
              setState(() {
                _height = value;
              });
            }),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _previousPage,
                  child: Text(
                    'Quay lại',
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                    backgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _nextPage,
                  child: Text(
                    'Tiếp theo',
                    style: TextStyle(color: Colors.white, fontSize: 17), // Đặt màu chữ thành trắng
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                    backgroundColor: Colors.orangeAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeightPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Cân nặng của bạn (kg):',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _buildOption("50 kg", _weight, (value) {
              setState(() {
                _weight = value;
              });
            }),
            _buildOption("60 kg", _weight, (value) {
              setState(() {
                _weight = value;
              });
            }),
            _buildOption("70 kg", _weight, (value) {
              setState(() {
                _weight = value;
              });
            }),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _previousPage,
                  child: Text(
                    'Quay lại',
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                    backgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _nextPage,
                  child: Text(
                    'Tiếp theo',
                    style: TextStyle(color: Colors.white, fontSize: 17), // Đặt màu chữ thành trắng
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                    backgroundColor: Colors.orangeAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseFrequencyPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Tần suất tập luyện của bạn là bao nhiêu?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _buildOption('Hàng ngày', _exerciseFrequency, (value) {
              setState(() {
                _exerciseFrequency = value;
              });
            }),
            _buildOption('3-4 lần một tuần', _exerciseFrequency, (value) {
              setState(() {
                _exerciseFrequency = value;
              });
            }),
            _buildOption('1-2 lần một tuần', _exerciseFrequency, (value) {
              setState(() {
                _exerciseFrequency = value;
              });
            }),
            _buildOption('Thỉnh thoảng', _exerciseFrequency, (value) {
              setState(() {
                _exerciseFrequency = value;
              });
            }),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _previousPage,
                  child: Text(
                    'Quay lại',
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                    backgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _nextPage,
                  child: Text(
                    'Tiếp theo',
                    style: TextStyle(color: Colors.white, fontSize: 17), // Đặt màu chữ thành trắng
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                    backgroundColor: Colors.orangeAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseTimePage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Thời gian tập luyện mỗi lần của bạn là bao lâu (phút)?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _buildOption("30 phút", _exerciseTime, (value) {
              setState(() {
                _exerciseTime = value;
              });
            }),
            _buildOption("45 phút", _exerciseTime, (value) {
              setState(() {
                _exerciseTime = value;
              });
            }),
            _buildOption("60 phút", _exerciseTime, (value) {
              setState(() {
                _exerciseTime = value;
              });
            }),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _previousPage,
                  child: Text(
                    'Quay lại',
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                    backgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _nextPage,
                  child: Text(
                    'Tiếp theo',
                    style: TextStyle(color: Colors.white, fontSize: 17), // Đặt màu chữ thành trắng
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                    backgroundColor: Colors.orangeAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMotivationPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Động lực của bạn để tập luyện là gì?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _buildOption("Cải thiện sức khỏe", _motivation, (value) {
              setState(() {
                _motivation = value;
              });
            }),
            _buildOption("Giảm cân", _motivation, (value) {
              setState(() {
                _motivation = value;
              });
            }),
            _buildOption("Tăng cường sức mạnh", _motivation, (value) {
              setState(() {
                _motivation = value;
              });
            }),
            _buildOption("Giải tỏa stress", _motivation, (value) {
              setState(() {
                _motivation = value;
              });
            }),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _previousPage,
                  child: Text(
                    'Quay lại',
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                    backgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _nextPage,
                  child: Text(
                    'Tiếp theo',
                    style: TextStyle(color: Colors.white, fontSize: 17), // Đặt màu chữ thành trắng
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                    backgroundColor: Colors.orangeAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpectationPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Kỳ vọng của bạn về kết quả tập luyện là gì?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _buildOption("Tăng cường sức khỏe", _expectation, (value) {
              setState(() {
                _expectation = value;
              });
            }),
            _buildOption("Thay đổi hình thể", _expectation, (value) {
              setState(() {
                _expectation = value;
              });
            }),
            _buildOption("Cải thiện sức bền", _expectation, (value) {
              setState(() {
                _expectation = value;
              });
            }),
            _buildOption("Tăng cường sức mạnh", _expectation, (value) {
              setState(() {
                _expectation = value;
              });
            }),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _previousPage,
                  child: Text(
                    'Quay lại',
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                    backgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _nextPage,
                  child: Text(
                    'Tiếp theo',
                    style: TextStyle(color: Colors.white, fontSize: 17), // Đặt màu chữ thành trắng
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                    backgroundColor: Colors.orangeAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildRegistrationPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Đăng ký tài khoản',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Username',
              ),
              onChanged: (value) {
                _username = value; // Gán giá trị cho _username
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
              onChanged: (value) {
                _email = value; // Gán giá trị cho _email
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Mật khẩu',
              ),
              onChanged: (value) {
                _password = value; // Gán giá trị cho _password
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nhập lại mật khẩu',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Vui lòng nhập lại mật khẩu.';
                } else if (value != _password) {
                  return 'Mật khẩu không khớp.';
                }
                return null;
              },
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Kiểm tra trạng thái form trước khi đăng ký
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Đăng ký thành công!')),
                );
              },
              child: Text('Đăng ký'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                backgroundColor: Colors.orangeAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
