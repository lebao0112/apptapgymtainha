import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Image caching

class ExploreScreen extends StatelessWidget {
  // Dữ liệu mẫu về những người nổi tiếng và bài tập
  final List<Map<String, String>> celebrities = [
    {
      'name': 'The Rock',
      'description':
          'Bài viết về Dwayne "The Rock" Johnson - Một trong những người nổi tiếng về thể hình và sự nghiệp điện ảnh.',
      'image':
          'https://ss-images.saostar.vn/pc/1647655548913/saostar-htgx321mf6ofgwii.jpg',
    },
    {
      'name': 'Chris Hemsworth',
      'description':
          'Bài viết về Chris Hemsworth - Diễn viên nổi tiếng với vai Thor, có chương trình tập luyện riêng.',
      'image':
          'https://www.dmoose.com/cdn/shop/articles/1main_a2db1e23-aafb-4157-95ac-11a4d8a131cc.jpg?v=1652282285',
    },
    {
      'name': 'Arnold Schwarzenegger',
      'description':
          'Bài viết về Arnold - Huyền thoại thể hình và cựu thống đốc bang California.',
      'image':
          'https://cdn.tuoitre.vn/thumb_w/480/471584752817336320/2023/10/16/austrian-born-bodybuilder-arnold-schwarzenegger-points-one-news-photo-1584730817-1697437182191183755011.jpg',
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
    {
      'name': 'Tăng cơ',
      'image': 'https://toshiko.vn/storage/images/2022/06/cach-tang-co-bap.jpg'
    },
    {
      'name': 'Giảm cân',
      'image':
          'https://cdn.tgdd.vn/2021/03/CookProduct/5-bi-quyet-giup-giam-can-ma-khong-anh-huong-den-kich-thuoc-vong-1-adobestock164981310-1200x676.jpg'
    },
    {
      'name': 'Yoga',
      'image':
          'https://suckhoedoisong.qltns.mediacdn.vn/thumb_w/1200/324455921873985536/2021/8/11/thumb-yoga-1628687976676825148972-1628687980379839846629.jpg'
    },
    {
      'name': 'Cardio',
      'image': 'https://blogmevabe.info/photo/bai-tap-cardio-la-gi.jpg'
    },
  ];

  final List<Map<String, String>> challenges = [
    {
      'name': '7 ngày tăng cơ',
      'description': 'Thử thách tập luyện trong 7 ngày để tăng cơ nhanh chóng.'
    },
    {
      'name': '30 ngày giảm cân',
      'description': 'Thử thách tập luyện liên tục trong 30 ngày để giảm cân.'
    },
    {
      'name': 'Thử thách cardio',
      'description': 'Chương trình tập luyện cardio để tăng cường sức bền.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('KHÁM PHÁ', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(
                'Bài viết về cách tập luyện của người nổi tiếng'),
            _buildHorizontalList(celebrities, _buildCelebrityCard),
            _buildSectionTitle('Bài tập của người nổi tiếng'),
            _buildVerticalList(workouts, _buildWorkoutCard),
            _buildSectionTitle('Thể loại bài tập'),
            _buildHorizontalList(categories, _buildCategoryCard),
          ],
        ),
      ),
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

  // Horizontal ListView builder
  Widget _buildHorizontalList(
      List<Map<String, String>> items, Function itemBuilder) {
    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return itemBuilder(items[index]);
        },
      ),
    );
  }

  // Vertical ListView builder
  Widget _buildVerticalList(
      List<Map<String, String>> items, Function itemBuilder) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return itemBuilder(items[index]);
      },
    );
  }

  // Celebrity Card
  Widget _buildCelebrityCard(Map<String, String> celebrity) {
    return Container(
      width: 200,
      margin: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCachedNetworkImage(celebrity['image']!, 150, 200),
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

  // Workout Card
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
          // Handle tap event
        },
      ),
    );
  }

  // Category Card
  Widget _buildCategoryCard(Map<String, String> category) {
    return Container(
      width: 150,
      margin: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCachedNetworkImage(category['image']!, 100, 150),
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

  // Challenge Card

  // Cached Network Image for better performance
  Widget _buildCachedNetworkImage(
      String imageUrl, double height, double width) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        height: height,
        width: width,
        fit: BoxFit.cover,
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
    );
  }
}
