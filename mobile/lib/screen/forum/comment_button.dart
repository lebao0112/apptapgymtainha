import 'package:doan_tapgymtainha/screen/forum/comment_section.dart';
import 'package:doan_tapgymtainha/service/api_social_media.dart';
import 'package:flutter/material.dart';

class CommentButton extends StatefulWidget {
  final String postId;
  final int commentCount;

  const CommentButton({super.key, required this.postId, required this.commentCount});

  @override
  State<CommentButton> createState() => _CommentButtonState();
}

class _CommentButtonState extends State<CommentButton> {
  late String postId = widget.postId;
  late int commentCount = widget.commentCount;
  @override
  void initState() {
    super.initState();
    // _checkIfUserLiked();
  }



  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => CommentSection(postId: postId),
            );
          },
          icon:  Icon(Icons.comment_bank_outlined, color: Theme.of(context).textTheme.bodyLarge?.color),
        ),
        Text(
          commentCount.toString(),
          style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: 14),
        ),
      ],
    );
  }


}
