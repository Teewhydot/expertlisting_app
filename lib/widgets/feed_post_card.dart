import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../core/constants/app_colors.dart';
import '../models/post_model.dart';
import 'post_action_bar.dart';
import 'tag_widget.dart';

class FeedPostCard extends StatefulWidget {
  final PostModel post;

  const FeedPostCard({super.key, required this.post});

  @override
  State<FeedPostCard> createState() => _FeedPostCardState();
}

class _FeedPostCardState extends State<FeedPostCard> {
  int _currentCarouselIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.cardBackground,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 10),
          _buildContent(),
          const SizedBox(height: 12),
          _buildLocationAndTag(),
          if (widget.post.mediaType != MediaType.none) const SizedBox(height: 12),
          _buildMedia(),
          const SizedBox(height: 16),
          PostActionBar(post: widget.post),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundImage: CachedNetworkImageProvider(widget.post.userProfileUrl),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    widget.post.userName,
                    style: const TextStyle(
                      color: AppColors.textLight,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text('•', style: TextStyle(color: AppColors.textGrey, fontSize: 14)),
                  const SizedBox(width: 4),
                  Text(
                    widget.post.userRole,
                    style: const TextStyle(
                      color: AppColors.textGrey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    widget.post.category,
                    style: const TextStyle(
                      color: AppColors.textGrey,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text('•', style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
                  const SizedBox(width: 4),
                  Text(
                    widget.post.timeAgo,
                    style: const TextStyle(
                      color: AppColors.textGrey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.more_horiz, color: AppColors.textGrey),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Text(
      widget.post.content,
      style: const TextStyle(
        color: AppColors.textLight,
        fontSize: 14,
        height: 1.4,
      ),
    );
  }

  Widget _buildLocationAndTag() {
    return Row(
      children: [
        SvgPicture.asset(
          'assets/icons/location.svg',
          width: 16,
          height: 16,
          colorFilter: const ColorFilter.mode(AppColors.textGrey, BlendMode.srcIn),
        ),
        const SizedBox(width: 4),
        Text(
          widget.post.location,
          style: const TextStyle(
            color: AppColors.textGrey,
            fontSize: 12,
          ),
        ),
        if (widget.post.tagType != TagType.none) ...[
          const SizedBox(width: 12),
          TagWidget(tagType: widget.post.tagType),
        ]
      ],
    );
  }

  Widget _buildMedia() {
    if (widget.post.mediaType == MediaType.none || widget.post.mediaUrls == null || widget.post.mediaUrls!.isEmpty) {
      return const SizedBox.shrink();
    }

    if (widget.post.mediaType == MediaType.carousel) {
      return Column(
        children: [
          Stack(
            alignment: Alignment.centerRight,
            children: [
              CarouselSlider(
                options: CarouselOptions(
                  height: 200,
                  viewportFraction: 1.0,
                  enableInfiniteScroll: false,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentCarouselIndex = index;
                    });
                  },
                ),
                items: widget.post.mediaUrls!.map((url) {
                  return Builder(
                    builder: (BuildContext context) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: url,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              // Pagination arrows on the right
              if (widget.post.mediaUrls!.length > 1)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.black.withValues(alpha: 0.5),
                    radius: 12,
                    child: const Icon(Icons.chevron_right, color: Colors.white, size: 16),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.post.mediaUrls!.asMap().entries.map((entry) {
              return Container(
                width: 6.0,
                height: 6.0,
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentCarouselIndex == entry.key
                        ? AppColors.primaryGreen
                        : AppColors.textGrey.withValues(alpha: 0.4)),
              );
            }).toList(),
          ),
        ],
      );
    }

    // For single image or video
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(
            imageUrl: widget.post.mediaUrls!.first,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        if (widget.post.mediaType == MediaType.video)
          Positioned(
            bottom: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.play_arrow, color: Colors.white, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    widget.post.videoDuration ?? '',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          )
      ],
    );
  }
}
