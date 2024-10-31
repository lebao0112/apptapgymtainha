import 'package:doan_tapgymtainha/screen/workoutdetail_screen.dart';
import 'package:flutter/material.dart';

import '../service/api_service.dart';
import '../service/api_challenge.dart';

class TrainingProgramScreen extends StatelessWidget {

  final dynamic challenge;

  const TrainingProgramScreen({super.key, this.challenge});


  @override
  Widget build(BuildContext context) {
    List<String> days = (challenge['days'] as List).cast<String>();


    return Scaffold(
      backgroundColor: Colors.black, // Màu nền chính của màn hình
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Tiêu đề và hình ảnh
            Text(
              this.challenge['name'],
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),

            // Thanh progress và tiến độ
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
            const SizedBox(height: 20),

            // Danh sách các tuần
            _buildDayCheck(days, context)
          ],
        ),
      ),
    );
  }

  Widget _buildDayCheck(
      List<String> days, BuildContext context,
      {bool showContinueButton = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: List.generate(days.length, (index) {
                  return _buildDayButton(index + 1, days[index], context);
                }),
              ),
              if (showContinueButton) // Chỉ hiển thị nút "Continue" nếu đúng tuần
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Container(
                    margin: const EdgeInsets.only(
                        top: 10.0, left: 16.0, right: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => WorkoutDetailScreen()),
                        // );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors
                            .orange, // Sử dụng backgroundColor thay cho primary
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      ),
                      child: Text(
                        'CONTINUE',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildDayButton(int dayNumber, String workoutId, BuildContext context) {
    print(workoutId);
    return Padding(
      padding: EdgeInsets.all(7),
      child: GestureDetector(
        onTap: () async {
          // Fetch the workout details from the server
          final workoutDetails = await ApiChallenge.fetchChallengeWorkoutDetails(workoutId);
          // _showWorkoutDialog(workoutDetails);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    WorkoutDetailScreen(workoutDetails: workoutDetails)),
          );
        },
        child: Container(
          width: 40, // Đặt kích thước cho nút (chiều rộng = chiều cao để tạo hình tròn)
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey.shade800, // Màu nền
            shape: BoxShape.circle, // Tạo hình tròn
          ),
          alignment: Alignment.center, // Canh giữa nội dung trong hình tròn
          child: Text(
            dayNumber.toString(),
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
