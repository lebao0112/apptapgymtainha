import 'package:flutter/material.dart';
import 'package:doan_tapgymtainha/model/comment.dart';
import 'package:doan_tapgymtainha/service/api_social_media.dart';
import 'package:provider/provider.dart';

import '../../provider/user_provider.dart';
import 'CommentNode.dart';

class CommentSection extends StatefulWidget {
  final String postId;

  const CommentSection({super.key, required this.postId});

  @override
  _CommentSectionState createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  late String postId = widget.postId;
  late List<CommentNode> commentTree = [];

  List<Comment> comments = [];
  final TextEditingController _commentController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getCommentsForPost();
  }

  // Lấy danh sách bình luận
  // Future<void> _getCommentsForPost() async {
  //   try {
  //     final response = await ApiSocialMedia.fetchCommentsForPost(postId);
  //     setState(() {
  //       comments = response.comments; // Lấy danh sách bình luận từ API
  //       isLoading = false;
  //     });
  //   } catch (error) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Failed to load comments')),
  //     );
  //   }
  // }
  Future<void> _getCommentsForPost() async {
    try {
      final response = await ApiSocialMedia.fetchCommentsForPost(postId);
      setState(() {
        comments = response.comments; // Danh sách bình luận thô
        commentTree = buildCommentTree(comments); // Chuyển thành cây bình luận
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



  void _addComment(UserProvider userProvider) async {
    final userId = userProvider.user?.id;
    final username = userProvider.user?.name;
    final avatarUrl = userProvider.user?.avatarUrl;
    final newComment = _commentController.text.trim();

    if (newComment.isNotEmpty) {
      try {
        // Gửi bình luận lên server
        Comment? comment = await ApiSocialMedia.sendComment(
          postId: postId,
          content: newComment,
        );

        if (comment == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add comment')),
          );
        }

        comment?.avatarUrl = avatarUrl;
        comment?.name = username;

        final newNode = CommentNode(comment: comment!, replies: []);
        setState(() {
          commentTree.insert(0, newNode); //Thêm một comment vào đầu danh sách
          _commentController.clear();
        });
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add comment')),
        );
      }
    }
  }


  void _openReplyDialog(String parentId) {
    final TextEditingController replyController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Trả lời bình luận'),
          content: TextField(
            controller: replyController,
            decoration: InputDecoration(hintText: 'Nhập câu trả lời'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Huỷ'),
            ),
            TextButton(
              onPressed: () async {
                final replyContent = replyController.text.trim();
                if (replyContent.isNotEmpty) {
                  await _sendReply(parentId, replyContent);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Gửi'),
            ),
          ],
        );
      },
    );
  }
  // Future<void> _sendReply(String parentId, String content) async {
  //   final userProvider = Provider.of<UserProvider>(context, listen: false);
  //   final userId = userProvider.user?.id;
  //
  //   final replyComment = Comment(
  //     id: DateTime.now().toString(),
  //     postId: postId,
  //     userId: userId ?? "",
  //     content: content,
  //     parentId: parentId,
  //     createdAt: DateTime.now(),
  //     updatedAt: DateTime.now(),
  //   );
  //
  //   setState(() {
  //     comments.add(replyComment); // Hiển thị trả lời tạm thời
  //   });
  //
  //   try {
  //     final success = await ApiSocialMedia.sendReplyComment(
  //       postId: postId,
  //       content: content,
  //       parentId: parentId,
  //     );
  //
  //     if (!success) {
  //       setState(() {
  //         comments.remove(replyComment); // Xóa trả lời tạm thời nếu thất bại
  //       });
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Failed to send reply')),
  //       );
  //     }
  //   } catch (error) {
  //     setState(() {
  //       comments.remove(replyComment);
  //     });
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Failed to send reply')),
  //     );
  //   }
  // }
  Future<void> _sendReply(String parentId, String content) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.user?.id;
    final username = userProvider.user?.name;
    final avatarUrl = userProvider.user?.avatarUrl;
    // Tạo trả lời tạm thời
    final replyComment = Comment(
      id: DateTime.now().toString(),
      postId: postId,
      userId: userId ?? "",
      content: content,
      parentId: parentId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    CommentNode? parentNode;
    // Tìm parentNode trong commentTree
    void findParentNode(List<CommentNode> nodes) {
      for (var node in nodes) {
        if (node.comment.id == parentId) {
          parentNode = node;
          return;
        }
        findParentNode(node.replies); // Tiếp tục tìm trong các replies
      }
    }

    findParentNode(commentTree);

    if (parentNode != null) {
      try {
        // Gửi trả lời lên server
        Comment? reply = await ApiSocialMedia.sendReplyComment(
          postId: postId,
          content: content,
          parentId: parentId,
        );

        if (reply == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to send reply')),
          );
        }

        reply?.avatarUrl = avatarUrl;
        reply?.name = username;

        final tempNode = CommentNode(comment: reply!, replies: []);
        setState(() {
          parentNode!.replies.add(tempNode); // Thêm trả lời tạm thời
        });
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send reply')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to find parent comment')),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
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
              Expanded(
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : commentTree.isEmpty
                    ? Center(
                  child: Text(
                    'Chưa có bình luận nào.',
                    style: TextStyle(color: Colors.white),
                  ),
                )
                    : SingleChildScrollView(
                  child: buildCommentList(commentTree),
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
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.light
                              ? Colors.black // Văn bản màu đen ở chế độ sáng
                              : Colors.white, // Văn bản màu trắng ở chế độ tối
                        ),
                        decoration: InputDecoration(
                          hintText: 'Thêm bình luận...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Theme.of(context).brightness == Brightness.light
                              ? Colors.grey[200] // Nền xám nhạt ở chế độ sáng
                              : Colors.grey[800], // Nền xám đậm ở chế độ tối
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    IconButton(
                      icon: Icon(
                          Icons.send,
                          color: Colors.orange
                      ),
                      onPressed: () {
                        _addComment(userProvider);
                        FocusScope.of(context).unfocus();
                      },
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

  List<CommentNode> buildCommentTree(List<Comment> comments) {
    Map<String, CommentNode> commentMap = {};

    // Tạo một map để lưu các comment dưới dạng CommentNode
    for (var comment in comments) {
      commentMap[comment.id] = CommentNode(comment: comment, replies: []);
    }

    List<CommentNode> rootComments = [];

    // Tạo cây bình luận
    for (var comment in comments) {
      if (comment.parentId == null) {
        // Bình luận chính (không có ParentId)
        rootComments.add(commentMap[comment.id]!);
      } else {
        // Bình luận trả lời, thêm vào danh sách trả lời của parent
        final parentNode = commentMap[comment.parentId];
        if (parentNode != null) {
          parentNode.replies.add(commentMap[comment.id]!);
        }
      }
    }

    return rootComments;
  }

  Widget buildCommentList(List<CommentNode> commentTree, {double indent = 10}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: commentTree.map((node) {
        return Padding(
          padding: EdgeInsets.only(left: indent),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: node.comment.avatarUrl != null
                          ? NetworkImage(node.comment.avatarUrl!)
                          : AssetImage('assets/default_avatar.png') as ImageProvider,
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          node.comment.name ?? 'Anonymous',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        Text(
                          node.comment.content,
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        TextButton(
                          onPressed: () => _openReplyDialog(node.comment.id),
                          child: Text(
                            'Trả lời',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    )
                  ],

                ),
              ),
              // ListTile(
              //   leading: CircleAvatar(
              //     backgroundImage: node.comment.avatarUrl != null
              //         ? NetworkImage(node.comment.avatarUrl!)
              //         : AssetImage('assets/default_avatar.png') as ImageProvider,
              //   ),
              //   title: Text(
              //     node.comment.name ?? 'Anonymous',
              //     style: TextStyle(
              //         color: Colors.white, fontWeight: FontWeight.bold),
              //   ),
              //   subtitle: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text(
              //         node.comment.content,
              //         style: TextStyle(color: Colors.white),
              //       ),
              //
              //     ],
              //   ),
              // ),

              // Hiển thị các bình luận trả lời (đệ quy)
              if (node.replies.isNotEmpty)
                buildCommentList(node.replies, indent: indent + 20.0),
            ],
          ),
        );
      }).toList(),
    );
  }


}
