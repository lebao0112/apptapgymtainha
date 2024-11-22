import 'package:doan_tapgymtainha/screen/forum/create_post_screen.dart';
import 'package:doan_tapgymtainha/screen/forum/media_viewer_screen.dart';
import 'package:doan_tapgymtainha/screen/forum/search_post_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class NewsfeedScreen extends StatefulWidget {
  const NewsfeedScreen({super.key});

  @override
  State<NewsfeedScreen> createState() => _NewFeedScreenState();
}

class _NewFeedScreenState extends State<NewsfeedScreen> {

  void goToScreen(BuildContext context, Widget screen){
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'DIỄN ĐÀN',
          style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(onPressed: () {
                  goToScreen(context, SearchPostScreen());
                }, icon: Icon(Icons.search)),
                IconButton(onPressed: () {
                  goToScreen(context, CreatePostScreen());
                }, icon: Icon(Icons.add)),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Stack(
                children: [
                  // Nội dung chính của Container
                  Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.grey.shade800,
                            backgroundImage: AssetImage("assets/default_avatar.png"),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'User name',
                                style: TextStyle(
                                    color: Theme.of(context).textTheme.bodyLarge?.color,
                                    fontSize: 20, fontWeight: FontWeight.bold),
        
                              ),
                              Text(
                                'Hôm nay',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          'Đây là nội dung của bài post. Bạn có thể thêm bất kỳ nội dung nào bạn muốn ở đây, như văn bản, hình ảnh, hoặc các widget khác.',
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      // Container cho ảnh và media
                      GestureDetector(
                        onTap: () {
                          goToScreen(context, MediaViewerScreen());
                        },
                        child: Container(

                          child: _buildMediaLayout([
                            'https://via.placeholder.com/150',
                            'https://via.placeholder.com/200',
                            'https://via.placeholder.com/250',
                            'https://via.placeholder.com/300',
                                'https://via.placeholder.com/300',
                                'https://via.placeholder.com/300',
                          ]),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Icon(Icons.thumb_up_alt_outlined, color: Theme.of(context).textTheme.bodyLarge?.color),
                              SizedBox(height: 4),
                              Text(
                                '100',
                                style: TextStyle(color: Colors.white, fontSize: 14),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Icon(Icons.comment_bank_outlined, color: Theme.of(context).textTheme.bodyLarge?.color),
                              SizedBox(height: 4),
                              Text(
                                '2200',
                                style: TextStyle(color: Colors.white, fontSize: 14),
                              ),
                            ],
                          ), Column(
                            children: [
                              Icon(Icons.share_outlined, color: Theme.of(context).textTheme.bodyLarge?.color),
                              SizedBox(height: 4),
                              Text(
                                'Share',
                                style: TextStyle(color: Colors.white, fontSize: 14),
                              ),
                            ],
                          ),

                        ],
                      )
                    ],
                  ),
        
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      onPressed: () {
                        // Xử lý sự kiện khi nhấn nút
                      },
                      icon: Icon(
                        Icons.more_horiz,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaLayout(List<String> mediaUrls) {
    if (mediaUrls.length == 1) {
      // Nếu chỉ có một ảnh
      return ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Image.network(
          mediaUrls[0],
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    } else if (mediaUrls.length == 2) {
      // Nếu có hai ảnh, chia làm 2 cột
      return Row(
        children: mediaUrls.map((url) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network(
                  url,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        }).toList(),
      );
    } else if (mediaUrls.length == 3) {
      // Nếu có ba ảnh
      return Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.network(
              mediaUrls[0],
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 4),
          Row(
            children: mediaUrls.skip(1).map((url) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(
                      url,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      );
    } else {
      // Nếu có nhiều hơn 3 ảnh
      return Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.network(
              mediaUrls[0],
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 4),
          Row(
            children: [
              ...mediaUrls.skip(1).take(2).map((url) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.network(
                        url,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              }).toList(),
              if (mediaUrls.length > 4)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.network(
                            mediaUrls[3],
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          color: Colors.black54,
                          alignment: Alignment.center,
                          child: Text(
                            '+${mediaUrls.length - 3}',
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      );
    }
  }
}
