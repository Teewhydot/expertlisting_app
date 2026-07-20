enum MediaType { none, image, video, carousel }

enum TagType { none, forRent, forSale }

class PostModel {
  final String id;
  final String userProfileUrl;
  final String userName;
  final String userRole;
  final String category;
  final DateTime createdAt; // Store raw DateTime for accurate caching/parsing
  final String timeAgo;
  final String content;
  final String location;
  final TagType tagType;
  final MediaType mediaType;
  final List<String>? mediaUrls;
  final String? videoDuration;
  final int likes;
  final int comments;
  final int bookmarks;
  final List<String> likedByProfileUrls;
  final String likedByText;
  final bool isLiked;

  PostModel({
    required this.id,
    required this.userProfileUrl,
    required this.userName,
    required this.userRole,
    required this.category,
    required this.createdAt,
    required this.timeAgo,
    required this.content,
    required this.location,
    this.tagType = TagType.none,
    this.mediaType = MediaType.none,
    this.mediaUrls,
    this.videoDuration,
    required this.likes,
    required this.comments,
    required this.bookmarks,
    required this.likedByProfileUrls,
    required this.likedByText,
    this.isLiked = false,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    String type = json['type'] ?? 'general';
    TagType tType = TagType.none;
    String category = 'Discussion';

    if (type == 'property') {
      category = 'Property';
      if (json['price'] != null) {
        tType = TagType.forSale;
      } else {
        tType = TagType.forRent;
      }
    } else if (type == 'request') {
      category = 'Request';
    }

    MediaType mType = MediaType.none;
    List<String>? urls;
    if (json['image_url'] != null) {
      mType = MediaType.image;
      urls = [json['image_url'] as String];
    }

    DateTime dt = DateTime.parse(json['created_at']);
    Duration diff = DateTime.now().difference(dt);
    String tAgo = '${diff.inHours}h ago';
    if (diff.inMinutes < 60) {
      tAgo = '${diff.inMinutes}m ago';
    }
    if (diff.inDays > 0) {
      tAgo = '${diff.inDays}d ago';
    }

    return PostModel(
      id: json['id'],
      userProfileUrl: json['user_avatar'] ?? 'https://i.pravatar.cc/150',
      userName: json['user_name'] ?? 'Unknown User',
      userRole: 'Verified Expert',
      category: category,
      createdAt: dt,
      timeAgo: tAgo,
      content: json['content'] ?? '',
      location: json['location'] ?? 'Unknown Location',
      tagType: tType,
      mediaType: mType,
      mediaUrls: urls,
      likes: json['like_count'] ?? 0,
      comments: json['comment_count'] ?? 0,
      bookmarks: 0,
      likedByProfileUrls: [],
      likedByText: '',
      isLiked: json['is_liked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    String typeStr = 'general';
    if (category == 'Property') typeStr = 'property';
    if (category == 'Request') typeStr = 'request';

    return {
      'id': id,
      'type': typeStr,
      'price': tagType == TagType.forSale ? 1 : null, // dummy to retain tagType
      'image_url': mediaUrls != null && mediaUrls!.isNotEmpty
          ? mediaUrls!.first
          : null,
      'created_at': createdAt.toIso8601String(),
      'user_avatar': userProfileUrl,
      'user_name': userName,
      'content': content,
      'location': location,
      'like_count': likes,
      'comment_count': comments,
      'is_liked': isLiked,
    };
  }

  PostModel copyWith({int? likes, int? comments, bool? isLiked}) {
    return PostModel(
      id: id,
      userProfileUrl: userProfileUrl,
      userName: userName,
      userRole: userRole,
      category: category,
      createdAt: createdAt,
      timeAgo: timeAgo,
      content: content,
      location: location,
      tagType: tagType,
      mediaType: mediaType,
      mediaUrls: mediaUrls,
      videoDuration: videoDuration,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      bookmarks: bookmarks,
      likedByProfileUrls: likedByProfileUrls,
      likedByText: likedByText,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}
