import 'package:doan_tapgymtainha/screen/exercise_screen.dart';
import 'package:flutter/material.dart';
import '../service/api_service.dart'; // Import ApiService for API calls

class CreateWorkoutScreen extends StatefulWidget {
  final String userId; // Accept the userId

  CreateWorkoutScreen({required this.userId}); // Pass userId in constructor

  @override
  _CreateWorkoutScreenState createState() => _CreateWorkoutScreenState();
}

class _CreateWorkoutScreenState extends State<CreateWorkoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  List<String> _exercises = []; // List of exercises

  // Function to add workout
  void _addWorkout() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Prepare workout data
        Map<String, dynamic> workoutData = {
          'Title': _titleController.text,
          'Description': _descriptionController.text,
          'Exercises': _exercises, // Use selected exercises
        };

        // Log workout data before sending it to the server for debugging
        print("Adding workout: $workoutData");

        // Call the API service to add workout for user
        await ApiService.addWorkout(widget.userId, workoutData);

        // Navigate back to start screen after adding workout
        Navigator.pop(context, true); // Pass true to indicate success
      } catch (e) {
        // If adding workout fails, show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add workout: $e')),
        );
      }
    }
  }

  // This method will handle the result from ExercisesScreen
  void _selectExercises() async {
    final selectedExercises = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExercisesScreen(
          selectedExercises: _exercises,
        ),
      ),
    );

    // If exercises are returned, update the list
    if (selectedExercises != null) {
      setState(() {
        _exercises = List<String>.from(selectedExercises);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Create Workout',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Title Field
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: "Workout Title"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),

              // Description Field
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: "Workout Description"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Button to add exercises
              ElevatedButton(
                onPressed: _selectExercises, // Navigate to exercise selection screen
                child: Text('Add Exercises'),
              ),

              SizedBox(height: 20),

              // Display selected exercises
              _exercises.isNotEmpty
                  ? Column(
                children: _exercises
                    .map((exercise) => Text(exercise))
                    .toList(),
              )
                  : Text("No exercises selected"),

              // Submit Button
              ElevatedButton(
                onPressed: _addWorkout, // Add workout function
                child: Text('Add Workout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
