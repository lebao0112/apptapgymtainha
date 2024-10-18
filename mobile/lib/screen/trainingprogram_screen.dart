import 'package:doan_tapgymtainha/screen/workoutdetail_screen.dart';
import 'package:flutter/material.dart';

class TrainingProgramScreen extends StatelessWidget {
  final String challengeName;

  const TrainingProgramScreen({super.key, required this.challengeName});

  @override
  Widget build(BuildContext context) {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tiêu đề và hình ảnh
            Text(
              this.challengeName,
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
            _buildWeekProgress('WEEK 1',
                [true, true, false, false, false, false, false], context,
                showContinueButton: true),
            _buildWeekProgress('WEEK 2',
                [false, false, false, false, false, false, false], context),
            _buildWeekProgress('WEEK 3',
                [false, false, false, false, false, false, false], context),
            _buildWeekProgress('WEEK 4',
                [false, false, false, false, false, false, false], context),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekProgress(
      String weekTitle, List<bool> daysCompleted, BuildContext context,
      {bool showContinueButton = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.flash_on, color: Colors.orange, size: 20),
            const SizedBox(width: 8),
            Text(
              weekTitle,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(daysCompleted.length, (index) {
                  return _buildDayButton(index + 1, daysCompleted[index]);
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WorkoutDetailScreen()),
                        );
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

  Widget _buildDayButton(int dayNumber, bool isCompleted) {
    return CircleAvatar(
      backgroundColor: isCompleted ? Colors.orange : Colors.grey.shade800,
      child: Text(
        dayNumber.toString(),
        style: TextStyle(
          color: isCompleted ? Colors.white : Colors.grey,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
