import 'package:flutter/material.dart';
import '../service/api_service.dart'; // Import ApiService for API calls

class ExercisesScreen extends StatefulWidget {
  final List<String> selectedExercises; // Accept selected exercises

  ExercisesScreen({required this.selectedExercises});

  @override
  State<ExercisesScreen> createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen> {
  List<dynamic> exercises = []; // Exercises list from API
  late List<bool> isSelected = []; // Track selected exercises

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  // Load exercises from the server
  void _loadExercises() async {
    try {
      final fetchedExercises = await ApiService.fetchExercises();
      setState(() {
        exercises = fetchedExercises;
        isSelected = List<bool>.filled(exercises.length, false); // Track selection

        // Preselect already selected exercises
        for (int i = 0; i < exercises.length; i++) {
          if (widget.selectedExercises.contains(exercises[i]['name'])) {
            isSelected[i] = true;
          }
        }
      });
    } catch (e) {
      // Show error if the fetch fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load exercises: $e')),
      );
    }
  }

  // Save selected exercises and pass them back
  void _saveSelectedExercises() {
    List<String> selected = [];
    for (int i = 0; i < exercises.length; i++) {
      if (isSelected[i]) {
        selected.add(exercises[i]['name']);
      }
    }
    Navigator.pop(context, selected); // Pass selected exercises back
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercises', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            // Exercise list
            Expanded(
              child: exercises.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  final exercise = exercises[index];
                  return ListTile(
                    leading: exercise['imageUrl'] != null
                        ? Image.network(exercise['imageUrl'], width: 50, height: 50)
                        : const Icon(Icons.image),
                    title: Text(exercise['name'] ?? 'No Name'),
                    trailing: Checkbox(
                      value: isSelected[index],
                      onChanged: (bool? value) {
                        setState(() {
                          isSelected[index] = value ?? false;
                        });
                      },
                    ),
                    onTap: () {
                      _showExerciseDetails(context, exercise);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveSelectedExercises, // Save and return to create workout screen
        child: Icon(Icons.save),
        backgroundColor: Colors.orange,
      ),
    );
  }

  // Show exercise details in a modal
  void _showExerciseDetails(BuildContext context, Map<String, dynamic> exercise) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.close,
                        size: 30,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Text(
                  exercise['name'] ?? 'No Name',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 10),
                exercise['imageUrl'] != null
                    ? Image.network(exercise['imageUrl'], height: 200)
                    : const Icon(Icons.image, size: 100), // Nếu không có hình ảnh, hiển thị biểu tượng thay thế
                const SizedBox(height: 10),
                const Text(
                  'Muscle Group',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 5),
                Text(
                  exercise['muscle'] ?? 'Not specified',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}
