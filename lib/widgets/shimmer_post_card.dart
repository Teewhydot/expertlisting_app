import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../core/constants/app_colors.dart';

class ShimmerPostCard extends StatelessWidget {
  const ShimmerPostCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.cardBackground,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          Shimmer.fromColors(
            baseColor: AppColors.background,
            highlightColor: AppColors.cardBackground,
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header (Name & Role, Category & Time)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              _buildShimmerBox(width: 100, height: 14),
                              const SizedBox(width: 4),
                              const Text('•', style: TextStyle(color: AppColors.textGrey, fontSize: 14)),
                              const SizedBox(width: 4),
                              _buildShimmerBox(width: 80, height: 14),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              _buildShimmerBox(width: 60, height: 12),
                              const SizedBox(width: 4),
                              const Text('•', style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
                              const SizedBox(width: 4),
                              _buildShimmerBox(width: 50, height: 12),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildShimmerBox(width: 24, height: 24), // more_horiz
                  ],
                ),
                const SizedBox(height: 10),
                
                // Content lines
                _buildShimmerBox(width: double.infinity, height: 14),
                const SizedBox(height: 6),
                _buildShimmerBox(width: double.infinity, height: 14),
                const SizedBox(height: 6),
                _buildShimmerBox(width: 180, height: 14),
                
                const SizedBox(height: 12),
                
                // Location & Tag
                Row(
                  children: [
                    _buildShimmerBox(width: 16, height: 16), // Location icon
                    const SizedBox(width: 4),
                    _buildShimmerBox(width: 80, height: 12), // Location text
                    const SizedBox(width: 8),
                    _buildShimmerBox(width: 60, height: 20), // Tag bubble
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Media Placeholder
                _buildShimmerBox(width: double.infinity, height: 200, borderRadius: 12),
                
                const SizedBox(height: 16),
                
                // Action Bar Top Row (Likes, Comments, Share, Bookmark)
                Row(
                  children: [
                    _buildActionIconPlaceholder(),
                    const SizedBox(width: 16),
                    _buildActionIconPlaceholder(),
                    const SizedBox(width: 16),
                    _buildShimmerBox(width: 20, height: 20), // share
                    const Spacer(),
                    _buildActionIconPlaceholder(), // bookmark
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Action Bar Bottom Row (Liked By avatars)
                Row(
                  children: [
                    SizedBox(
                      width: 50,
                      height: 20,
                      child: Stack(
                        children: [
                          Positioned(left: 0, child: _buildShimmerCircle(16)),
                          Positioned(left: 12, child: _buildShimmerCircle(16)),
                          Positioned(left: 24, child: _buildShimmerCircle(16)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: _buildShimmerBox(width: 150, height: 12),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionIconPlaceholder() {
    return Row(
      children: [
        _buildShimmerBox(width: 20, height: 20),
        const SizedBox(width: 4),
        _buildShimmerBox(width: 24, height: 14),
      ],
    );
  }

  Widget _buildShimmerBox({required double width, required double height, double borderRadius = 4}) {
    return Shimmer.fromColors(
      baseColor: AppColors.background,
      highlightColor: AppColors.cardBackground,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }

  Widget _buildShimmerCircle(double size) {
    return Shimmer.fromColors(
      baseColor: AppColors.background,
      highlightColor: AppColors.cardBackground,
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
      ),
    );
  }
}
