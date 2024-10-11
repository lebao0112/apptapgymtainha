import 'package:doan_tapgymtainha/screen/doingworkout_screen.dart';
import 'package:flutter/material.dart';

final List<Map<String, String>> exercises = [
  {'name': 'Ball Slams', 'reps': '10', 'category': 'Full Body', 'image': 'ballslams.png'},
  {'name': 'Battle Ropes', 'time': '30', 'category': 'Cardio', 'image': 'battleropes.png'},
  {'name': 'Bench Dip', 'reps': '10', 'category': 'Arms', 'image': 'benchdips.png'},
  {
    'name': 'Bench Press (Barbell)',
    'reps': '10',
    'category': 'Chest',
    'image': 'benchpress_barbell.png'
  },
  {
    'name': 'Bench Press (Cable)',
    'reps': '10',
    'category': 'Chest',
    'image': 'benchpress_cable.png'
  },
  {
    'name': 'Bench Press (Dumbbell)',
    'category': 'Chest',
    'reps': '10',
    'image': 'benchpress_dumbbell.png'
  },
];

class WorkoutDetailScreen extends StatefulWidget {
  const WorkoutDetailScreen({Key? key}) : super(key: key);

  @override
  _WorkoutDetailScreenState createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('MASSIVE UPPER BODY', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(Icons.favorite_border, color: Colors.white), onPressed: () {}),
          IconButton(icon: Icon(Icons.more_vert, color: Colors.white), onPressed: () {}),
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
                  // Tiêu đề chương trình tập
                  Text(
                    'MASSIVE UPPER BODY',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 8),

                  // Ngày tập
                  Text(
                    'DAY 3',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 8),

                  // Mô tả chương trình tập
                  Text(
                    'Lose belly fat, get ripped abs in just 4 weeks with this efficient plan. It also helps pump up your arms, strengthen your back & shoulders. No equipment needed!',
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
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text('Edit', style: TextStyle(color: Colors.orange)),
                      ),
                    ],
                  ),
                  Text('Sounds, Music, Coach...', style: TextStyle(color: Colors.grey[300])),

                  const SizedBox(height: 16),

                  // Exercises list
                  Text(
                    'Exercises (${exercises.length})',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
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
                      builder: (context) => DoingworkoutScreen(exercises: [],),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(horizontal: 80, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: Text(
                  'START',
                  style: TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.bold),

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
        Text(title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 4),
        Text(subtitle, style: TextStyle(color: Colors.grey[300], fontSize: 14)),
      ],
    );
  }

  Widget _buildExerciseItem(Map<String, String> exercise) {
    String detail = '';

    // Kiểm tra xem bài tập có thuộc tính 'reps' hay 'time' và định dạng tương ứng
    if (exercise.containsKey('reps')) {
      detail = 'x${exercise['reps']}';
    } else if (exercise.containsKey('time')) {
      int timeInSeconds = int.tryParse(exercise['time'] ?? '0') ?? 0;
      int minutes = timeInSeconds ~/ 60;
      int seconds = timeInSeconds % 60;
      detail = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }

    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 8.0),
      leading: Image.asset('assets/exercises/${exercise["image"]}', width: 50, height: 50, fit: BoxFit.cover),
      title: Text(
        exercise['name']!,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
      ),
      subtitle: Text(detail, style: TextStyle(color: Colors.grey[300])),
    );
  }
}
