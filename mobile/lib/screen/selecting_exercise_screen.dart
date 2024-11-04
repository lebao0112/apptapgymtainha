import 'package:flutter/material.dart';
import '../service/api_service.dart'; // Import ApiService cho các gọi API

class SelectingExercisesScreen extends StatefulWidget {
  final List<String> selectedExerciseIds; // Nhận danh sách các exercise đã chọn theo ID

  SelectingExercisesScreen({required this.selectedExerciseIds});

  @override
  State<SelectingExercisesScreen> createState() => _SelectingExercisesScreenState();
}

class _SelectingExercisesScreenState extends State<SelectingExercisesScreen> {
  List<dynamic> exercises = []; // Danh sách bài tập từ API
  late List<bool> isSelected = []; // Theo dõi các bài tập đã được chọn

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  // Tải danh sách các bài tập từ API
  void _loadExercises() async {
    try {
      final fetchedExercises = await ApiService.fetchExercises();
      setState(() {
        exercises = fetchedExercises;
        isSelected = List<bool>.filled(exercises.length, false); // Theo dõi lựa chọn

        // Chọn trước những bài tập đã được chọn
        for (int i = 0; i < exercises.length; i++) {
          if (widget.selectedExerciseIds.contains(exercises[i]['_id'])) {
            isSelected[i] = true;
          }
        }
      });
    } catch (e) {
      // Hiển thị lỗi nếu không tải được dữ liệu
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load exercises: $e')),
      );
    }
  }

  // Lưu các bài tập đã chọn và truyền thông tin lại bằng ID và tên
  void _saveSelectedExercises() {
    List<Map<String, dynamic>> selectedExercises = [];
    for (int i = 0; i < exercises.length; i++) {
      // if (isSelected[i]) {
      //   selectedExercises.add({
      //     'id': exercises[i]['_id'], // Lưu ID
      //     'name': exercises[i]['name'], // Lưu name
      //   });
      // }
      if (isSelected[i]) { // thay thế bằng đoạn code này
        selectedExercises.add(exercises[i]);
      }
    }
    print(selectedExercises); // Kiểm tra log dữ liệu trả về
    Navigator.pop(context, selectedExercises); // Trả danh sách ID và name của bài tập đã chọn
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Giúp giao diện tránh bị che bởi bàn phím
      appBar: AppBar(
        title: Text('Exercises', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            // Hiển thị danh sách bài tập
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
        onPressed: _saveSelectedExercises, // Lưu và quay lại màn hình tạo workout
        child: Icon(Icons.save),
        backgroundColor: Colors.orange,
      ),
    );
  }

  // Hiển thị chi tiết bài tập trong modal
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
