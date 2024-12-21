import 'package:cached_network_image/cached_network_image.dart';
import 'package:doan_tapgymtainha/screen/forum/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'comment_button.dart';
import 'like_button.dart';
import 'media_viewer_screen.dart';

class PostWidget extends StatelessWidget {
  final Map<String, dynamic> post;

  const PostWidget({super.key, required this.post});

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
    DateTime dateTime = DateTime.parse(dateTimeString).toLocal();
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
    Map<String, dynamic> userinfo = post["userinfo"];
    var username = userinfo["Name"];
    var avarUrl = userinfo["AvatarUrl"];
    var userId = userinfo["_id"];
    bool isLiked = true;
    return  Container(
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
              GestureDetector(
                onTap: () {
                  goToScreen(context, UserProfileScreen(userId: userId));
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey.shade800,
                      backgroundImage: (avarUrl != null) ? NetworkImage(avarUrl) : AssetImage("assets/default_avatar.png"),
                    ),
                    const SizedBox(
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
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container( //Caption của bài post
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
                  goToScreen(context, MediaViewerScreen(mediaUrls: List<String>.from(post["MediaUrls"]), username: username));
                },
                child: Container(
                  child: _buildMediaLayout(post["MediaUrls"].cast<String>()),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  LikeButton(postId: post["_id"], likeCount: post["Likes"], isLiked: post["isLiked"]),
                  CommentButton(postId: post["_id"], commentCount: post["Comments"])
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
        child: CachedNetworkImage(
          imageUrl: mediaUrls[0],
          width: double.infinity,
          fit: BoxFit.cover,
          errorWidget: (_, __, ___) {
            return Container(
              color: Colors.grey[200],
              height: 200,
              child: const Center(
                child: Icon(
                  Icons.broken_image,
                  color: Colors.grey,
                  size: 40,
                ),
              ),
            );
          },
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
                child: CachedNetworkImage(
                  imageUrl:  url,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) {
                    return Container(
                      color: Colors.grey[200],
                      height: 200,
                      child: const Center(
                        child: Icon(
                          Icons.broken_image,
                          color: Colors.grey,
                          size: 40,
                        ),
                      ),
                    );
                  },
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
            child: CachedNetworkImage(
              imageUrl: mediaUrls[0],
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              errorWidget: (_, __, ___) => const Center(
                child: Icon(
                  Icons.broken_image,
                  size: 40,
                  color: Colors.grey,
                ),
              ),
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
                    child: CachedNetworkImage(
                      imageUrl: url,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => const Center(
                        child: Icon(
                          Icons.broken_image,
                          size: 40,
                          color: Colors.grey,
                        ),
                      ),
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
            child: CachedNetworkImage(
              imageUrl: mediaUrls[0],
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              errorWidget: (_, __, ___) {
                return Container(
                  color: Colors.grey[200],
                  height: 200,
                  child: const Center(
                    child: Icon(
                      Icons.broken_image,
                      color: Colors.grey,
                      size: 40,
                    ),
                  ),
                );
              },
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
                      child: CachedNetworkImage(
                        imageUrl:  url,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) {
                          return Container(
                            color: Colors.grey[200],
                            height: 200,
                            child: const Center(
                              child: Icon(
                                Icons.broken_image,
                                color: Colors.grey,
                                size: 40,
                              ),
                            ),
                          );
                        },
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
                          child: CachedNetworkImage(
                            imageUrl: mediaUrls[3],
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) {
                              return Image.asset(
                                'assets/default_image.png',
                                fit: BoxFit.cover,

                              );
                            },
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
