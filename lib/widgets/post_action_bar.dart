import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../models/post_model.dart';
import '../providers/feed_provider.dart';
import 'comments_bottom_sheet.dart';

class PostActionBar extends StatelessWidget {
  final PostModel post;

  const PostActionBar({super.key, required this.post});

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
            _buildActionIcon(
              post.isLiked ? Icons.favorite : Icons.favorite_border,
              post.likes.toString(),
              color: post.isLiked ? Colors.red : AppColors.textLight,
              onTap: () {
                context.read<FeedProvider>().toggleLike(post.id);
              },
            ),
            const SizedBox(width: 16),
            _buildActionIcon(
              Icons.chat_bubble_outline,
              post.comments.toString(),
              onTap: () => _showComments(context),
            ),
            const SizedBox(width: 16),
            const Icon(Icons.send_outlined, color: AppColors.textLight, size: 20),
            const Spacer(),
            _buildActionIcon(Icons.bookmark_border, post.bookmarks.toString()),
          ],
        ),
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
                        border: Border.all(color: AppColors.cardBackground, width: 2),
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
    );
  }

  Widget _buildActionIcon(IconData icon, String count, {Color color = AppColors.textLight, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 4),
          Text(
            count,
            style: TextStyle(
              color: color,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
