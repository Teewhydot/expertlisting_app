import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../models/post_model.dart';
import '../providers/feed_provider.dart';
import 'comments_bottom_sheet.dart';

class PostActionBar extends StatelessWidget {
  final PostModel post;
  final bool isDetailMode;

  const PostActionBar({
    super.key,
    required this.post,
    this.isDetailMode = false,
  });

  void _showComments(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CommentsBottomSheet(post: post),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ActionIconWidget(
              icon: post.isLiked ? Icons.favorite : Icons.favorite_border,
              count: post.likes.toString(),
              color: post.isLiked ? Colors.red : AppColors.textLight,
              onTap: () {
                context.read<FeedProvider>().toggleLike(post.id);
              },
            ),
            const SizedBox(width: 16),
            ActionIconWidget(
              icon: Icons.chat_bubble_outline,
              count: post.comments.toString(),
              onTap: isDetailMode ? null : () => _showComments(context),
            ),
            const SizedBox(width: 16),
            const Icon(
              Icons.send_outlined,
              color: AppColors.textLight,
              size: 20,
            ),
            const Spacer(),
            ActionIconWidget(
              icon: Icons.bookmark_border,
              count: post.bookmarks.toString(),
            ),
          ],
        ),
        if (post.likedByProfileUrls.isNotEmpty) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              SizedBox(
                width: 50,
                height: 20,
                child: Stack(
                  children: List.generate(
                    post.likedByProfileUrls.length,
                    (index) => Positioned(
                      left: index * 12.0,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.cardBackground,
                            width: 2,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl: post.likedByProfileUrls[index],
                            width: 16,
                            height: 16,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  post.likedByText,
                  style: const TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class ActionIconWidget extends StatelessWidget {
  final IconData icon;
  final String count;
  final Color color;
  final VoidCallback? onTap;

  const ActionIconWidget({
    super.key,
    required this.icon,
    required this.count,
    this.color = AppColors.textLight,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: Icon(
              icon,
              key: ValueKey<String>('${icon.codePoint}_$color'),
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 4),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, -0.5),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: Text(
              count,
              key: ValueKey<String>(count),
              style: TextStyle(color: color, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
