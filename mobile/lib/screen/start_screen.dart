import 'package:doan_tapgymtainha/screen/workout_calenda_screen.dart';
import 'package:doan_tapgymtainha/screen/workoutdetail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/workout_provider.dart';
import 'createworkout_screen.dart'; // Import the CreateWorkoutScreen
import '../service/api_service.dart';
import 'exercise_sequence/ready_workout_sreen.dart'; // Import your ApiService

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  void initState() {
    super.initState();
  }

  void _showWorkoutDialog(Map<String, dynamic> workoutDetails) {
    List<Map<String, String>> exercises = [];

    if (workoutDetails['Exercises'] != null &&
        workoutDetails['Exercises'] is List) {
      exercises = (workoutDetails['Exercises'] as List).map((exercise) {
        return {
          'exerciseName': (exercise['name'] ?? 'Unnamed Exercise').toString(),
          'videoUrl': (exercise['videoUrl'] ?? '').toString(),
          'reps': '3',
          'sets': '3',
          'duration': '30'
        };
      }).toList();
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(workoutDetails['Title']?.toString() ?? 'No Title'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var exercise in exercises)
                ListTile(
                  title: Text(exercise['exerciseName'] ?? 'Unnamed Exercise'),
                  subtitle: Text(
                    'Reps: ${exercise['reps']}, Sets: ${exercise['sets']}, Duration: ${exercise['duration']} secs',
                  ),
                ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Start Workout'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ReadyWorkoutSreen(exercises: exercises),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final workoutProvider = Provider.of<WorkoutProvider>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'BẮT ĐẦU TẬP LUYỆN',
          style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateWorkoutScreen()),
                );
                if (result == true) {
                  Provider.of<WorkoutProvider>(context, listen: false).loadWorkouts();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text('Tạo bài tập mới'),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Bài tập của tôi',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color),
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WorkoutCalendarScreen(workouts: workoutProvider.workouts)),
                      );
                    },
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // Đảm bảo Row chỉ chiếm đủ không gian cần thiết
                    children: [
                      Icon(Icons.calendar_month_rounded , color: Theme.of(context).textTheme.bodyLarge?.color), // Thêm icon cuốn lịch
                      SizedBox(width: 8), // Khoảng cách giữa icon và text
                      Text(
                        "Lịch tập",
                        style: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge?.color
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 10),
            workoutProvider.isLoading
                ? Center(child: CircularProgressIndicator())
                : workoutProvider.workouts.isEmpty
                ? Center(
                child: Text('No workouts found',
                    style: TextStyle(color: Colors.white)))
                : GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.5,
              physics: NeverScrollableScrollPhysics(),
              children: workoutProvider.workouts.map((workout) {
                final String title = workout['Title'] ?? 'No Title';
                final String description =
                    workout['Description'] ?? 'No Description';
                final String workoutId = workout['_id'] ?? '';

                return _buildTemplateCard(
                    workoutId, title, description);
              }).toList(),
            ),
            // Consumer<WorkoutProvider>(
            //   builder: (context, workoutProvider, child) {
            //     if (workoutProvider.isLoading) {
            //       return Center(child: CircularProgressIndicator());
            //     } else if (workoutProvider.workouts.isEmpty) {
            //       return Center(child: Text('No workouts found', style: TextStyle(color: Colors.white)));
            //     } else {
            //       return GridView.count(
            //         shrinkWrap: true,
            //         crossAxisCount: 2,
            //         crossAxisSpacing: 10,
            //         mainAxisSpacing: 10,
            //         childAspectRatio: 1.5,
            //         physics: NeverScrollableScrollPhysics(),
            //         children: workoutProvider.workouts.map((workout) {
            //           final String title = workout['Title'] ?? 'No Title';
            //           final String description = workout['Description'] ?? 'No Description';
            //           final String workoutId = workout['_id'] ?? '';
            //
            //           return _buildTemplateCard(workoutId, title, description);
            //         }).toList(),
            //       );
            //     }
            //   },
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildTemplateCard(
      String workoutId, String title, String description) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.grey : Colors.grey[300];
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return GestureDetector(
      onTap: () async {
        final workoutDetails = await ApiService.fetchWorkoutDetails(workoutId);
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  WorkoutDetailScreen(workoutId: workoutId,)),
        );

        if (result == true) {
          Provider.of<WorkoutProvider>(context, listen: false).loadWorkouts();
        }
      },
      child: Card(
        color: backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 5),
              Text(
                description,
                style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: 12),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
