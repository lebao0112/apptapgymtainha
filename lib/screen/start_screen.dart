// File path: lib/screens/start_screen.dart
import 'package:flutter/material.dart';
import 'createworkout_screen.dart';  // Import the CreateWorkoutScreen

class StartScreen extends StatelessWidget {
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
              onPressed: () {
                // Navigate to CreateWorkoutScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateWorkoutScreen()),
                );
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
              'Templates',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // My Templates Section
            Container(
              height: 100,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.grey),
                ),
                child: Center(
                  child: TextButton(
                    onPressed: () {
                      // Handle add new template
                    },
                    child: Text(
                      'Tap to Add New Template',
                      style: TextStyle(fontSize: 16, color: Colors.blue),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Example Templates Section
            Text(
              'Example Templates (5)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // Example Templates List
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2.0,
              physics: NeverScrollableScrollPhysics(),
              children: _buildExampleTemplates(),
            ),
          ],
        ),
      ),
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
