enum MediaType { none, image, video, carousel }
enum TagType { none, forRent, forSale }

class PostModel {
  final String id;
  final String userProfileUrl;
  final String userName;
  final String userRole;
  final String category;
  final String timeAgo;
  final String content;
  final String location;
  final TagType tagType;
  final MediaType mediaType;
  final List<String>? mediaUrls; // Used for single image, video thumbnail, or carousel
  final String? videoDuration; // e.g. "0:20"
  final int likes;
  final int comments;
  final int bookmarks;
  final List<String> likedByProfileUrls;
  final String likedByText;

  PostModel({
    required this.id,
    required this.userProfileUrl,
    required this.userName,
    required this.userRole,
    required this.category,
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
  });
}
