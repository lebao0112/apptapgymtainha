import 'package:flutter/material.dart';
import 'createworkout_screen.dart';  // Import the CreateWorkoutScreen
import '../service/api_service.dart'; // Import your ApiService
class StartScreen extends StatefulWidget {
  final String userId; // Accept the userId

  StartScreen({required this.userId}); // Constructor to pass userId

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  late Future<List<dynamic>> _userWorkouts; // Declare a Future for user workouts

  @override
  void initState() {
    super.initState();
    _loadUserWorkouts(); // Load user workouts when the screen is initialized
  }

  void _loadUserWorkouts() {
    // Fetch user workouts when the screen is initialized
    print("User ID: ${widget.userId}");
    _userWorkouts = ApiService.fetchUserWorkouts(widget.userId);

    // In ra dữ liệu workouts để kiểm tra
    _userWorkouts.then((workouts) {
      print("Workouts from server: $workouts");
    }).catchError((error) {
      print("Error fetching workouts: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Start Workout',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quick Start Section
            ElevatedButton(
              onPressed: () async {
                // Navigate to CreateWorkoutScreen and wait for result
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateWorkoutScreen(userId: widget.userId)),
                );

                // If a workout was added (result is true), reload workouts
                if (result == true) {
                  setState(() {
                    _loadUserWorkouts(); // Reload workouts after adding a new one
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text('Start an Empty Workout'),
            ),
            SizedBox(height: 20),

            // Templates Section
            Text(
              'My Templates', // Changed from Example Templates to My Templates
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // Load and display example templates with user workouts
            FutureBuilder<List<dynamic>>(
              future: _userWorkouts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  print("Error: ${snapshot.error}");
                  return Center(child: Text('Failed to load workouts'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  print("No workouts found");
                  return _buildTemplates([]); // No user workouts, show only static templates
                } else {
                  print("Workouts found: ${snapshot.data}");
                  return _buildTemplates(snapshot.data!); // Combine user workouts with static templates
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // Function to combine static example templates with dynamic user workouts
  Widget _buildTemplates(List<dynamic> userWorkouts) {
    // Static example templates
    List<Widget> templates = _buildExampleTemplates();

    // Append user workouts to the template list
    templates.addAll(userWorkouts.map((workout) {
      return _buildTemplateCard(workout['Title'], workout['Description']);
    }).toList());

    // Return a GridView with all templates (both static and dynamic)
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 2.0,
      physics: NeverScrollableScrollPhysics(),
      children: templates,
    );
  }

  // Function to build example templates
  List<Widget> _buildExampleTemplates() {
    return [
      _buildTemplateCard('Legs', 'Squat, Leg Extension, Calf Raise'),
      _buildTemplateCard('Chest and Triceps', 'Bench Press, Incline Bench Press'),
      _buildTemplateCard('Back and Biceps', 'Deadlift, Pull-ups'),
      _buildTemplateCard('Strong 5x5 Workout', 'Squat, Bench Press, Deadlift'),
      _buildTemplateCard('Cardio and Abs', 'Running, Plank, Crunches'),
    ];
  }

  // Helper function to build a single template card
  Widget _buildTemplateCard(String title, String description) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 5),
            Text(
              description,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

