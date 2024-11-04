import 'package:doan_tapgymtainha/screen/workoutdetail_screen.dart';
import 'package:flutter/material.dart';
import 'createworkout_screen.dart'; // Import the CreateWorkoutScreen
import '../service/api_service.dart';
import 'exercise_sequence/ready_workout_sreen.dart'; // Import your ApiService

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  late Future<List<dynamic>> _userWorkouts;

  @override
  void initState() {
    super.initState();
    _loadUserWorkouts(); // Tải dữ liệu workouts khi khởi tạo
  }

  void _loadUserWorkouts() {
    _userWorkouts = ApiService.fetchUserWorkouts(); // Tải dữ liệu từ API
  }

  void _showWorkoutDialog(Map<String, dynamic> workoutDetails) {
    // Safely parse the exercises list to be a list of maps with strings
    List<Map<String, String>> exercises = [];

    if (workoutDetails['Exercises'] != null &&
        workoutDetails['Exercises'] is List) {
      exercises = (workoutDetails['Exercises'] as List).map((exercise) {
        return {
          'exerciseName': (exercise['name'] ?? 'Unnamed Exercise').toString(),
          'videoUrl': (exercise['videoUrl'] ?? '').toString(),
          'reps': '3', // Hardcoding reps for now
          'sets': '3', // Hardcoding sets for now
          'duration': '30' // Hardcoding duration for now
        };
      }).toList();
    }

    print(exercises);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(workoutDetails['Title']?.toString() ?? 'No Title'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Display the list of exercises
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
                // Navigate to ReadyWorkoutScreen with the exercises
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
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Start Workout',
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
                  setState(() {
                    _loadUserWorkouts(); // Tải lại dữ liệu sau khi thêm workout
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text('New workout'),
            ),
            SizedBox(height: 20),
            Text(
              'My workouts',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color),
            ),
            SizedBox(height: 10),
            FutureBuilder<List<dynamic>>(
              future: _userWorkouts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Failed to load workouts'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No workouts found'));
                } else {
                  return GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.5, // Điều chỉnh tỷ lệ cho phù hợp
                    physics: NeverScrollableScrollPhysics(),
                    children: snapshot.data!.map((workout) {
                      // Safely access the title, description, and workoutId
                      final String title = workout['Title'] ?? 'No Title';
                      final String description =
                          workout['Description'] ?? 'No Description';
                      final String workoutId = workout['_id'] ?? '';

                      return _buildTemplateCard(workoutId, title, description);
                    }).toList(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // Hàm dựng các Template Card
  Widget _buildTemplateCard(
      String workoutId, String title, String description) {
    return GestureDetector(
      onTap: () async {
        // Fetch the workout details from the server
        final workoutDetails = await ApiService.fetchWorkoutDetails(workoutId);
        // _showWorkoutDialog(workoutDetails);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  WorkoutDetailScreen(workoutDetails: workoutDetails)),
        );
      },
      child: Card(
        color: const Color.fromARGB(255, 121, 120, 120),
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
