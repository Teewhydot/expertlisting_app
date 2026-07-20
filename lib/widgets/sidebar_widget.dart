import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sidebar_provider.dart';
import '../providers/feed_provider.dart';
import '../core/constants/app_colors.dart';

class SidebarWidget extends StatelessWidget {
  const SidebarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.background,
      child: SafeArea(
        child: Consumer<SidebarProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (provider.errorMessage != null) {
              return Center(
                child: Text(
                  provider.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const SidebarHeader(),
                const SizedBox(height: 24),
                const SidebarFilters(),
                const SizedBox(height: 24),
                TrendingLocationsSection(locations: provider.trendingLocations),
                const SizedBox(height: 24),
                HotRequestsSection(requests: provider.hotRequests),
                const SizedBox(height: 24),
                TopCommunitiesSection(communities: provider.topCommunities),
              ],
            );
          },
        ),
      ),
    );
  }
}

class SidebarHeader extends StatelessWidget {
  const SidebarHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Discover',
          style: TextStyle(
            color: AppColors.primaryGreen,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close, color: AppColors.textLight),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}

class SidebarFilters extends StatelessWidget {
  const SidebarFilters({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FeedProvider>(
      builder: (context, feedProvider, child) {
        // Just demonstrating a simple filter UI that ties into FeedProvider type
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Feed Filters',
              style: TextStyle(
                color: AppColors.textLight,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilterChip(
                  label: const Text('All'),
                  selected: feedProvider.currentType == 'all',
                  onSelected: (val) {
                    Navigator.pop(context);
                    feedProvider.setType('all');
                  },
                  backgroundColor: AppColors.cardBackground,
                  selectedColor: AppColors.primaryGreen.withValues(alpha: 0.2),
                  checkmarkColor: AppColors.primaryGreen,
                  labelStyle: const TextStyle(color: AppColors.textLight),
                ),
                FilterChip(
                  label: const Text('Property'),
                  selected: feedProvider.currentType == 'property',
                  onSelected: (val) {
                    Navigator.pop(context);
                    feedProvider.setType('property');
                  },
                  backgroundColor: AppColors.cardBackground,
                  selectedColor: AppColors.primaryGreen.withValues(alpha: 0.2),
                  checkmarkColor: AppColors.primaryGreen,
                  labelStyle: const TextStyle(color: AppColors.textLight),
                ),
                FilterChip(
                  label: const Text('General'),
                  selected: feedProvider.currentType == 'general',
                  onSelected: (val) {
                    Navigator.pop(context);
                    feedProvider.setType('general');
                  },
                  backgroundColor: AppColors.cardBackground,
                  selectedColor: AppColors.primaryGreen.withValues(alpha: 0.2),
                  checkmarkColor: AppColors.primaryGreen,
                  labelStyle: const TextStyle(color: AppColors.textLight),
                ),
                FilterChip(
                  label: const Text('Request'),
                  selected: feedProvider.currentType == 'request',
                  onSelected: (val) {
                    Navigator.pop(context);
                    feedProvider.setType('request');
                  },
                  backgroundColor: AppColors.cardBackground,
                  selectedColor: AppColors.primaryGreen.withValues(alpha: 0.2),
                  checkmarkColor: AppColors.primaryGreen,
                  labelStyle: const TextStyle(color: AppColors.textLight),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class TrendingLocationsSection extends StatelessWidget {
  final List<dynamic> locations;
  const TrendingLocationsSection({super.key, required this.locations});

  @override
  Widget build(BuildContext context) {
    if (locations.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Trending Locations',
          style: TextStyle(
            color: AppColors.textLight,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: locations.map((loc) {
            return Chip(
              label: Text('${loc['location']} (${loc['post_count']})'),
              backgroundColor: AppColors.cardBackground,
              labelStyle: const TextStyle(
                color: AppColors.textLight,
                fontSize: 12,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class HotRequestsSection extends StatelessWidget {
  final List<dynamic> requests;
  const HotRequestsSection({super.key, required this.requests});

  @override
  Widget build(BuildContext context) {
    if (requests.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hot Requests',
          style: TextStyle(
            color: AppColors.textLight,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Column(
          children: requests.map((req) {
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundImage: NetworkImage(req['user_avatar'] ?? ''),
                radius: 16,
              ),
              title: Text(
                req['content'] ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textLight,
                  fontSize: 14,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.favorite,
                    size: 14,
                    color: AppColors.primaryGreen,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${req['like_count'] ?? 0}',
                    style: const TextStyle(
                      color: AppColors.textGrey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class TopCommunitiesSection extends StatelessWidget {
  final List<dynamic> communities;
  const TopCommunitiesSection({super.key, required this.communities});

  @override
  Widget build(BuildContext context) {
    if (communities.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Top Communities',
          style: TextStyle(
            color: AppColors.textLight,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Column(
          children: communities.map((com) {
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.people,
                  color: AppColors.primaryGreen,
                  size: 16,
                ),
              ),
              title: Text(
                com['name'] ?? '',
                style: const TextStyle(
                  color: AppColors.textLight,
                  fontSize: 14,
                ),
              ),
              subtitle: Text(
                '${com['members']} members',
                style: const TextStyle(color: AppColors.textGrey, fontSize: 12),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
