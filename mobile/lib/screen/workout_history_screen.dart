import 'package:flutter/material.dart';

class WorkoutHistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<WorkoutHistoryScreen> {
  // Danh sách các buổi tập đã hoàn thành, ví dụ giả định
  final List<Map<String, dynamic>> workoutHistory = [
    {
      'date': '2023-11-01',
      'workouts': [
        {
          'name': 'Morning Cardio',
          'totalTime': '30:45',
          'calories': 200,
        },
        {
          'name': 'Evening Strength',
          'totalTime': '45:10',
          'calories': 350,
        },
      ]
    },
    {
      'date': '2023-11-02',
      'workouts': [
        {
          'name': 'Yoga',
          'totalTime': '25:00',
          'calories': 100,
        },
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
        backgroundColor: Colors.orange,
      ),
      body: ListView.builder(
        itemCount: workoutHistory.length,
        itemBuilder: (context, index) {
          final dayHistory = workoutHistory[index];
          final date = dayHistory['date'];
          final workouts = dayHistory['workouts'] as List<Map<String, dynamic>>;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hiển thị ngày
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 8),
                // Hiển thị danh sách workout của ngày đó
                Column(
                  children: workouts.map((workout) {
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        title: Text(
                          workout['name'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Time: ${workout['totalTime']}"),
                            Text("Calories: ${workout['calories']} kcal"),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 16), // Khoảng cách giữa các ngày
              ],
            ),
          );
        },
      ),
    );
  }
}
