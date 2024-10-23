import 'package:flutter/material.dart';
import '../service/api_service.dart';
import 'exercise_screen.dart';
import 'package:input_quantity/input_quantity.dart';

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
  List<double> _selectedReps = [];
  List<double> _selectedDurations = [];

  // void _addWorkout() async {
  //   if (_formKey.currentState!.validate()) {
  //     try {
  //       final existingWorkouts = await ApiService.fetchUserWorkouts();
  //       if (existingWorkouts
  //           .any((workout) => workout['Title'] == _titleController.text)) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text('Workout title already exists')),
  //         );
  //         return;
  //       }
  //       Map<String, dynamic> workoutData = {
  //         'Title': _titleController.text,
  //         'Description': _descriptionController.text,
  //         'Exercises': _selectedExerciseIds,
  //       };
  //       await ApiService.addWorkoutWithToken(workoutData);
  //       Navigator.pop(context, true);
  //     } catch (e) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Failed to add workout: $e')),
  //       );
  //     }
  //   }
  // }
void _addWorkout() async {
    if (_formKey.currentState!.validate()) {
      try {
        final existingWorkouts = await ApiService.fetchUserWorkouts();
        if (existingWorkouts
            .any((workout) => workout['Title'] == _titleController.text)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Workout title already exists')),
          );
          return;
        }
        List<Map<String, dynamic>> exercisesData = _selectedExerciseIds
            .asMap()
            .entries
            .map((entry) => {
                  'exerciseId': entry.value,
                  'reps': _selectedReps[entry.key],
                  'duration': _selectedDurations[entry.key],
                })
            .toList();

        Map<String, dynamic> workoutData = {
          'Title': _titleController.text,
          'Description': _descriptionController.text,
          'Exercises': exercisesData, // Lưu reps và duration cùng bài tập
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
        _selectedExerciseIds =
            selectedExercises.map((exercise) => exercise['id']!).toList();
        _selectedExerciseNames =
            selectedExercises.map((exercise) => exercise['name']!).toList();
      });
       _selectedReps =
          List.filled(_selectedExerciseIds.length, 1); // Reps mặc định là 1
      _selectedDurations = List.filled(_selectedExerciseIds.length, 30);
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
      body: SingleChildScrollView(
        // Bao bọc nội dung trong SingleChildScrollView
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
                // SizedBox(height: 20),
                // _selectedExerciseNames.isNotEmpty
                //     ? Column(
                //         children: _selectedExerciseNames
                //             .map((name) => buildExerciseListItem(name))
                //             .toList(),
                //       )
                //     : Text("No exercises selected"),
                SizedBox(height: 20),
                _selectedExerciseNames.isNotEmpty
                    ? Column(
                        children: _selectedExerciseNames
                            .asMap() // asMap để có thể lấy được index của từng bài tập
                            .entries
                            .map((entry) =>
                                buildExerciseListItem(entry.value, entry.key))
                            .toList(),
                      )
                    : Text("No exercises selected"),
                SizedBox(height: 20),
          
                ElevatedButton(
                  onPressed: _selectExercises,
                  child: Text('Add Exercises'),
                ),
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

Widget buildExerciseListItem(String name, int index) {
    return Container(
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(5.0),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 12.0,
                ),
              ),
              SizedBox(width: 8),
              Container(
                width: 150,
                child: Text(
                  name, // Name of exercise
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ],
          ),
          Row(
            children: [
              // Input cho số reps
              Column(
                children: [
                  InputQty(
                    maxVal: 999,
                    initVal:
                        _selectedReps[index] ?? 1, // Giá trị khởi tạo từ danh sách reps
                    minVal: 1,
                    steps: 1,
                    onQtyChanged: (val) {
                      setState(() {
                        _selectedReps[index] = val;
                      });
                    },
                    decoration: const QtyDecorationProps(
                        qtyStyle: QtyStyle.classic,
                        isBordered: false,
                        borderShape: BorderShapeBtn.none,
                        orientation: ButtonOrientation.horizontal,
                        btnColor: Colors.orange),
                  ),
                  SizedBox(width: 8),
                  // Input cho duration
                  InputQty(
                    maxVal: 999,
                    initVal: _selectedDurations[
                        index], // Giá trị khởi tạo từ danh sách duration
                    minVal: 1,
                    steps: 1,
                    onQtyChanged: (val) {
                      setState(() {
                        _selectedDurations[index] = val;
                      });
                    },
                    decoration: const QtyDecorationProps(
                        qtyStyle: QtyStyle.classic,
                        isBordered: false,
                        borderShape: BorderShapeBtn.none,
                        orientation: ButtonOrientation.horizontal,
                        btnColor: Colors.orange),
                  ),
                ],
              ),
              
            ],
          ),
        ],
      ),
    );
  }


  // Widget buildExerciseListItem(String name) {
  //   return Container(
  //     height: 70,
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Row(
  //           children: [
  //             Container(
  //               padding:
  //                   EdgeInsets.all(5.0), 
  //               decoration: BoxDecoration(
  //                 color: Colors.red, 
  //                 shape: BoxShape.circle, 
  //               ),
  //               child: Icon(
  //                 Icons.close,
  //                 color: Colors.white, 
  //                 size: 12.0,
  //               ),
  //             ),
  //              SizedBox(width: 8),
  //             Image.network(
  //               "https://th.bing.com/th/id/OIP.TQd73ag_0yxBBczYB7RFwgHaE8?w=257&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7", // Đường dẫn ảnh từ URL
  //               width: 40, 
  //               height: 40,
  //               fit: BoxFit.cover, 
  //             ),
  //             SizedBox(width: 8), 
  //              Container(
  //               width: 150, 
  //               child: Text(
  //                 name,
  //                 maxLines: 1, // Giới hạn tên chỉ hiển thị 1 dòng
  //                 overflow: TextOverflow
  //                     .ellipsis, // Hiển thị dấu ba chấm nếu tên quá dài
  //                 style: TextStyle(fontSize: 16, color: Colors.black),
  //               ),
  //             ),
  //           ],
  //         ),
          
  //         Row(
  //           children: [
  //             // InputQty(
  //             //   maxVal: 99999,
  //             //   initVal: 1,
  //             //   minVal: 1,
  //             //   steps: 1,
  //             //   onQtyChanged: (val) {
  //             //     print(val);
  //             //   },
  //             //   decoration: const QtyDecorationProps(
  //             //       qtyStyle: QtyStyle.classic,
  //             //       isBordered: false,
  //             //       borderShape: BorderShapeBtn.none,
  //             //       orientation: ButtonOrientation.horizontal,
  //             //       btnColor: Colors.orange
  //             //       ),
  //             // ),
  //             Icon(Icons.dehaze)
  //           ],
  //         ),
          
  //       ],
  //     ),
  //   );
  // }
}
