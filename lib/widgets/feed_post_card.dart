import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../core/constants/app_colors.dart';
import '../models/post_model.dart';
import 'post_action_bar.dart';
import 'tag_widget.dart';
import '../screens/post_details_screen.dart';

class FeedPostCard extends StatelessWidget {
  final PostModel post;
  final bool isDetailMode;

  const FeedPostCard({
    super.key,
    required this.post,
    this.isDetailMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDetailMode
          ? null
          : () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostDetailsScreen(post: post),
                ),
              );
            },
      child: Container(
        color: AppColors.cardBackground,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: CachedNetworkImageProvider(post.userProfileUrl),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _PostHeader(post: post),
                  const SizedBox(height: 10),
                  _PostContentText(content: post.content),
                  const SizedBox(height: 12),
                  _PostLocationTag(post: post),
                  if (post.mediaType != MediaType.none)
                    const SizedBox(height: 12),
                  _PostMediaContent(post: post),
                  const SizedBox(height: 16),
                  PostActionBar(post: post, isDetailMode: isDetailMode),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PostHeader extends StatelessWidget {
  final PostModel post;

  const _PostHeader({required this.post});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      post.userName,
                      style: const TextStyle(
                        color: AppColors.textLight,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    '•',
                    style: TextStyle(
                      color: Color.fromRGBO(138, 138, 138, 0.8),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      post.userRole,
                      style: const TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      post.category,
                      style: const TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    '•',
                    style: TextStyle(
                      color: Color.fromRGBO(138, 138, 138, 0.8),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      post.timeAgo,
                      style: const TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 24,
          width: 24,
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.more_horiz, color: AppColors.textGrey),
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}

class _PostContentText extends StatelessWidget {
  final String content;

  const _PostContentText({required this.content});

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      style: const TextStyle(
        color: AppColors.textLight,
        fontSize: 14,
        height: 1.4,
      ),
    );
  }
}

class _PostLocationTag extends StatelessWidget {
  final PostModel post;

  const _PostLocationTag({required this.post});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          'assets/icons/location.svg',
          width: 16,
          height: 16,
          colorFilter: const ColorFilter.mode(
            AppColors.textGrey,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            post.location,
            style: const TextStyle(color: AppColors.textGrey, fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (post.tagType != TagType.none) ...[
          const SizedBox(width: 8),
          TagWidget(tagType: post.tagType),
        ],
      ],
    );
  }
}

class _PostMediaContent extends StatefulWidget {
  final PostModel post;

  const _PostMediaContent({required this.post});

  @override
  State<_PostMediaContent> createState() => _PostMediaContentState();
}

class _PostMediaContentState extends State<_PostMediaContent> {
  int _currentCarouselIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.post.mediaType == MediaType.none ||
        widget.post.mediaUrls == null ||
        widget.post.mediaUrls!.isEmpty) {
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
              if (widget.post.mediaUrls!.length > 1)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.black.withValues(alpha: 0.5),
                    radius: 12,
                    child: const Icon(
                      Icons.chevron_right,
                      color: Colors.white,
                      size: 16,
                    ),
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
                margin: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 4.0,
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentCarouselIndex == entry.key
                      ? AppColors.primaryGreen
                      : AppColors.textGrey.withValues(alpha: 0.4),
                ),
              );
            }).toList(),
          ),
        ],
      );
    }

    if (widget.post.mediaType == MediaType.video) {
      return Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.only(right: 52.0),
          child: SizedBox(
            height: 400,
            child: AspectRatio(
              aspectRatio: 9 / 16,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: widget.post.mediaUrls!.first,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Center(
                    child: CircleAvatar(
                      backgroundColor: Colors.black.withValues(alpha: 0.3),
                      radius: 24,
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.post.videoDuration ?? '',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: CachedNetworkImage(
        imageUrl: widget.post.mediaUrls!.first,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}
