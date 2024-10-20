import 'package:flutter/material.dart';
import '../service/api_service.dart'; // Import ApiService cho các gọi API
import 'exercise_screen.dart'; // Import ExercisesScreen

class CreateWorkoutScreen extends StatefulWidget {
  @override
  _CreateWorkoutScreenState createState() => _CreateWorkoutScreenState();
}

class _CreateWorkoutScreenState extends State<CreateWorkoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  List<String> _selectedExerciseIds = [];
  List<String> _selectedExerciseNames = [];

  void _addWorkout() async {
    if (_formKey.currentState!.validate()) {
      try {
        final existingWorkouts = await ApiService.fetchUserWorkouts();
        if (existingWorkouts.any((workout) => workout['Title'] == _titleController.text)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Workout title already exists')),
          );
          return;
        }
        Map<String, dynamic> workoutData = {
          'Title': _titleController.text,
          'Description': _descriptionController.text,
          'Exercises': _selectedExerciseIds,
        };
        await ApiService.addWorkoutWithToken(workoutData);
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add workout: $e')),
        );
      }
    }
  }

  void _selectExercises() async {
    final List<Map<String, String>>? selectedExercises = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExercisesScreen(
          selectedExerciseIds: _selectedExerciseIds,
        ),
      ),
    );

    if (selectedExercises != null && selectedExercises.isNotEmpty) {
      setState(() {
        _selectedExerciseIds = selectedExercises.map((exercise) => exercise['id']!).toList();
        _selectedExerciseNames = selectedExercises.map((exercise) => exercise['name']!).toList();
      });
    } else {
      print("No exercises selected or empty result");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Create Workout',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView( // Bao bọc nội dung trong SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
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
                ElevatedButton(
                  onPressed: _selectExercises,
                  child: Text('Add Exercises'),
                ),
                SizedBox(height: 20),
                _selectedExerciseNames.isNotEmpty
                    ? Column(
                  children: _selectedExerciseNames
                      .map((name) => Text('Exercise: $name'))
                      .toList(),
                )
                    : Text("No exercises selected"),
                ElevatedButton(
                  onPressed: _addWorkout,
                  child: Text('Add Workout'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
