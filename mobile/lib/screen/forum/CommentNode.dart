import '../../model/comment.dart';

class CommentNode {
  final Comment comment;
  final List<CommentNode> replies;

  CommentNode({required this.comment, required this.replies});
}