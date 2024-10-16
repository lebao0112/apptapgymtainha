import 'package:doan_tapgymtainha/screen/excercise_screen.dart';
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
          'Exercises': _exercises,
        };

        // In ra workout data trước khi gửi lên server để kiểm tra
        print("Adding workout: $workoutData");

        // Call the API service to add workout for user
        await ApiService.addWorkout(widget.userId, workoutData);

        // Navigate back and pass a value to inform that a workout was added
        Navigator.pop(context, true); // Return true to indicate success
      } catch (e) {
        // If adding workout fails, show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add workout: $e')),
        );
      }
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

              // Button to add exercises (you can navigate to another screen to select exercises)
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ExercisesScreen()),
                  );
                  setState(() {
                    _exercises.add('Push-up');
                    _exercises.add('Squat');
                  });
                },
                child: Text('Add Exercises'),
              ),

              SizedBox(height: 20),

              // Submit Button
              ElevatedButton(
                onPressed: _addWorkout,
                child: Text('Add Workout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
