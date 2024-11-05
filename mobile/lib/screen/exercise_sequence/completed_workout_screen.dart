import 'package:doan_tapgymtainha/provider/chalprogress_provider.dart';
import 'package:doan_tapgymtainha/provider/complete_workout_status_provider.dart';
import 'package:doan_tapgymtainha/service/api_challenge.dart';
import 'package:doan_tapgymtainha/shared/format.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../provider/workout_timer_provider.dart';

class CompletedWorkoutScreen extends StatelessWidget {
  List<dynamic>? exercises;
  final Map<String, dynamic>? chalProgress;

  CompletedWorkoutScreen({super.key,this.exercises, this.chalProgress});

  @override
  Widget build(BuildContext context) {
    final workoutHistoryProvider = Provider.of<WorkoutTimerProvider>(context);
    final workoutName = workoutHistoryProvider.currentWorkoutName;
    final time = workoutHistoryProvider.totalTime;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
             "HOÀN THÀNH",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            Text(
              workoutName,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              "Thời gian: ${Format.formatDuration(time)}",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     _buildStatsCard(context, '16', 'Exercise'),
            //     _buildStatsCard(context, '0', 'Calories'),
            //     _buildStatsCard(context, '12', 'Duration'),
            //   ],
            // ),
            SizedBox(
              height: 30,
            ),
            const Text(
              "Bạn cảm thấy thế nào",
              style: TextStyle(
                fontSize: 25,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildDifficultyCircle('Dễ', Colors.green),
                buildDifficultyCircle('Thường', Colors.orange),
                buildDifficultyCircle('Khó', Colors.red),
              ],
            ),
            SizedBox(
              height: 50,
            ),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {

                },
                child: const Text(
                  'KẾT THÚC',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  padding: MaterialStateProperty.all<EdgeInsets>(
                    EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard(BuildContext context, String stats, String nameStats) {
    return Column(
      children: [
        Text(
          stats,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        Text(
          nameStats,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget buildDifficultyCircle(String label, Color color) {
    return Container(
      width: 75,
      height: 75,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
