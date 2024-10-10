// File path: lib/screens/exerciselogs_screen.dart
import 'package:flutter/material.dart';

class ExerciseLogsScreen extends StatelessWidget {
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
                // Handle finish workout
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Workout Title
            Text(
              'Strong 5x5 - Workout A',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),

            // Workout Time
            Text(
              '0:06',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 10),

            // Exercise Logs
            Expanded(
              child: ListView(
                children: [
                  _buildExerciseLog('Squat (Barbell)'),
                  _buildExerciseLog('Bench Press (Barbell)'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to build exercise log with multiple sets
  Widget _buildExerciseLog(String exerciseName) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  exerciseName,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    // Handle edit exercise action
                  },
                ),
              ],
            ),
            SizedBox(height: 10),

            // Exercise set rows
            Column(
              children: List.generate(5, (index) {
                return _buildSetRow(index + 1);
              }),
            ),
            SizedBox(height: 10),

            // Add Set Button
            TextButton(
              onPressed: () {
                // Handle adding new set
              },
              child: Text('+ Add Set'),
            ),
          ],
        ),
      ),
    );
  }

  // Function to build each set row
  Widget _buildSetRow(int setNumber) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Set $setNumber'),
          Row(
            children: [
              _buildInputField('Previous', width: 60),
              _buildInputField('lbs', width: 50),
              _buildInputField('Reps', width: 50),
              Icon(Icons.check, color: Colors.grey), // Completed checkbox
            ],
          ),
        ],
      ),
    );
  }

  // Helper function to build an input field
  Widget _buildInputField(String label, {double width = 60}) {
    return Container(
      width: width,
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          isDense: true,
        ),
      ),
    );
  }
}
