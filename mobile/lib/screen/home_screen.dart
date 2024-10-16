import 'package:doan_tapgymtainha/screen/trainingprogram_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedSegment = 0;
  DateTime now = DateTime.now();
  int currentDay = DateTime.now().day;
  int currentMonth = DateTime.now().month;
  int currentYear = DateTime.now().year;

  final List<Widget> myContainers = [
    Container(
      margin: EdgeInsets.all(4),
      padding: EdgeInsets.all(20),
      width: 400,


      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft, // Bắt đầu từ bên trái
          end: Alignment.centerRight,   // Kết thúc ở bên phải
          colors: [
            Colors.red[600]!,  // Màu bắt đầu
            Colors.orange[400]!, // Màu kết thúc
          ],
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'THỬ THÁCH 7X4',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Bắt đầu hành trình tạo dáng cơ thể để tập trung vào tất cả các nhóm cơ và xây dựng cơ thể mơ ước của bạn trong 4 tuần!',
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {

            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.orange,
            ),
            child: Text('KHỞI ĐẦU'),
          ),
        ],
      ),
    ),
    // Thêm nhiều Container tương tự
    Container(
      margin: EdgeInsets.all(4),
      padding: EdgeInsets.all(20),
      width: 400,

      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft, // Bắt đầu từ bên trái
          end: Alignment.centerRight,   // Kết thúc ở bên phải
          colors: [
            Colors.blueAccent!,  // Màu bắt đầu
            Colors.purpleAccent!, // Màu kết thúc
          ],
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'THỬ THÁCH 5X3',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Thử thách này tập trung vào sự phát triển sức mạnh và cải thiện các kỹ năng thể chất trong 3 tuần.',
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              // Hành động khởi đầu
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.orange,
            ),
            child: Text('KHỞI ĐẦU'),
          ),
        ],
      ),
    ),
    Container(
      margin: EdgeInsets.all(4),
      padding: EdgeInsets.all(20),
      width: 400,

      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft, // Bắt đầu từ bên trái
          end: Alignment.centerRight,   // Kết thúc ở bên phải
          colors: [
            Colors.cyan!,  // Màu bắt đầu
            Colors.blueAccent!, // Màu kết thúc
          ],
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'THỬ THÁCH 30 NGÀY',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Thử thách này tập trung vào sự phát triển sức mạnh và cải thiện các kỹ năng thể chất trong 3 tuần.',
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              // Hành động khởi đầu
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.orange,
            ),
            child: Text('KHỞI ĐẦU'),
          ),
        ],
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final double carousel_width = MediaQuery.of(context).size.width * 0.8;

    return Scaffold(
      backgroundColor: Colors.black, // Nền đen
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('TẬP LUYỆN TẠI NHÀ', style: TextStyle(color: Colors.white)), // Chữ trắng
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Image(image: AssetImage('assets/fire_streak.png'), height: 45, width: 45),
                Text('10', style: TextStyle(fontSize: 24, color: Colors.white), )
              ],
            )
          ),
        ],
      ),
      body: Column(
        children: [
          // Mục tiêu hàng tuần
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mục tiêu hàng tuần',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white), // Chữ trắng
                ),
                SizedBox(height: 20),
                // Thay đổi Row thành SingleChildScrollView để có thể kéo ngang
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(30, (index) {
                      int day = index + 1;
                      return Container(
                        width: 30,
                        height: 30,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: day == currentDay && currentMonth == now.month && currentYear == now.year
                              ? Colors.orange // Đổi màu cho ngày hiện tại thành cam
                              : Colors.grey[800], // Nền xám đậm
                        ),
                        child: Text(
                          '$day',
                          style: TextStyle(
                            color: day == currentDay && currentMonth == now.month && currentYear == now.year
                                ? Colors.black // Chữ đen cho ngày hiện tại
                                : Colors.white, // Chữ trắng cho ngày thường
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Chào mừng trở lại! Hôm nay là cơ hội để bạn tỏa sáng.',
                  style: TextStyle(fontSize: 16, color: Colors.white), // Chữ trắng
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(0),
            child: CarouselSlider(
              items: [Container(
                margin: EdgeInsets.all(4),
                padding: EdgeInsets.all(20),
                width: 400,

                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft, // Bắt đầu từ bên trái
                    end: Alignment.centerRight,   // Kết thúc ở bên phải
                    colors: [
                      Colors.cyan!,  // Màu bắt đầu
                      Colors.blueAccent!, // Màu kết thúc
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'THỬ THÁCH 30 NGÀY',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Thử thách này tập trung vào sự phát triển sức mạnh và cải thiện các kỹ năng thể chất trong 3 tuần.',
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TrainingProgramScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.orange,
                      ),
                      child: Text('KHỞI ĐẦU'),
                    ),
                  ],
                ),
              ),],

              options: CarouselOptions(
                height: 250, // Chiều cao của slider
                autoPlay: false, // Tự động di chuyển
                enlargeCenterPage: false, // Không phóng to item ở giữa
                enableInfiniteScroll: true, // Không vòng lặp
                viewportFraction: 0.9,  // Mỗi trang chiếm 100% chiều rộng của viewport
              ),
            ),
          ),



          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CupertinoSegmentedControl<int>(
              children: {
                0: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Người bắt đầu', style: TextStyle(color: Colors.white)),
                ),
                1: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Trung bình', style: TextStyle(color: Colors.white)),
                ),
                2: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Nâng cao', style: TextStyle(color: Colors.white)),
                ),
              },
              onValueChanged: (int? value) {
                setState(() {
                  _selectedSegment = value ?? 0;
                });
              },
              groupValue: _selectedSegment,
              unselectedColor: Colors.grey[800], // Màu xám đậm cho segment chưa chọn
              selectedColor: Colors.orange, // Màu cam cho segment được chọn
              borderColor: Colors.orange, // Viền cam
            ),
          ),
          SizedBox(height: 20),

          // Danh sách bài tập
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: _getWorkoutItems(),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _getWorkoutItems() {
    switch (_selectedSegment) {
      case 0: // Người bắt đầu
        return [
          WorkoutItem(
            title: 'BỤNG NGƯỜI BẮT ĐẦU',
            duration: '20 PHÚT',
            exercises: '16 BÀI TẬP',
          ),
          WorkoutItem(
            title: 'NGỰC NGƯỜI BẮT ĐẦU',
            duration: '9 PHÚT',
            exercises: '11 BÀI TẬP',
          ),
        ];
      case 1: // Trung bình
        return [
          WorkoutItem(
            title: 'BỤNG TRUNG BÌNH',
            duration: '25 PHÚT',
            exercises: '20 BÀI TẬP',
          ),
          WorkoutItem(
            title: 'NGỰC TRUNG BÌNH',
            duration: '15 PHÚT',
            exercises: '12 BÀI TẬP',
          ),
        ];
      case 2: // Nâng cao
        return [
          WorkoutItem(
            title: 'BỤNG NÂNG CAO',
            duration: '30 PHÚT',
            exercises: '25 BÀI TẬP',
          ),
          WorkoutItem(
            title: 'NGỰC NÂNG CAO',
            duration: '20 PHÚT',
            exercises: '15 BÀI TẬP',
          ),
        ];
      default:
        return [];
    }
  }
}

class WorkoutItem extends StatelessWidget {
  final String title;
  final String duration;
  final String exercises;

  WorkoutItem({required this.title, required this.duration, required this.exercises});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900], // Nền xám đậm cho bài tập
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)), // Chữ trắng
            SizedBox(height: 8),
            Text(duration, style: TextStyle(color: Colors.grey[500])), // Chữ xám nhạt
            SizedBox(height: 4),
            Text(exercises, style: TextStyle(color: Colors.grey[500])), // Chữ xám nhạt
          ],
        ),
      ),
    );
  }
}
