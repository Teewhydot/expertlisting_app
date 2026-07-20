import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 16,
      title: Row(
        children: [
          // Logo Icon
          Image.asset(
            'assets/images/logo.png',
            height: 24,
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.maps_home_work_outlined,
              color: AppColors.primaryGreen,
              size: 24,
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'Expert Listing',
            style: TextStyle(
              color: AppColors.primaryGreen,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {},
          child: const Text(
            'Sign In',
            style: TextStyle(
              color: AppColors.textLight,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
