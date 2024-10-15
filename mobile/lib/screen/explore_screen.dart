import 'package:flutter/material.dart';

class ExploreScreen extends StatelessWidget {
  // Dữ liệu mẫu về những người nổi tiếng và bài tập
  final List<Map<String, String>> celebrities = [
    {
      'name': 'The Rock',
      'description': 'Bài viết về Dwayne "The Rock" Johnson - Một trong những người nổi tiếng về thể hình và sự nghiệp điện ảnh.',
      'image': 'assets/the_rock.jpg',
    },
    {
      'name': 'Chris Hemsworth',
      'description': 'Bài viết về Chris Hemsworth - Diễn viên nổi tiếng với vai Thor, có chương trình tập luyện riêng.',
      'image': 'assets/chris_hemsworth.jpg',
    },
    {
      'name': 'Arnold Schwarzenegger',
      'description': 'Bài viết về Arnold - Huyền thoại thể hình và cựu thống đốc bang California.',
      'image': 'assets/arnold.jpg',
    },
  ];

  final List<Map<String, String>> workouts = [
    {
      'workout': 'Full Body Strength',
      'celebrity': 'The Rock',
    },
    {
      'workout': 'Thor Workout',
      'celebrity': 'Chris Hemsworth',
    },
    {
      'workout': 'Classic Bodybuilding',
      'celebrity': 'Arnold Schwarzenegger',
    },
  ];

  final List<Map<String, String>> categories = [
    {'name': 'Tăng cơ', 'image': 'assets/muscle_gain.jpg'},
    {'name': 'Giảm cân', 'image': 'assets/weight_loss.jpg'},
    {'name': 'Yoga', 'image': 'assets/yoga.jpg'},
    {'name': 'Cardio', 'image': 'assets/cardio.jpg'},
  ];

  final List<Map<String, String>> challenges = [
    {'name': '7 ngày tăng cơ', 'description': 'Thử thách tập luyện trong 7 ngày để tăng cơ nhanh chóng.'},
    {'name': '30 ngày giảm cân', 'description': 'Thử thách tập luyện liên tục trong 30 ngày để giảm cân.'},
    {'name': 'Thử thách cardio', 'description': 'Chương trình tập luyện cardio để tăng cường sức bền.'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('KHÁM PHÁ', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Bài viết về cách tập luyện của người nổi tiếng'),
            SizedBox(
              height: 250,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: celebrities.length,
                itemBuilder: (context, index) {
                  return _buildCelebrityCard(celebrities[index]);
                },
              ),
            ),
            _buildSectionTitle('Bài tập của người nổi tiếng'),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: workouts.length,
              itemBuilder: (context, index) {
                return _buildWorkoutCard(workouts[index]);
              },
            ),
            _buildSectionTitle('Thể loại bài tập'),
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return _buildCategoryCard(categories[index]);
                },
              ),
            ),
            _buildSectionTitle('Thử thách'),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: challenges.length,
              itemBuilder: (context, index) {
                return _buildChallengeCard(challenges[index]);
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
    );
  }

  // Hàm hiển thị tiêu đề cho từng phần
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  // Thẻ (card) cho người nổi tiếng
  Widget _buildCelebrityCard(Map<String, String> celebrity) {
    return Container(
      width: 200,
      margin: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Image.asset(
              celebrity['image']!,
              fit: BoxFit.cover,
              height: 150,
              width: 200,
            ),
          ),
          SizedBox(height: 8),
          Text(
            celebrity['name']!,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4),
          Text(
            celebrity['description']!,
            style: TextStyle(color: Colors.grey[400]),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // Thẻ (card) cho bài tập người nổi tiếng
  Widget _buildWorkoutCard(Map<String, String> workout) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
        ),
        title: Text(
          workout['workout']!,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          'Người nổi tiếng: ${workout['celebrity']}',
          style: TextStyle(color: Colors.grey[400]),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
        onTap: () {
          // Xử lý sự kiện khi người dùng bấm vào bài tập
        },
      ),
    );
  }

  // Thẻ (card) cho các loại bài tập
  Widget _buildCategoryCard(Map<String, String> category) {
    return Container(
      width: 150,
      margin: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Image.asset(
              category['image']!,
              fit: BoxFit.cover,
              height: 100,
              width: 150,
            ),
          ),
          SizedBox(height: 8),
          Text(
            category['name']!,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // Thẻ (card) cho các thử thách
  Widget _buildChallengeCard(Map<String, String> challenge) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        title: Text(
          challenge['name']!,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          challenge['description']!,
          style: TextStyle(color: Colors.grey[400]),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
        onTap: () {
          // Xử lý sự kiện khi người dùng bấm vào thử thách
        },
      ),
    );
  }
}

