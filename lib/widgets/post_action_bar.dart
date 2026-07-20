import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../core/constants/app_colors.dart';
import '../models/post_model.dart';

class PostActionBar extends StatelessWidget {
  final PostModel post;

  const PostActionBar({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildActionIcon(Icons.favorite_border, post.likes.toString()),
            const SizedBox(width: 16),
            _buildActionIcon(Icons.chat_bubble_outline, post.comments.toString()),
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

  Widget _buildActionIcon(IconData icon, String count) {
    return Row(
      children: [
        Icon(icon, color: AppColors.textLight, size: 20),
        const SizedBox(width: 4),
        Text(
          count,
          style: const TextStyle(
            color: AppColors.textLight,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
