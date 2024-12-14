import 'package:doan_tapgymtainha/provider/chalprogress_provider.dart';
import 'package:doan_tapgymtainha/screen/workoutdetail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../service/api_challenge.dart';

class TrainingProgramScreen extends StatelessWidget {
  final dynamic challenge;

  // const TrainingProgramScreen({super.key, required this.challenge});
  const TrainingProgramScreen({Key? key, required this.challenge}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String challengeId = challenge['_id'];
    final int totalDays = (challenge['days'] as List).length;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Consumer<ChalprogressProvider>(
        builder: (context, chalprogressProvider, child) {
          Map<String, dynamic> chalProgress = chalprogressProvider.getProgressForChallenge(challengeId);
          List<String> days = (challenge['days'] as List).cast<String>();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Tiêu đề
                Text(
                  challenge['name'],
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
                      '${chalProgress['Progress']} / $totalDays workouts hoàn thành',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  value: chalProgress['Progress'] / totalDays,
                  backgroundColor: Colors.grey.shade800,
                  color: Colors.orange,
                ),
                const SizedBox(height: 20),

                // Danh sách các ngày tập
                _buildDayCheck(days, context, challengeId, chalProgress),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDayCheck(List<String> days, BuildContext context, String challengeId, Map<String, dynamic> chalProgress,
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
                  return _buildDayButton(index + 1, days[index], chalProgress, context);
                }),
              ),
              if (showContinueButton)
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Container(
                    margin: const EdgeInsets.only(
                        top: 10.0, left: 16.0, right: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        if (chalProgress['Progress'] < days.length) {
                          _onDayButtonTap(days[chalProgress['Progress']], chalProgress, context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Bạn đã hoàn thành toàn bộ chương trình!")),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      ),
                      child: Text(
                        'TIẾP TỤC',
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

  Widget _buildDayButton(int dayNumber, String workoutId, Map<String, dynamic> chalProgress, BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(7),
      child: GestureDetector(
        onTap: () async {
          _onDayButtonTap(workoutId, chalProgress, context);
        },
        child: dayNumber <= chalProgress['Progress']
            ? Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Icon(
            Icons.check,
            size: 20,
          ),
        )
            : Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey.shade800,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
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

  void _onDayButtonTap(String workoutId, Map<String, dynamic> chalProgress , BuildContext context) async {
    // final workoutDetails = await ApiChallenge.fetchChallengeWorkoutDetails(workoutId);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => WorkoutDetailScreen(workoutId: workoutId, chalProgress:  chalProgress,)),
    );
  }
}
