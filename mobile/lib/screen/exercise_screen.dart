import 'package:flutter/material.dart';
import '../service/api_service.dart'; // Import ApiService cho API calls

class ExercisesScreen extends StatefulWidget {
  const ExercisesScreen({super.key});

  @override
  State<ExercisesScreen> createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen> {
  List<dynamic> exercises = []; // Danh sách bài tập từ API
  late List<bool> isSelected = [];

  @override
  void initState() {
    super.initState();
    _loadExercises(); // Load exercises khi khởi tạo màn hình
  }

  // Hàm load exercises từ server
  void _loadExercises() async {
    try {
      final fetchedExercises = await ApiService.fetchExercises();
      setState(() {
        exercises = fetchedExercises;
        isSelected = List<bool>.filled(exercises.length, false); // Khởi tạo trạng thái chọn
      });
    } catch (e) {
      // Hiển thị thông báo lỗi nếu lấy dữ liệu thất bại
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load exercises: $e')),
      );
    }
  }

  // Hàm hiển thị chi tiết bài tập
  void _showExerciseDetails(BuildContext context, Map<String, dynamic> exercise) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CÁC BÀI TẬP', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            // Danh sách các bài tập
            Expanded(
              child: exercises.isEmpty
                  ? const Center(child: CircularProgressIndicator()) // Hiển thị loading nếu chưa có dữ liệu
                  : ListView.builder(
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  final exercise = exercises[index];
                  return ListTile(
                    leading: exercise['imageUrl'] != null
                        ? Image.network(
                      exercise['imageUrl'],
                      width: 50,
                      height: 50,
                    )
                        : const Icon(Icons.image), // Nếu không có hình ảnh, hiển thị biểu tượng thay thế
                    title: Text(
                      exercise['name'] ?? 'No Name',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Đặt màu chữ thành màu đen
                      ),
                    ),
                    subtitle: Text(
                      exercise['muscle'] ?? 'Not specified',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey, // Đặt màu chữ thành màu xám đậm hơn
                      ),
                    ),
                    trailing: Checkbox(
                      value: isSelected[index],
                      onChanged: (bool? value) {
                        setState(() {
                          isSelected[index] = value ?? false;
                        });
                      },
                      activeColor: Colors.orange,
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
        onPressed: () {
          _showAddExerciseModal(context);
        },
        child: Icon(Icons.check),
        backgroundColor: Colors.orange,
      ),
    );
  }

  // Hàm hiển thị modal để thêm bài tập mới
  void _showAddExerciseModal(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController categoryController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              top: 16,
              left: 16,
              right: 16),
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
              const Text(
                'Add New Exercise',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Exercise Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Thêm bài tập mới vào danh sách
                  setState(() {
                    exercises.add({
                      'name': nameController.text,
                      'muscle': categoryController.text,
                      'imageUrl': 'default.png',
                    });
                    isSelected.add(false);
                  });
                  Navigator.pop(context); // Đóng modal sau khi thêm
                },
                child: const Text('Add Exercise'),
              ),
            ],
          ),
        );
      },
    );
  }
}
