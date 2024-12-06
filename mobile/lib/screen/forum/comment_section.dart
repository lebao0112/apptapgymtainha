import 'package:flutter/material.dart';
import 'package:doan_tapgymtainha/model/comment.dart';
import 'package:doan_tapgymtainha/service/api_social_media.dart';

class CommentSection extends StatefulWidget {
  final String postId;

  const CommentSection({super.key, required this.postId});

  @override
  _CommentSectionState createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  late String postId = widget.postId;

  List<Comment> comments = [];
  final TextEditingController _commentController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getCommentsForPost();
  }

  // Lấy danh sách bình luận
  Future<void> _getCommentsForPost() async {
    try {
      final response = await ApiSocialMedia.fetchCommentsForPost(postId);
      setState(() {
        comments = response.comments; // Lấy danh sách bình luận từ API
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load comments')),
      );
    }
  }

  // Hàm thêm bình luận
  void _addComment() async {
    final newComment = _commentController.text.trim();
    if (newComment.isNotEmpty) {
      setState(() {
        comments.add(Comment(
          id: DateTime.now().toString(),
          postId: postId,
          userId: "current_user", // Thay thế bằng ID người dùng hiện tại
          content: newComment,
          parentId: null,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ));
        _commentController.clear();
      });

      // Gửi bình luận mới lên server (tùy chỉnh theo API)
      try {
        // TODO: Gọi API để thêm bình luận nếu cần
        // await ApiSocialMedia.addComment(postId, newComment);
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add comment')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.3,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Color.fromRGBO(59, 61, 62, 1),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Thanh kéo ở trên cùng
              Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Text(
                'Bình luận',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),

              // Danh sách bình luận
              Expanded(
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : comments.isEmpty
                    ? Center(
                  child: Text(
                    'No comments yet.',
                    style: TextStyle(color: Colors.white),
                  ),
                )
                    : ListView.builder(
                  controller: scrollController,
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: comment.avatarUrl != null
                            ? NetworkImage(comment.avatarUrl!) // Hiển thị avatar nếu có
                            : AssetImage('assets/default_avatar.png') as ImageProvider, // Avatar mặc định
                      ),
                      title: Text(
                        comment.name ?? 'Anonymous', // Hiển thị tên người dùng
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        comment.content,
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  },
                ),
              ),

              // Thanh nhập bình luận
              Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 8,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        decoration: InputDecoration(
                          hintText: 'Add a comment...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: _addComment,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
