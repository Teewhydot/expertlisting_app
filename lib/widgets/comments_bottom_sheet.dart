import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../models/post_model.dart';
import '../models/comment_model.dart';
import '../data/api_service.dart';
import '../providers/feed_provider.dart';
import 'shimmer_comment_item.dart';
import '../core/constants/app_colors.dart';

class CommentsBottomSheet extends StatefulWidget {
  final PostModel post;

  const CommentsBottomSheet({super.key, required this.post});

  @override
  State<CommentsBottomSheet> createState() => _CommentsBottomSheetState();
}

class _CommentsBottomSheetState extends State<CommentsBottomSheet> {
  List<CommentModel> _comments = [];
  bool _isLoading = true;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchComments();
  }

  Future<void> _fetchComments() async {
    try {
      final comments = await ApiService.getComments(widget.post.id);
      setState(() {
        _comments = comments;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _postComment() async {
    final content = _commentController.text.trim();
    if (content.isEmpty) return;

    _commentController.clear();
    FocusScope.of(context).unfocus();

    try {
      final newComment = await ApiService.addComment(widget.post.id, content);
      setState(() {
        _comments.add(newComment);
      });
      if (mounted) {
        context.read<FeedProvider>().incrementCommentCount(widget.post.id);
      }
    } catch (e) {
      debugPrint('Error posting comment: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.cardBackground,
      height: MediaQuery.of(context).size.height * 0.75,
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.textGrey.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Comments',
            style: TextStyle(
              color: AppColors.textLight,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(color: AppColors.dividerColor),
          Expanded(
            child: _isLoading
                ? ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) => const ShimmerCommentItem(),
                  )
                : _comments.isEmpty
                ? const Center(
                    child: Text(
                      'No comments yet. Be the first!',
                      style: TextStyle(color: AppColors.textGrey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _comments.length,
                    itemBuilder: (context, index) {
                      final comment = _comments[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundImage: CachedNetworkImageProvider(
                                comment.userAvatar,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        comment.userName,
                                        style: const TextStyle(
                                          color: AppColors.textLight,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        comment.timeAgo,
                                        style: const TextStyle(
                                          color: AppColors.textGrey,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    comment.content,
                                    style: const TextStyle(
                                      color: AppColors.textLight,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          const Divider(height: 1, color: AppColors.dividerColor),
          Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 8,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    style: const TextStyle(color: AppColors.textLight),
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                      hintStyle: const TextStyle(color: AppColors.textGrey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: AppColors.background,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _postComment,
                  icon: const Icon(Icons.send, color: AppColors.primaryGreen),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
