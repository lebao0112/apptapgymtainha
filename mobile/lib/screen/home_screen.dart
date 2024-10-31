import 'package:doan_tapgymtainha/provider/challenge_provider.dart';
import 'package:doan_tapgymtainha/screen/trainingprogram_screen.dart';
import 'package:doan_tapgymtainha/service/api_challenge.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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

  // late Future<List<dynamic>> _challenges;

  List<dynamic> _chalprogress = [];

  void _loadChallenge() async {
    try {
      _chalprogress = await ApiChallenge.fetchChallenges();
      print("Challenges from server: $_chalprogress");
      setState(() {}); // Cập nhật lại trạng thái sau khi nhận dữ liệu
    } catch (error) {
      print("Error fetching workouts: $error");
    }
  }

  @override
  void initState() {
    super.initState();
    _loadChallenge();
  }

  @override
  Widget build(BuildContext context) {
    final double bannerHeight = 200;
    final double bannerWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black, // Nền đen
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('TẬP LUYỆN TẠI NHÀ',
            style: TextStyle(color: Colors.white)), // Chữ trắng
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Image(
                      image: AssetImage('assets/fire_streak.png'),
                      height: 45,
                      width: 45),
                  Text(
                    '10',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  )
                ],
              )),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mục tiêu hàng tuần
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mục tiêu hàng tuần',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white), // Chữ trắng
                  ),
                  SizedBox(height: 20),
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
                            color: day == currentDay &&
                                    currentMonth == now.month &&
                                    currentYear == now.year
                                ? Colors
                                    .orange // Đổi màu cho ngày hiện tại thành cam
                                : Colors.grey[800], // Nền xám đậm
                          ),
                          child: Text(
                            '$day',
                            style: TextStyle(
                              color: day == currentDay &&
                                      currentMonth == now.month &&
                                      currentYear == now.year
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
                    style: TextStyle(
                        fontSize: 16, color: Colors.white), // Chữ trắng
                  ),
                ],
              ),
            ),

            // Challenge Carousel
            // Padding(
            //   padding: const EdgeInsets.all(0),
            //   child: _chalprogress.isEmpty
            //       ? Center(child: Text("Không có thử thách nào"))
            //       : CarouselSlider(
            //           items: _chalprogress.map((challenge) {
            //             return _buildChallengeCard(
            //               context,
            //               challenge,
            //             );
            //           }).toList(),
            //           options: CarouselOptions(
            //             height: 270, // Chiều cao của slider
            //             autoPlay: false, // Tự động di chuyển
            //             enlargeCenterPage: false, // Không phóng to item ở giữa
            //             enableInfiniteScroll: true, // Không vòng lặp
            //             viewportFraction:
            //                 0.9, // Mỗi trang chiếm 90% chiều rộng của viewport
            //           ),
            //         ),
            // ),


            Padding(
              padding: const EdgeInsets.all(0),
              child: Consumer<ChallengeProvider>(
                builder: (context, challengeProvider, child) {
                  return challengeProvider.chalprogress.isEmpty
                      ? Center(child: Text("Không có thử thách nào"))
                      : CarouselSlider(
                          items:
                              challengeProvider.chalprogress.map((challenge) {
                            return _buildChallengeCard(
                              context,
                              challenge,
                            );
                          }).toList(),
                          options: CarouselOptions(
                            height: 270, // Chiều cao của slider
                            autoPlay: false, // Tự động di chuyển
                            enlargeCenterPage:
                                false, // Không phóng to item ở giữa
                            enableInfiniteScroll: true, // Không vòng lặp
                            viewportFraction:
                                0.9, // Mỗi trang chiếm 90% chiều rộng của viewport
                          ),
                        );
                },
              ),
            ),

            SizedBox(height: 20),

            // Luyện tập cùng AI Banner
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Luyện tập cùng AI",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Stack(
                      children: [
                        // Ảnh nền từ assets
                        Image.asset(
                          'assets/ai_workout_banner.png', // Đường dẫn tới ảnh trong assets
                          width: bannerWidth, // Độ rộng của banner
                          height: bannerHeight, // Chiều cao của banner
                          fit: BoxFit.cover, // Đảm bảo ảnh vừa khung hình
                        ),
                        Positioned(
                            child: Container(
                          height: bannerHeight,
                          width: bannerWidth / 3.5,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(255, 255, 4, 0),
                                Colors.white
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                        )),
                        // Chữ được xếp chồng trên ảnh
                        Positioned(
                          left: bannerWidth / 33,
                          top: 20,
                          child: Container(
                            height: bannerHeight,
                            width: bannerWidth / 3.5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'AI',
                                  style: GoogleFonts.audiowide(
                                      fontSize: 30,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Text(
                                  'WORKOUT',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                                ElevatedButton(
                                    onPressed: () {},
                                    child: const Text('START'))
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Segment Control
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CupertinoSegmentedControl<int>(
                children: const {
                  0: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Người bắt đầu',
                        style: TextStyle(color: Colors.white)),
                  ),
                  1: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Trung bình',
                        style: TextStyle(color: Colors.white)),
                  ),
                  2: Padding(
                    padding: EdgeInsets.all(8.0),
                    child:
                        Text('Nâng cao', style: TextStyle(color: Colors.white)),
                  ),
                },
                onValueChanged: (int? value) {
                  setState(() {
                    _selectedSegment = value ?? 0;
                  });
                },
                groupValue: _selectedSegment,
                unselectedColor: Colors.grey[800],
                selectedColor: Colors.orange,
                borderColor: Colors.orange,
              ),
            ),

            SizedBox(
              height: MediaQuery.of(context).size.height *
                  0.4, // Ví dụ: 40% chiều cao màn hình
              // height: 20,
              child: ListView(
                padding: EdgeInsets.all(16),
                children: _getWorkoutItems(),
              ),
            ),
          ],
        ),
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

Widget _buildChallengeCard(BuildContext context, dynamic challenge) {
  return Container(
    margin: EdgeInsets.all(4),
    padding: EdgeInsets.all(20),
    width: 400,
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Colors.cyan,
          Colors.blueAccent,
        ],
      ),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          challenge['name'],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          challenge['description'],
          style: TextStyle(color: Colors.white),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '1 / 28 Days Finished',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            Text(
              '4%',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 10),
        LinearProgressIndicator(
          value: 0.04, // Tỷ lệ tiến độ
          backgroundColor: Colors.grey.shade800,
          color: Colors.orange,
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Xác nhận"),
                  content: Text("Bạn có chắc chắn muốn bắt đầu không?"),
                  actions: [
                    TextButton(
                      child: Text("Không"),
                      onPressed: () {
                        Navigator.of(context)
                            .pop(); // Đóng hộp thoại mà không làm gì thêm
                      },
                    ),
                    TextButton(
                      child: Text("Có"),
                      onPressed: () {
                        Navigator.of(context).pop(); // Đóng hộp thoại
                        // Điều hướng sang màn hình mới
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TrainingProgramScreen(
                              challenge: challenge,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            );
           
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.orange,
          ),
          child: Text(
            'BẮT ĐẦU',
            style: TextStyle(
              fontWeight: FontWeight.w900
            ),
            ),
        ),
      ],
    ),
  );

}

class WorkoutItem extends StatelessWidget {
  final String title;
  final String duration;
  final String exercises;

  WorkoutItem(
      {required this.title, required this.duration, required this.exercises});

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
            Text(title,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)), // Chữ trắng
            SizedBox(height: 8),
            Text(duration,
                style: TextStyle(color: Colors.grey[500])), // Chữ xám nhạt
            SizedBox(height: 4),
            Text(exercises,
                style: TextStyle(color: Colors.grey[500])), // Chữ xám nhạt
          ],
        ),
      ),
    );
  }
}
