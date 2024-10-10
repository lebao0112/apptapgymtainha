// File path: lib/screens/exerciselist_screen.dart
import 'package:flutter/material.dart';
import 'excerciselogs_screen.dart'; // Import the ExerciseLogsScreen

class ExerciseListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5), // Dim background for modal effect
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16.0),
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Title and Close Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Legs',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      // Close the modal
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              SizedBox(height: 10),

              // Exercise List
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: _buildExerciseItems(),
                ),
              ),
              SizedBox(height: 20),

              // Start Workout Button
              ElevatedButton(
                onPressed: () {
                  // Navigate to ExerciseLogsScreen when Start Workout is clicked
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ExerciseLogsScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text('Start Workout'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to build the list of exercises
  List<Widget> _buildExerciseItems() {
    return [
      _buildExerciseItem(
        '3 × Squat (Barbell)',
        'Legs',
        Icons.fitness_center, // Icon for exercises
      ),
      _buildExerciseItem(
        '3 × Leg Extension (Machine)',
        'Legs',
        Icons.fitness_center,
      ),
      _buildExerciseItem(
        '3 × Flat Leg Raise',
        'Core',
        Icons.fitness_center,
      ),
      _buildExerciseItem(
        '3 × Standing Calf Raise (Dumbbell)',
        'Legs',
        Icons.fitness_center,
      ),
    ];
  }

  // Helper function to build a single exercise item
  Widget _buildExerciseItem(String name, String bodyPart, IconData icon) {
    return ListTile(
      leading: Icon(icon, size: 40, color: Colors.grey[700]),
      title: Text(
        name,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(bodyPart),
      trailing: IconButton(
        icon: Icon(Icons.help_outline, color: Colors.blue),
        onPressed: () {
          // Handle help icon press (maybe show exercise info)
        },
      ),
    );
  }
}
