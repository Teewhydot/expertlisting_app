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
              iconWidget: Icon(
                post.isLiked ? Icons.favorite : Icons.favorite_border,
                color: post.isLiked ? Colors.red : AppColors.textLight,
                key: ValueKey<String>('like_${post.isLiked}'),
                size: 20,
              ),
              count: post.likes.toString(),
              onTap: () {
                context.read<FeedProvider>().toggleLike(post.id);
              },
            ),
            const SizedBox(width: 16),
            ActionIconWidget(
              iconWidget: Image.asset(
                'assets/icons/comment.png',
                width: 20,
                height: 20,
                color: AppColors.textLight,
              ),
              count: post.comments.toString(),
              onTap: isDetailMode ? null : () => _showComments(context),
            ),
            const SizedBox(width: 16),
            Image.asset(
              'assets/icons/arrow_right.png',
              width: 20,
              height: 20,
              color: AppColors.textLight,
            ),
            const Spacer(),
            ActionIconWidget(
              iconWidget: Image.asset(
                'assets/icons/bookmarrk.png',
                width: 20,
                height: 20,
                color: AppColors.textLight,
              ),
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
  final Widget iconWidget;
  final String count;
  final VoidCallback? onTap;

  const ActionIconWidget({
    super.key,
    required this.iconWidget,
    required this.count,
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
            child: iconWidget,
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
              style: const TextStyle(color: AppColors.textLight, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
