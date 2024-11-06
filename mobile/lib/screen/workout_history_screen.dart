import 'package:doan_tapgymtainha/provider/workout_timer_provider.dart';
import 'package:doan_tapgymtainha/screen/workoutdetail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../provider/workout_provider.dart';
import '../service/api_service.dart';

class WorkoutHistoryScreen extends StatefulWidget {
  @override
  _WorkoutHistoryScreenState createState() => _WorkoutHistoryScreenState();
}

class _WorkoutHistoryScreenState extends State<WorkoutHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    final workoutHistoryProvider = Provider.of<WorkoutTimerProvider>(context);
    final histories = workoutHistoryProvider.histories;

    final groupedHistory = _groupHistoriesByDate(histories);

    return Scaffold(
      appBar: AppBar(
        title: Text('Lịch sử tập luyện'),
        backgroundColor: Colors.orange,
      ),
      body: workoutHistoryProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: groupedHistory.length,
        itemBuilder: (context, index) {
          final date = groupedHistory.keys.elementAt(index);
          final workouts = groupedHistory[date] ?? [];

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
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                SizedBox(height: 8),
                // Hiển thị danh sách workout của ngày đó
                Column(
                  children: workouts.map((workout) {
                    // return Card(
                    //   elevation: 2,
                    //   margin: const EdgeInsets.symmetric(vertical: 4),
                    //   child: ListTile(
                    //     title: Text(
                    //       workout['Name'] ?? 'Unnamed Workout',
                    //       style: TextStyle(
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //     ),
                    //     subtitle: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: [
                    //         Text(
                    //             "Thời gian: ${workout['TotalTime'] ?? '00:00'}",
                    //
                    //         ),
                    //         Text("Calories: ${workout['Talories'] ?? 0} kcal"),
                    //       ],
                    //     ),
                    //   ),
                    // );
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Icon hoặc hình ảnh minh họa cho buổi tập
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.orangeAccent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.fitness_center,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 12),

                            // Thông tin chi tiết buổi tập
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    workout['Name'] ?? 'Unnamed Workout',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Theme.of(context).textTheme.bodyLarge?.color,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Thời gian tập luyện
                                      Row(
                                        children: [
                                          Icon(Icons.timer, size: 16, color: Colors.grey),
                                          SizedBox(width: 4),
                                          Text(
                                            "Thời gian: ${workout['TotalTime'] ?? '00:00'}",
                                            style: TextStyle(
                                              color: Theme.of(context).textTheme.bodyLarge?.color,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Lượng calo
                                      Row(
                                        children: [
                                          Icon(Icons.local_fire_department, size: 16, color: Colors.redAccent),
                                          SizedBox(width: 4),
                                          Text(
                                            "Calories: ${workout['Calories'] ?? 0} kcal",
                                            style: TextStyle(
                                              color: Theme.of(context).textTheme.bodyLarge?.color,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
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

  // Hàm để nhóm lịch sử theo ngày và sắp xếp giảm dần
  // Map<String, List<Map<String, dynamic>>> _groupHistoriesByDate(List<dynamic> histories) {
  //   // Khởi tạo một Map để lưu trữ lịch sử tập luyện được nhóm theo ngày
  //   final Map<String, List<Map<String, dynamic>>> groupedHistory = {};
  //
  //   // Lặp qua từng lịch sử trong danh sách histories
  //   for (var history in histories) {
  //     // Lấy ngày từ trường 'Date' của mỗi lịch sử và định dạng thành chuỗi 'yyyy-MM-dd'
  //     // Sử dụng DateTime.now() làm giá trị mặc định nếu trường 'Date' không hợp lệ hoặc là null
  //     final date = DateFormat('dd-MM-yyyy').format(
  //         DateTime.tryParse(history['Date'] ?? '') ?? DateTime.now());
  //
  //     // Nếu Map chưa có key cho ngày này, khởi tạo một danh sách trống
  //     if (!groupedHistory.containsKey(date)) {
  //       groupedHistory[date] = [];
  //     }
  //
  //     // Thêm thông tin buổi tập vào danh sách của ngày tương ứng
  //     groupedHistory[date]!.add({
  //       'Name': history['WorkoutName'] ?? 'Unnamed Workout',  // Tên buổi tập, dùng tên mặc định nếu null
  //       'TotalTime': history['TotalTime'] ?? '00:00',         // Thời gian tập, dùng '00:00' nếu null
  //       'Calories': history['Calories'] ?? 0,                 // Lượng calo, dùng 0 nếu null
  //     });
  //   }
  //
  //   // Sắp xếp ngày theo thứ tự giảm dần
  //   // Tạo danh sách các ngày và sắp xếp theo thứ tự từ mới nhất đến cũ nhất
  //   final sortedKeys = groupedHistory.keys.toList()..sort((a, b) => b.compareTo(a));
  //
  //   // Trả về Map đã được sắp xếp theo thứ tự ngày giảm dần
  //   return {for (var key in sortedKeys) key: groupedHistory[key]!};
  // }

  Map<String, List<Map<String, dynamic>>> _groupHistoriesByDate(List<dynamic> histories) {
    // Khởi tạo một Map để lưu trữ lịch sử tập luyện được nhóm theo ngày
    final Map<String, List<Map<String, dynamic>>> groupedHistory = {};

    // Lặp qua từng lịch sử trong danh sách histories
    for (var history in histories) {
      // Lấy ngày từ trường 'Date' của mỗi lịch sử và định dạng thành chuỗi 'yyyy-MM-dd'
      final date = DateFormat('dd-MM-yyyy').format(
          DateTime.tryParse(history['Date'] ?? '') ?? DateTime.now());

      // Nếu Map chưa có key cho ngày này, khởi tạo một danh sách trống
      if (!groupedHistory.containsKey(date)) {
        groupedHistory[date] = [];
      }

      // Thêm thông tin buổi tập vào danh sách của ngày tương ứng
      groupedHistory[date]!.add({
        'Name': history['WorkoutName'] ?? 'Unnamed Workout',  // Tên buổi tập, dùng tên mặc định nếu null
        'TotalTime': history['TotalTime'] ?? '00:00',         // Thời gian tập, dùng '00:00' nếu null
        'Calories': history['Calories'] ?? 0,                 // Lượng calo, dùng 0 nếu null
        'DateTime': DateTime.tryParse(history['Date'] ?? '') ?? DateTime.now() // Lưu lại DateTime để sắp xếp
      });
    }

    // Sắp xếp ngày theo thứ tự giảm dần
    final sortedKeys = groupedHistory.keys.toList()..sort((a, b) => b.compareTo(a));

    // Sắp xếp buổi tập trong mỗi ngày theo thứ tự thời gian giảm dần
    for (var key in sortedKeys) {
      groupedHistory[key]!.sort((a, b) => b['DateTime'].compareTo(a['DateTime']));
    }

    // Loại bỏ trường 'DateTime' khỏi mỗi buổi tập trước khi trả về kết quả
    for (var key in groupedHistory.keys) {
      groupedHistory[key] = groupedHistory[key]!.map((workout) {
        workout.remove('DateTime');
        return workout;
      }).toList();
    }

    // Trả về Map đã được sắp xếp theo thứ tự ngày giảm dần
    return {for (var key in sortedKeys) key: groupedHistory[key]!};
  }

}
