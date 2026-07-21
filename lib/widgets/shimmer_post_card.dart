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
          Shimmer.fromColors(
            baseColor: Colors.grey[850]!,
            highlightColor: Colors.grey[800]!,
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              ShimmerBoxWidget(width: 100, height: 14),
                              SizedBox(width: 4),
                              Text(
                                '•',
                                style: TextStyle(
                                  color: AppColors.textGrey,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(width: 4),
                              ShimmerBoxWidget(width: 80, height: 14),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: const [
                              ShimmerBoxWidget(width: 60, height: 12),
                              SizedBox(width: 4),
                              Text(
                                '•',
                                style: TextStyle(
                                  color: AppColors.textGrey,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(width: 4),
                              ShimmerBoxWidget(width: 50, height: 12),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    const ShimmerBoxWidget(width: 24, height: 24),
                  ],
                ),
                const SizedBox(height: 10),
                const ShimmerBoxWidget(width: double.infinity, height: 14),
                const SizedBox(height: 6),
                const ShimmerBoxWidget(width: double.infinity, height: 14),
                const SizedBox(height: 6),
                const ShimmerBoxWidget(width: 180, height: 14),
                const SizedBox(height: 12),
                Row(
                  children: const [
                    ShimmerBoxWidget(width: 16, height: 16),
                    SizedBox(width: 4),
                    ShimmerBoxWidget(width: 80, height: 12),
                    SizedBox(width: 8),
                    ShimmerBoxWidget(width: 60, height: 20),
                  ],
                ),
                const SizedBox(height: 12),
                const ShimmerBoxWidget(
                  width: double.infinity,
                  height: 200,
                  borderRadius: 12,
                ),
                const SizedBox(height: 16),
                Row(
                  children: const [
                    _ActionIconPlaceholder(),
                    SizedBox(width: 16),
                    _ActionIconPlaceholder(),
                    SizedBox(width: 16),
                    ShimmerBoxWidget(width: 20, height: 20),
                    Spacer(),
                    _ActionIconPlaceholder(),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    SizedBox(
                      width: 50,
                      height: 20,
                      child: Stack(
                        children: const [
                          Positioned(
                            left: 0,
                            child: ShimmerCircleWidget(size: 16),
                          ),
                          Positioned(
                            left: 12,
                            child: ShimmerCircleWidget(size: 16),
                          ),
                          Positioned(
                            left: 24,
                            child: ShimmerCircleWidget(size: 16),
                          ),
                        ],
                      ),
                    ),
                    const Expanded(
                      child: ShimmerBoxWidget(width: 150, height: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionIconPlaceholder extends StatelessWidget {
  const _ActionIconPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        ShimmerBoxWidget(width: 20, height: 20),
        SizedBox(width: 4),
        ShimmerBoxWidget(width: 24, height: 14),
      ],
    );
  }
}

class ShimmerBoxWidget extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerBoxWidget({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[850]!,
      highlightColor: Colors.grey[800]!,
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
}

class ShimmerCircleWidget extends StatelessWidget {
  final double size;

  const ShimmerCircleWidget({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[850]!,
      highlightColor: Colors.grey[800]!,
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
