import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post_model.dart';
import '../models/comment_model.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8080/api/v1';

  // Fetch posts with cursor pagination
  static Future<Map<String, dynamic>> getPosts({
    String type = 'property',
    String? cursor,
    int limit = 10,
  }) async {
    String url = '$baseUrl/posts?type=$type&limit=$limit';
    if (cursor != null) {
      url += '&cursor=${Uri.encodeComponent(cursor)}';
    }

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<PostModel> posts = (data['posts'] as List)
          .map((json) => PostModel.fromJson(json))
          .toList();
      return {'posts': posts, 'next_cursor': data['next_cursor']};
    } else {
      throw Exception('Failed to load posts');
    }
  }

  // Toggle Like
  static Future<Map<String, dynamic>> toggleLike(String postId) async {
    final response = await http.post(Uri.parse('$baseUrl/posts/$postId/like'));
    if (response.statusCode == 200) {
      return json.decode(response.body); // {is_liked, like_count}
    } else {
      throw Exception('Failed to toggle like');
    }
  }

  // Get Comments
  static Future<List<CommentModel>> getComments(String postId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/posts/$postId/comments'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['comments'] as List)
          .map((json) => CommentModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load comments');
    }
  }

  // Add Comment
  static Future<CommentModel> addComment(String postId, String content) async {
    final response = await http.post(
      Uri.parse('$baseUrl/posts/$postId/comments'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'content': content}),
    );
    if (response.statusCode == 201) {
      return CommentModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add comment');
    }
  }

  // Get Sidebar Data
  static Future<Map<String, dynamic>> getSidebarData() async {
    final response = await http.get(Uri.parse('$baseUrl/sidebar'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load sidebar data');
    }
  }
}
