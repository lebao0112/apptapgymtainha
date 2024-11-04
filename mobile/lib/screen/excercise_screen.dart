import 'package:flutter/material.dart';

class ExercisesScreen extends StatefulWidget {
  const ExercisesScreen({super.key, required List<String> selectedExercises});

  @override
  State<ExercisesScreen> createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen> {
  final List<Map<String, String>> exercises = [
    {'name': 'Ball Slams', 'category': 'Full Body', 'image': 'ballslams.png'},
    {'name': 'Battle Ropes', 'category': 'Cardio', 'image': 'battleropes.png'},
    {'name': 'Bench Dip', 'category': 'Arms', 'image': 'benchdips.png'},
    {
      'name': 'Bench Press (Barbell)',
      'category': 'Chest',
      'image': 'benchpress_barbell.png'
    },
    {
      'name': 'Bench Press (Cable)',
      'category': 'Chest',
      'image': 'benchpress_cable.png'
    },
    {
      'name': 'Bench Press (Dumbbell)',
      'category': 'Chest',
      'image': 'benchpress_dumbbell.png'
    },
  ];

  late List<bool> isSelected = [];

  @override
  void initState() {
    super.initState();
    // Đặt mặc định tất cả các checkbox là "chưa chọn"
    for (var exercise in exercises) {
      isSelected.add(false);
    }
  }

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
            mainAxisSize:
                MainAxisSize.min, // Kích thước nhỏ gọn tùy thuộc nội dung
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
                      'category': categoryController.text,
                      'image':
                          'default.png', // Bạn có thể thay đổi hình ảnh mặc định
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

  // Hàm hiển thị modal với chi tiết bài tập
  void _showExerciseDetails(
      BuildContext context, Map<String, String> exercise) {
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
                  exercise['name']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 10),
                Image.asset('assets/exercises/${exercise["image"]}'),
                const SizedBox(height: 10),
                const Text(
                  'Instructions',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 5),
                const Text(
                  '1. Lie flat on the bench holding the cable handles.\n'
                  '2. Retract scapula and have elbows between 45 to 90 degrees.\n'
                  '3. Lower handles to middle chest.\n'
                  '4. Push handles back towards starting position.\n'
                  '5. Repeat for reps.\n',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String bodyPartFilter = 'Any Body Part';
  String categoryFilter = 'Any Category';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CÁC BÀI TẬP', style: TextStyle(color: Colors.white)),
        centerTitle: true,

        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: const [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Icon(Icons.star, color: Colors.orange),
          ),
        ],
      ),
      backgroundColor: Color.fromARGB(0, 0, 0, 0),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.orange,
                ),
                hintText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(
                    color: Colors.orange,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(
                    color: Colors.orange,
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(
                    color: Colors.orange,
                    width: 2.0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Các nút chọn lọc
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: Text(bodyPartFilter),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      side: BorderSide(color: Colors.orange),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: Text(categoryFilter),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      side: BorderSide(color: Colors.orange),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
            // Danh sách các bài tập
            Expanded(
              child: ListView.builder(
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  final exercise = exercises[index];
                  return ListTile(
                    leading: Image.asset(
                        'assets/exercises/${exercise["image"]}',
                        width: 50,
                        height: 50), // Hình ảnh của bài tập
                    title: Text(
                      exercises[index]['name']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Đặt màu chữ thành màu trắng
                      ),
                    ),
                    subtitle: Text(
                      exercises[index]['category']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(
                            255, 195, 191, 191), // Đặt màu chữ thành màu trắng
                      ),
                    ),

                    trailing: Checkbox(
                      value: isSelected[index],
                      onChanged: (bool? value) {
                        setState(() {
                          isSelected[index] =
                              value ?? false; // Cập nhật trạng thái checkbox
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
        child: Icon(Icons.add),
        backgroundColor: Colors.orange,
      ),
    );
  }
}
