import 'package:doan_tapgymtainha/screen/exercise_sequence/exercise_timer_screen.dart';
import 'package:doan_tapgymtainha/screen/exercise_sequence/ready_workout_sreen.dart';
import 'package:flutter/material.dart';
import 'package:doan_tapgymtainha/shared/format.dart';

class WorkoutDetailScreen extends StatefulWidget {
  final Map<String, dynamic>
      workoutDetails; // Dữ liệu truyền vào chứa thông tin bài tập

  const WorkoutDetailScreen({super.key, required this.workoutDetails});

  @override
  _WorkoutDetailScreenState createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  @override
  Widget build(BuildContext context) {
    // Lấy thông tin từ workoutDetails
    final String workoutTitle =
        widget.workoutDetails['Title'] ?? 'Workout Title';
    final String workoutDescription =
        widget.workoutDetails['Description'] ?? '';
    final List<dynamic> exercises = widget.workoutDetails['Exercises'] ?? [];
    

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(workoutTitle,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.favorite_border, color: Colors.white),
              onPressed: () {}),
          IconButton(
              icon: Icon(Icons.more_vert, color: Colors.white),
              onPressed: () {}),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workoutTitle,
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 8),

                  const SizedBox(height: 8),

                  // Mô tả chương trình tập
                  Text(
                    workoutDescription,
                    style: TextStyle(fontSize: 16, color: Colors.grey[300]),
                  ),
                  const SizedBox(height: 16),

                  // Level, Time, Focus Area
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoCard('Adjustable', 'Level'),
                      _buildInfoCard('19 mins', 'Time'),
                      _buildInfoCard('Arm', 'Focus Area'),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Workout Settings
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Workout Settings',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text('Edit',
                            style: TextStyle(color: Colors.orange)),
                      ),
                    ],
                  ),
                  Text('Sounds, Music, Coach...',
                      style: TextStyle(color: Colors.grey[300])),

                  const SizedBox(height: 16),

                  // Exercises list
                  Text(
                    'Exercises (${exercises.length})',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Column(
                    children: List.generate(exercises.length, (index) {
                      return _buildExerciseItem(exercises[index]);
                    }),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.only(bottom: 50),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReadyWorkoutSreen(
                        exercises: exercises,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(horizontal: 80, vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text(
                  'START',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16)),
        const SizedBox(height: 4),
        Text(subtitle, style: TextStyle(color: Colors.grey[300], fontSize: 14)),
      ],
    );
  }

  Widget _buildExerciseItem(Map<String, dynamic> exercise) {
    String detail;

    if(exercise['isRep']){
      detail = "Reps: x${exercise['reps']}";
    } else{
      var fomatDuration = Format.formatDuration(exercise['duration']);
      detail = "Duration: $fomatDuration";
    }

    // if (exercise.containsKey('reps') && exercise['reps'] != null) {
    //   detail = 'Reps: x${exercise['reps']}';
    // }
    //
    // // Kiểm tra và hiển thị duration nếu có
    // if (exercise.containsKey('duration') && exercise['duration'] != null) {
    //   int timeInSeconds = exercise['duration'];
    //   int minutes = timeInSeconds ~/ 60;
    //   int seconds = timeInSeconds % 60;
    //   if (detail.isNotEmpty) {
    //     detail += ' | '; // Thêm dấu phân cách nếu cả reps và duration cùng có
    //   }
    //   detail +=
    //       'Duration: ${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    // }

    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 8.0),
      leading:
          Image.network(exercise["imageUrl"], // Đường dẫn URL ảnh từ bài tập
              width: 50,
              height: 50,
              fit: BoxFit.cover),
      title: Text(
        exercise['name']!,
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
      ),
      subtitle: Text(detail.isEmpty ? 'No data available' : detail, style: TextStyle(color: Colors.grey[300])),
    );
  }
  String formatDuration(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = remainingSeconds.toString().padLeft(2, '0');
    return "$minutesStr:$secondsStr";
  }
}
