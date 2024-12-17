import 'package:doan_tapgymtainha/provider/challenge_provider.dart';
import 'package:doan_tapgymtainha/provider/chalprogress_provider.dart';
import 'package:doan_tapgymtainha/screen/trainingprogram_screen.dart';
import 'package:doan_tapgymtainha/service/api_challenge.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'ai/chatwithai.dart';

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
  List<dynamic> _chalprogress = [];

  void _loadChallenge() async {
    try {
      _chalprogress = await ApiChallenge.fetchChallenges();
      print("Challenges from server: $_chalprogress");
      setState(() {});
    } catch (error) {
      print("Error fetching workouts: $error");
    }
  }

  @override
  void initState() {
    super.initState();
    _loadChallenge();
  }

  Future<void> createAndLoadChalProgress(BuildContext context, String challengeId, ChalprogressProvider chalprogressProvider, dynamic challenge) async {
    try {
      await ApiChallenge.createChalProgress(challengeId);
      await chalprogressProvider.loadChalProgresses();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TrainingProgramScreen(
            challenge: challenge,
          ),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to create progress")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final double bannerHeight = 200;
    final double bannerWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'TẬP LUYỆN TẠI NHÀ',
          style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: () {

                    },
                    icon: Icon(
                        Icons.notifications
                    )
                )
                // Image(
                //   image: AssetImage('assets/fire_streak.png'),
                //   height: 45,
                //   width: 45,
                // ),
                // Text(
                //   '10',
                //   style: TextStyle(
                //     fontSize: 24,
                //     color: Theme.of(context).textTheme.bodyLarge?.color,
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
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
                                ? Colors.orange
                                : Colors.grey[800],
                          ),
                          child: Text(
                            '$day',
                            style: TextStyle(
                              color: day == currentDay &&
                                  currentMonth == now.month &&
                                  currentYear == now.year
                                  ? Colors.black
                                  : Colors.white,
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
                      fontSize: 16,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(0),
              child: Consumer<ChallengeProvider>(
                builder: (context, challengeProvider, child) {
                  return challengeProvider.challenges.isEmpty
                      ? Center(
                    child: Text(
                      "Không có thử thách nào",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                      : CarouselSlider(
                    items: challengeProvider.challenges.map((challenge) {
                      return _buildChallengeCard(
                        context,
                        challenge,
                      );
                    }).toList(),
                    options: CarouselOptions(
                      height: 280,
                      autoPlay: false,
                      enlargeCenterPage: false,
                      enableInfiniteScroll: true,
                      viewportFraction: 0.9,
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Luyện tập cùng AI",
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Stack(
                      children: [
                        Image.asset(
                          'assets/ai_workout_banner.png',
                          width: bannerWidth,
                          height: bannerHeight,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          child: Container(
                            height: bannerHeight,
                            width: bannerWidth / 3.5,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 255, 4, 0),
                                  Colors.white
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                          ),
                        ),
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
                                    color: Theme.of(context).textTheme.bodyLarge?.color,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'WORKOUT',
                                  style: TextStyle(
                                    color: Theme.of(context).textTheme.bodyLarge?.color,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatWithAI(),
                                      ),
                                    );
                                  },
                                  child: Text('START'),
                                ),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CupertinoSegmentedControl<int>(
                children: {
                  0: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Người bắt đầu',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  1: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Trung bình',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  2: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Nâng cao',
                      style: TextStyle(color: Colors.white),
                    ),
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
              height: MediaQuery.of(context).size.height * 0.4,
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
      case 0:
        return [
          WorkoutItem(title: 'BỤNG NGƯỜI BẮT ĐẦU', duration: '20 PHÚT', exercises: '16 BÀI TẬP'),
          WorkoutItem(title: 'NGỰC NGƯỜI BẮT ĐẦU', duration: '9 PHÚT', exercises: '11 BÀI TẬP'),
        ];
      case 1:
        return [
          WorkoutItem(title: 'BỤNG TRUNG BÌNH', duration: '25 PHÚT', exercises: '20 BÀI TẬP'),
          WorkoutItem(title: 'NGỰC TRUNG BÌNH', duration: '15 PHÚT', exercises: '12 BÀI TẬP'),
        ];
      case 2:
        return [
          WorkoutItem(title: 'BỤNG NÂNG CAO', duration: '30 PHÚT', exercises: '25 BÀI TẬP'),
          WorkoutItem(title: 'NGỰC NÂNG CAO', duration: '20 PHÚT', exercises: '15 BÀI TẬP'),
        ];
      default:
        return [];
    }
  }

  Widget _buildChallengeCard(BuildContext context, dynamic challenge) {
    return Container(
      margin: EdgeInsets.all(4),
      padding: EdgeInsets.all(20),

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
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              challenge['name'],
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              challenge['description'],
              style: TextStyle(color: Colors.white),
            ),
            Consumer<ChalprogressProvider>(
              builder: (context, chalprogressProvider, child) {
                final chalprogress = chalprogressProvider.chalprogresses.firstWhere(
                      (item) => item['ChallengeId'] == challenge['_id'],
                  orElse: () => null,
                );
        
                final progressValue = chalprogress != null ? chalprogress['Progress'] : 0;
                final progressPercentage = progressValue / challenge['days'].length;
        
                return chalprogress == null
                    ? Column(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await createAndLoadChalProgress(
                            context, challenge['_id'], chalprogressProvider, challenge);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.orange,
                      ),
                      child: Text(
                        'BẮT ĐẦU',
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ),
                  ],
                )
                    : Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${progressValue.toString()} / ${challenge['days'].length}',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    LinearProgressIndicator(
                      value: progressPercentage,
                      backgroundColor: Colors.grey.shade800,
                      color: Colors.orange,
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TrainingProgramScreen(
                              challenge: challenge,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.orange,
                      ),
                      child: Text(
                        'BẮT ĐẦU',
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class WorkoutItem extends StatelessWidget {
  final String title;
  final String duration;
  final String exercises;

  WorkoutItem({required this.title, required this.duration, required this.exercises});

  @override
  Widget build(BuildContext context) {
    // Lấy thông tin màu sắc từ theme hiện tại
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.black : Colors.grey[300]; // Nền đen cho tối, xám cho sáng
    final textColor = isDarkMode ? Colors.white : Colors.black; // Chữ trắng cho tối, đen cho sáng

    return Card(
      color: backgroundColor,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            SizedBox(height: 8),
            Text(
              duration,
              style: TextStyle(color: textColor),
            ),
            SizedBox(height: 4),
            Text(
              exercises,
              style: TextStyle(color: textColor),
            ),
          ],
        ),
      ),
    );
  }
}
