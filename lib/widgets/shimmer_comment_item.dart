import 'package:flutter/material.dart';
import 'shimmer_post_card.dart';

class ShimmerCommentItem extends StatelessWidget {
  const ShimmerCommentItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShimmerCircleWidget(size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    ShimmerBoxWidget(width: 80, height: 14),
                    SizedBox(width: 8),
                    ShimmerBoxWidget(width: 40, height: 12),
                  ],
                ),
                const SizedBox(height: 8),
                const ShimmerBoxWidget(width: double.infinity, height: 14),
                const SizedBox(height: 4),
                const ShimmerBoxWidget(width: 200, height: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
