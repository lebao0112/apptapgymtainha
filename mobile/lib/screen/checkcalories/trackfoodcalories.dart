import 'package:dart_openai/dart_openai.dart';
import 'package:doan_tapgymtainha/screen/checkcalories/api_configfood.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:doan_tapgymtainha/service/api_service.dart';
import 'package:intl/intl.dart'; // Import ApiService

class TrackFoodCalories extends StatefulWidget {
  final Function(String, Map<String, dynamic>) onFoodAdded;
  TrackFoodCalories({required this.onFoodAdded});
  @override
  _TrackFoodCaloriesState createState() => _TrackFoodCaloriesState();
}

class _TrackFoodCaloriesState extends State<TrackFoodCalories> {
  final TextEditingController _foodController = TextEditingController();
  List<Map<String, dynamic>> _foodItems = [];
  bool _isLoading = false;

  void _addFoodToMeal(Map<String, dynamic> foodItem) async {
    // Hiển thị chọn loại bữa ăn
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Buổi sáng'),
              onTap: () async {
                Navigator.pop(context);
                await _sendFoodToServer('Breakfast', foodItem);
              },
            ),
            ListTile(
              title: Text('Buổi trưa'),
              onTap: () async {
                Navigator.pop(context);
                await _sendFoodToServer('Lunch', foodItem);
              },
            ),
            ListTile(
              title: Text('Buổi tối'),
              onTap: () async {
                Navigator.pop(context);
                await _sendFoodToServer('Dinner', foodItem);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _sendFoodToServer(String mealType, Map<String, dynamic> foodItem) async {
    try {
      // Gọi callback `onFoodAdded` để thêm món ăn vào `FoodDiary`
      widget.onFoodAdded(mealType, foodItem);

      // Hiển thị thông báo thành công
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã thêm món ăn vào $mealType')),
      );
    } catch (error) {
      print("Error adding food to diary: $error");
      // Hiển thị thông báo lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể thêm món ăn vào $mealType')),
      );
    }
  }



  Future<void> fetchCalories(String foodDescription) async {
    setState(() {
      _isLoading = true;
      _foodItems = [];
    });

    try {
      // Dịch từ tiếng Việt sang tiếng Anh
      String translatedText = await translateTextWithOpenAI(foodDescription);

      // Sau khi dịch, gửi truy vấn đến Nutritionix API
      final String appId = ApiConfigFood.appId;
      final String appKey = ApiConfigFood.appKey;
      final String url = 'https://trackapi.nutritionix.com/v2/natural/nutrients';

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'x-app-id': appId,
          'x-app-key': appKey,
        },
        body: jsonEncode({'query': translatedText}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['foods'] != null && data['foods'].isNotEmpty) {
          final List<Map<String, dynamic>> items = data['foods']
              .map<Map<String, dynamic>>((food) {
            return {
              "quantity": food['serving_qty'],
              "size": food['serving_unit'],
              "name": foodDescription, // Hiển thị tên tiếng Việt
              "calories": food['nf_calories'],
              "fat": food['nf_total_fat'],
              "carbs": food['nf_total_carbohydrate'],
              "protein": food['nf_protein'],
              "image": food['photo']['thumb'] ?? "https://via.placeholder.com/50"
            };
          }).toList();

          setState(() {
            _foodItems = items;
          });
        } else {
          setState(() {
            _foodItems = [];
          });
        }
      } else {
        setState(() {
          _foodItems = [];
        });
      }
    } catch (e) {
      setState(() {
        _foodItems = [];
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String> translateTextWithOpenAI(String inputText) async {
    try {
      final chatCompletion = await OpenAI.instance.chat.create(
        model: "gpt-3.5-turbo",
        messages: [
          OpenAIChatCompletionChoiceMessageModel(
            role: OpenAIChatMessageRole.system,
            content: "You are a translator. Translate the following text from Vietnamese to English.",
          ),
          OpenAIChatCompletionChoiceMessageModel(
            role: OpenAIChatMessageRole.user,
            content: inputText,
          ),
        ],
      );

      // Lấy nội dung từ phản hồi
      return chatCompletion.choices.first.message.content.trim();
    } catch (e) {
      print("Error translating with OpenAI: $e");
      return "Error: Unable to translate";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kiểm tra dinh dưỡng thức ăn"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Nhập mô tả thức ăn:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _foodController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "ví dụ, 1 quả táo, 2 trái trứng",
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                final foodDescription = _foodController.text.trim();
                if (foodDescription.isNotEmpty) {
                  fetchCalories(foodDescription);
                }
              },
              child: Text("Kiểm tra dinh dưỡng"),
            ),
            SizedBox(height: 20),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : _foodItems.isEmpty
                ? Center(child: Text("Không tìm thấy. Hãy nhập mô tả thức ăn."))
                : Expanded(
              child: ListView.builder(
                itemCount: _foodItems.length,
                itemBuilder: (context, index) {
                  final item = _foodItems[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          // Hình ảnh thực phẩm
                          Image.network(
                            item['image'],
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Số lượng và kích thước
                                Row(
                                  children: [
                                    Text(
                                      "${item['quantity']}",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      item['size'],
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                // Tên thực phẩm
                                Text(
                                  item['name'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Lượng calo
                          Row(
                            children: [
                              Text(
                                "${item['calories']} Cal",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              SizedBox(width: 8),
                              // Nút dấu cộng
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () => _addFoodToMeal(item),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
