class Comment {
  final String id;
  final String postId;
  final String userId;
  final String content;
  final String? parentId;
  final DateTime createdAt;
  final DateTime updatedAt;
  String? avatarUrl;
  String? name;

  Comment({
    required this.id,
    required this.postId,
    required this.userId,
    required this.content,
    this.parentId,
    required this.createdAt,
    required this.updatedAt,
    this.avatarUrl,
    this.name
  });

  // Tạo một factory constructor để chuyển đổi từ JSON thành object
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['_id'],
      postId: json['PostId'],
      userId: json['UserId'],
      content: json['Content'],
      parentId: json['ParentId'],
      createdAt: DateTime.parse(json['CreatedAt']),
      updatedAt: DateTime.parse(json['UpdatedAt']),
      avatarUrl: json['User']?['AvatarUrl'],
      name: json['User']?['Name'],
    );
  }

  // Chuyển object thành JSON nếu cần (ví dụ để gửi dữ liệu lên server)
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'PostId': postId,
      'UserId': userId,
      'Content': content,
      'ParentId': parentId,
      'CreatedAt': createdAt.toIso8601String(),
      'UpdatedAt': updatedAt.toIso8601String(),
      'User': {
        'AvatarUrl': avatarUrl,
        'Name': name,
      },
    };
  }
}

class CommentResponse {
  final List<Comment> comments;

  CommentResponse({required this.comments});

  factory CommentResponse.fromJson(Map<String, dynamic> json) {
    return CommentResponse(
      comments: (json['comments'] as List)
          .map((comment) => Comment.fromJson(comment))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'comments': comments.map((comment) => comment.toJson()).toList(),
    };
  }
}
