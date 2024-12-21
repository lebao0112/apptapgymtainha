import 'package:doan_tapgymtainha/service/api_social_media.dart';
import 'package:flutter/material.dart';

class LikeButton extends StatefulWidget {
  final String postId;
  final String? commentId;
  final int likeCount;
  final bool isLiked;
  const LikeButton({super.key, required this.postId, required this.likeCount, this.commentId, required this.isLiked});

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  late bool isLiked = widget.isLiked;
  late int likeCount = widget.likeCount;
  late String postId = widget.postId;
  late String? commentId = widget.commentId;

  @override
  void initState() {
    super.initState();
    // _checkIfUserLiked();
  }

  Future<void> _toggleLike() async{
    setState(() {
      isLiked = !isLiked;
      likeCount += isLiked ? 1 : -1;
    });

    final result = await ApiSocialMedia.toggleLike(postId, commentId);
    if(!result){
      setState(() {
        isLiked = !isLiked;
      });
    }

  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          onPressed: () async{
            _toggleLike();
          },
          icon: isLiked ? Icon(Icons.favorite, color: Colors.orange) : Icon(Icons.favorite_border, color: Theme.of(context).textTheme.bodyLarge?.color),
        ),
        Text(
          likeCount.toString(),
          style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: 14),
        ),
      ],
    );
  }


}
