import 'package:doan_tapgymtainha/provider/post_provider.dart';
import 'package:doan_tapgymtainha/screen/forum/create_post_screen.dart';
import 'package:doan_tapgymtainha/screen/forum/media_viewer_screen.dart';
import 'package:doan_tapgymtainha/screen/forum/search_post_screen.dart';
import 'package:doan_tapgymtainha/service/api_user_service.dart';
import 'package:doan_tapgymtainha/widget/like_button.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class NewsfeedScreen extends StatefulWidget {
  const NewsfeedScreen({super.key});

  @override
  State<NewsfeedScreen> createState() => _NewFeedScreenState();
}

class _NewFeedScreenState extends State<NewsfeedScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMorePost = false;
  // List<dynamic> posts = [];
  //
  @override
  void initState() {
    super.initState();

    // Gắn listener vào ScrollController để lắng nghe sự kiện cuộn
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // Nếu đã cuộn đến cuối danh sách, tải thêm dữ liệu
        _loadMorePosts();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMorePosts() async {
    if (!_isLoadingMorePost) {
      setState(() {
        _isLoadingMorePost = true;
      });

      final postProvider = Provider.of<PostProvider>(context, listen: false);
      await postProvider.loadMorePosts(); // Gọi hàm trong Provider để tải thêm dữ liệu

      setState(() {
        _isLoadingMorePost = false;
      });
    }
  }

  Future<void> _refreshPosts() async {
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    await postProvider.loadPosts(); // Gọi Provider để tải lại dữ liệu
  }

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

  String formatDateTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString).toLocal(); // Chuyển về local time
    DateTime now = DateTime.now();

    Duration difference = now.difference(dateTime);

    if (difference.inDays == 0) { // Ngày hôm nay
      if (difference.inMinutes < 60) {
        return "${difference.inMinutes} phút trước";
      } else {
        return "${difference.inHours} giờ trước";
      }
    } else { // Không phải hôm nay
      return DateFormat('dd/MM/yyyy').format(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);
    final posts = postProvider.posts;

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
      // body: RefreshIndicator(
      //   onRefresh: _refreshPosts,
      //   color: Colors.orange,
      //   child: SingleChildScrollView(
      //     child: Column(
      //       children: [
      //         for (var post in posts)
      //           _buildPostCard(post),
      //       ],
      //     ),
      //   ),
      // ),
      body: RefreshIndicator(
        onRefresh: _refreshPosts,
        color: Colors.orange,
        child: ListView.builder(
          controller: _scrollController, // Gắn ScrollController
          itemCount: posts.length + 1, // Thêm 1 để hiển thị loading indicator
          itemBuilder: (context, index) {
            if (index < posts.length) {
              // Hiển thị bài viết
              return _buildPostCard(posts[index]);
            } else {
              // Hiển thị loading indicator khi đang tải thêm
              return _isLoadingMorePost
                  ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              )
                  : SizedBox.shrink(); // Không hiển thị gì nếu không tải
            }
          },
        ),
      ),
    );
  }

  Widget _buildPostCard(Map<String, dynamic> post) {
    Map<String, dynamic> userinfo = post["userinfo"];
    var username = userinfo["Name"];
    bool isLiked = true;
    return   Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Stack(
        children: [
          // Nội dung chính của Container
          Column(
            children: <Widget>[
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
                        username ?? "username",
                        style: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                            fontSize: 20, fontWeight: FontWeight.bold),

                      ),
                      Text(
                        formatDateTime(post["CreatedAt"]),
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
                  post["Content"],
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

                  child: _buildMediaLayout(post["MediaUrls"].cast<String>()),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  LikeButton(postId: post["_id"], likeCount: post["Likes"], isLiked: post["isLiked"]),
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {

                        },
                        icon:  Icon(Icons.comment_bank_outlined, color: Theme.of(context).textTheme.bodyLarge?.color),
                      ),
                      Text(
                        '3',
                        style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: 14),
                      ),
                    ],
                  )

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
    );
  }

  Widget _buildMediaLayout(List<String> mediaUrls) {
    if(mediaUrls.length == 0){
      return Container(

      );
    }else if(mediaUrls.length == 1) {
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
