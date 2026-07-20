class CommentModel {
  final String id;
  final String content;
  final String timeAgo;
  final String userName;
  final String userAvatar;

  CommentModel({
    required this.id,
    required this.content,
    required this.timeAgo,
    required this.userName,
    required this.userAvatar,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    DateTime createdAt = DateTime.parse(json['created_at']);
    Duration diff = DateTime.now().difference(createdAt);
    String tAgo = '${diff.inHours}h';
    if (diff.inMinutes < 60) tAgo = '${diff.inMinutes}m';
    if (diff.inDays > 0) tAgo = '${diff.inDays}d';

    return CommentModel(
      id: json['id'],
      content: json['content'],
      timeAgo: tAgo,
      userName: json['user_name'],
      userAvatar: json['user_avatar'],
    );
  }
}
