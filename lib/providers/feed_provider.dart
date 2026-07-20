import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/post_model.dart';
import '../data/api_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FeedProvider extends ChangeNotifier {
  List<PostModel> _posts = [];
  final List<PostModel> _newPostsCache = [];
  String? _nextCursor;
  bool _isLoading = true;
  bool _isLoadingMore = false;
  String? errorMessage;
  RealtimeChannel? _realtimeChannel;
  String _currentType = 'property';

  List<PostModel> get posts => _posts;
  List<PostModel> get newPostsCache => _newPostsCache;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _nextCursor != null;

  static const String _cacheKeyPrefix = 'feed_cache_';

  FeedProvider() {
    _init();
  }

  Future<void> _init() async {
    await _loadCachedPosts();
    await fetchInitialPosts();
    _startRealtimeListener();
  }

  @override
  void dispose() {
    _realtimeChannel?.unsubscribe();
    super.dispose();
  }

  void setType(String type) {
    if (_currentType == type) return;
    _currentType = type;
    _init(); // reload cache and network for new type
  }

  Future<void> _loadCachedPosts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedStr = prefs.getString('$_cacheKeyPrefix$_currentType');
      if (cachedStr != null) {
        final List<dynamic> decoded = json.decode(cachedStr);
        _posts = decoded.map((json) => PostModel.fromJson(json)).toList();
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading cache: $e');
    }
  }

  Future<void> _savePostsToCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Cache the top 50 posts
      final cacheList = _posts.take(50).map((p) => p.toJson()).toList();
      await prefs.setString(
        '$_cacheKeyPrefix$_currentType',
        json.encode(cacheList),
      );
    } catch (e) {
      debugPrint('Error saving cache: $e');
    }
  }

  Future<void> fetchInitialPosts() async {
    // Only show loading indicator if we don't have cached posts
    if (_posts.isEmpty) {
      _isLoading = true;
      errorMessage = null;
      notifyListeners();
    }

    try {
      final data = await ApiService.getPosts(type: _currentType, limit: 10);
      _posts = data['posts'];
      _nextCursor = data['next_cursor'];
      _newPostsCache.clear();
      errorMessage = null;
      await _savePostsToCache();
    } catch (e) {
      debugPrint('Error fetching posts: $e');
      if (_posts.isEmpty) {
        errorMessage = 'Failed to load posts. Please check your connection.';
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMorePosts() async {
    if (_isLoadingMore || !hasMore) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final data = await ApiService.getPosts(
        type: _currentType,
        cursor: _nextCursor,
        limit: 10,
      );
      List<PostModel> morePosts = data['posts'];
      _posts.addAll(morePosts);
      _nextCursor = data['next_cursor'];

      // Update cache if we are still within the top 50
      if (_posts.length <= 50) {
        await _savePostsToCache();
      }
    } catch (e) {
      debugPrint('Error fetching more posts: $e');
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  void _startRealtimeListener() {
    _realtimeChannel?.unsubscribe();
    _realtimeChannel = Supabase.instance.client.channel('public:db_changes');

    _realtimeChannel!
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'posts',
          callback: _handleRealtimePing,
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'likes',
          callback: _handleRealtimePing,
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'comments',
          callback: _handleRealtimePing,
        )
        .subscribe();
  }

  Future<void> _handleRealtimePing(PostgresChangePayload payload) async {
    if (_posts.isEmpty) return;

    try {
      // Trigger a silent fetch of the latest 5 posts from our backend.
      // This retrieves the fully hydrated JSON (including joined names and counts)
      // without needing to rewrite complex joining logic on the frontend.
      final data = await ApiService.getPosts(type: _currentType, limit: 5);
      List<PostModel> latestPosts = data['posts'];

      bool hasChanges = false;
      for (var post in latestPosts) {
        int indexInMain = _posts.indexWhere((p) => p.id == post.id);
        if (indexInMain == -1) {
          bool existsInCache = _newPostsCache.any((p) => p.id == post.id);
          if (!existsInCache) {
            _newPostsCache.add(post);
            hasChanges = true;
          }
        } else {
          // Reconcile stats for existing posts in the feed
          PostModel existingPost = _posts[indexInMain];
          if (existingPost.likes != post.likes ||
              existingPost.comments != post.comments) {
            _posts[indexInMain] = existingPost.copyWith(
              likes: post.likes,
              comments: post.comments,
              // We leave local 'isLiked' alone so we don't accidentally overwrite optimistic likes
            );
            hasChanges = true;
          }
        }
      }

      if (hasChanges) {
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Realtime ping fetch error: $e');
    }
  }

  void commitNewPosts() {
    if (_newPostsCache.isEmpty) return;

    _posts.insertAll(0, _newPostsCache);
    _newPostsCache.clear();
    _savePostsToCache(); // Update cache with new posts at top
    notifyListeners();
  }

  void toggleLike(String postId) async {
    // Optimistic Update
    int index = _posts.indexWhere((p) => p.id == postId);
    if (index == -1) return;

    PostModel p = _posts[index];
    bool newIsLiked = !p.isLiked;
    int newLikes = newIsLiked ? p.likes + 1 : p.likes - 1;

    _posts[index] = p.copyWith(isLiked: newIsLiked, likes: newLikes);
    notifyListeners();

    try {
      final res = await ApiService.toggleLike(postId);
      // Sync with server source of truth
      _posts[index] = _posts[index].copyWith(
        isLiked: res['is_liked'],
        likes: res['like_count'],
      );
      // Update cache if changed
      if (index < 50) _savePostsToCache();
      notifyListeners();
    } catch (e) {
      // Revert on failure
      _posts[index] = p;
      notifyListeners();
    }
  }

  void incrementCommentCount(String postId) {
    int index = _posts.indexWhere((p) => p.id == postId);
    if (index == -1) return;

    PostModel p = _posts[index];
    _posts[index] = p.copyWith(comments: p.comments + 1);

    if (index < 50) _savePostsToCache();
    notifyListeners();
  }
}
