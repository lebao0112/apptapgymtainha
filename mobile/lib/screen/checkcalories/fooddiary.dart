import 'package:flutter/material.dart';
import 'trackfoodcalories.dart';
import 'package:doan_tapgymtainha/service/api_service.dart'; // Đừng quên import ApiService
import 'package:intl/intl.dart'; // Để xử lý định dạng ngày

class FoodDiary extends StatefulWidget {
  @override
  _FoodDiaryState createState() => _FoodDiaryState();
}

class _FoodDiaryState extends State<FoodDiary> {

  double totalCaloriesRemaining = 1740;
  List<Map<String, dynamic>> breakfastItems = [];
  List<Map<String, dynamic>> lunchItems = [];
  List<Map<String, dynamic>> dinnerItems = [];
  bool needsUpdateToServer = false;
  DateTime currentDate = DateTime.now();  // Ngày hiện tại
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    print(currentDate);
    // Lấy dữ liệu cho ngày hiện tại khi mở app
    updateFoodDiaryForDate(currentDate);
  }

  // Hàm cập nhật thông tin thực phẩm cho một ngày mới
  Future<void> updateFoodDiaryForDate(DateTime date) async {
    setState(() {
      isLoading = true;
      currentDate = date;
      breakfastItems = [];
      lunchItems = [];
      dinnerItems = [];
      totalCaloriesRemaining = 1740; // Reset calories
    });

    String formattedDate = DateFormat('yyyy-MM-dd').format(date);

    try {
      final response = await ApiService.getFoodDiaryByDate(formattedDate);
      print("khi vào trang ${response}");
      if (response.isNotEmpty) {
        setState(() {
          breakfastItems = List<Map<String, dynamic>>.from(response['breakfast'] ?? []);
          lunchItems = List<Map<String, dynamic>>.from(response['lunch'] ?? []);
          dinnerItems = List<Map<String, dynamic>>.from(response['dinner'] ?? []);

          totalCaloriesRemaining = 1740 -
              (breakfastItems.fold<double>(0, (sum, item) => sum + (item['calories'] as num).toDouble()) +
                  lunchItems.fold<double>(0, (sum, item) => sum + (item['calories'] as num).toDouble()) +
                  dinnerItems.fold<double>(0, (sum, item) => sum + (item['calories'] as num).toDouble()));
        });
      }
    } catch (error) {
      print("Error fetching food diary: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể tải dữ liệu nhật ký thực phẩm.')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Hàm hiển thị ngày trong định dạng (vd: 04/12/2024)
  String getFormattedDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  void addFoodItem(String mealType, Map<String, dynamic> foodItem) async {
    setState(() {
      // Giảm calorie còn lại
      totalCaloriesRemaining -= foodItem['calories'];

      // Thêm món ăn vào danh sách tương ứng
      if (mealType == 'Breakfast') {
        breakfastItems.add(foodItem);
      } else if (mealType == 'Lunch') {
        lunchItems.add(foodItem);
      } else if (mealType == 'Dinner') {
        dinnerItems.add(foodItem);
      }

      // Đánh dấu cần cập nhật server
      needsUpdateToServer = true;
    });

    // Gửi dữ liệu lên server nếu có thay đổi
    if (needsUpdateToServer) {
      try {
        String formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);

        // Gửi dữ liệu đầy đủ của các bữa ăn lên server
        final response = await ApiService.addFoodToDiary({
          'date': formattedDate,
          'breakfast': breakfastItems,
          'lunch': lunchItems,
          'dinner': dinnerItems,
        });

        print("Food diary updated: $response");
        setState(() {
          needsUpdateToServer = false; // Đặt lại trạng thái sau khi cập nhật thành công
        });
      } catch (error) {
        print("Error updating food diary: $error");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không thể cập nhật nhật ký thực phẩm')),
        );
      }
    }
  }



  Widget _buildMealSection(String mealName, List<Map<String, dynamic>> foodItems) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.grey : Colors.grey[300];
    final textColor = isDarkMode ? Colors.white : Colors.black;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        title: Text(
          mealName,
          style: TextStyle( color: textColor, fontSize: 18),

        ),
        trailing: Text(
          '${foodItems.fold<double>(0, (sum, item) => sum + (item['calories'] as num).toDouble()).toStringAsFixed(0)}',
          style: TextStyle(color: textColor, fontSize: 18),
        ),
        children: foodItems.map((food) {
          return ListTile(
            title: Text(
              food['name'],
              style: TextStyle(color: textColor),
            ),
            subtitle: Text(
              '${food['calories']} Cal',
              style: TextStyle(color: textColor),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.grey : Colors.grey[300];
    final textColor = isDarkMode ? Colors.white : Colors.black;
    return Scaffold(
      backgroundColor:Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          'Nhật Ký',
          style: TextStyle( color: Theme.of(context).textTheme.bodyLarge?.color),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Calories Remaining Section
            Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Lượng Calories còn lại',
                        style: TextStyle(color: textColor, fontSize: 18),
                      ),
                      Text(
                        totalCaloriesRemaining.toStringAsFixed(0),
                        style: TextStyle(
                          color: textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            // Date Navigation Section (chuyển ngày)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: textColor),
                  onPressed: () {
                    DateTime previousDate = currentDate.subtract(Duration(days: 1));
                    updateFoodDiaryForDate(previousDate);
                  },
                ),
                Text(
                  getFormattedDate(currentDate),
                  style: TextStyle(
                    color: textColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward_ios, color: textColor),
                  onPressed: () {
                    DateTime nextDate = currentDate.add(Duration(days: 1));
                    updateFoodDiaryForDate(nextDate);
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            // Meals Section
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView(
                children: [
                  _buildMealSection('Buổi sáng', breakfastItems),
                  _buildMealSection('Buổi trưa', lunchItems),
                  _buildMealSection('Buổi tối', dinnerItems),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Điều hướng đến trang TrackFoodCalories và đợi kết quả trả về
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TrackFoodCalories(
                onFoodAdded: addFoodItem,
              ),
            ),
          );

          // Nếu cần xử lý thêm sau khi quay lại
          if (result != null) {
            // Có thể xử lý thêm nếu cần
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
