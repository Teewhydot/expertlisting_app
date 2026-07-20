import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../models/post_model.dart';

class TagWidget extends StatelessWidget {
  final TagType tagType;

  const TagWidget({super.key, required this.tagType});

  @override
  Widget build(BuildContext context) {
    if (tagType == TagType.none) return const SizedBox.shrink();

    final bool isRent = tagType == TagType.forRent;
    final Color bgColor = isRent ? AppColors.tagForRentBg : AppColors.tagForSaleBg;
    final Color textColor = isRent ? AppColors.tagForRentText : AppColors.tagForSaleText;
    final String text = isRent ? 'For Rent' : 'For Sale';
    final IconData icon = isRent ? Icons.key : Icons.local_offer_outlined;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: textColor),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
