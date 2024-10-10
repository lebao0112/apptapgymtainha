// File path: lib/screens/createworkout_screen.dart
import 'package:flutter/material.dart';
import 'excercise_screen.dart';
import 'exerciselist_screen.dart'; // Import ExerciseListScreen

class CreateWorkoutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.timer, color: Colors.black),
            onPressed: () {
              // Handle timer button press
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Navigate to ExerciseListScreen when Finish is clicked
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ExerciseListScreen()),
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20),
              ),
              child: Text('Finish'),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Workout Title and Menu
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Afternoon Workout',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.more_horiz, color: Colors.grey),
                  onPressed: () {
                    // Handle menu button press
                  },
                ),
              ],
            ),
            SizedBox(height: 5),

            // Workout Time
            Text(
              '0:03',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 10),

            // Notes Section
            Text(
              'Notes',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            SizedBox(height: 20),

            // Add Exercises Button
            ElevatedButton(
              onPressed: () {
                // Handle adding exercises
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ExercisesScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue[100],
                foregroundColor: Colors.blue,
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text('Add Exercises'),
            ),
            SizedBox(height: 20),

            // Cancel Workout Button
            ElevatedButton(
              onPressed: () {
                // Handle cancel workout
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[100],
                foregroundColor: Colors.red,
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text('Cancel Workout'),
            ),
          ],
        ),
      ),
    );
  }
}
