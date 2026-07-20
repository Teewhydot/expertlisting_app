import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isRent)
            Image.asset(
              'assets/images/key.png',
              width: 12,
              height: 12,
              color: textColor, // This acts as a tint/colorFilter for the PNG
            )
          else
            SvgPicture.asset(
              'assets/icons/for_sale.svg',
              width: 12,
              height: 12,
              colorFilter: ColorFilter.mode(textColor, BlendMode.srcIn),
            ),
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
