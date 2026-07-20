import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../core/constants/app_colors.dart';
import 'feed_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const FeedScreen(),
    const Center(child: Text('Search')),
    const Center(child: Text('List')),
    const Center(child: Text('Notification')),
    const Center(child: Text('Profile')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: BottomNavIcon(asset: 'assets/icons/feed.svg'),
              activeIcon: BottomNavIcon(
                asset: 'assets/icons/feed.svg',
                isActive: true,
              ),
              label: 'Feed',
            ),
            BottomNavigationBarItem(
              icon: BottomNavIcon(asset: 'assets/icons/search.svg'),
              activeIcon: BottomNavIcon(
                asset: 'assets/icons/search.svg',
                isActive: true,
              ),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: BottomNavIcon(asset: 'assets/icons/list.svg'),
              activeIcon: BottomNavIcon(
                asset: 'assets/icons/list.svg',
                isActive: true,
              ),
              label: 'List',
            ),
            BottomNavigationBarItem(
              icon: BottomNavIcon(asset: 'assets/icons/notification.svg'),
              activeIcon: BottomNavIcon(
                asset: 'assets/icons/notification.svg',
                isActive: true,
              ),
              label: 'Notification',
            ),
            BottomNavigationBarItem(
              icon: BottomNavIcon(asset: 'assets/icons/profile.svg'),
              activeIcon: BottomNavIcon(
                asset: 'assets/icons/profile.svg',
                isActive: true,
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primaryGreen,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class BottomNavIcon extends StatelessWidget {
  final String asset;
  final bool isActive;

  const BottomNavIcon({super.key, required this.asset, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      asset,
      width: 24,
      height: 24,
      colorFilter: isActive
          ? const ColorFilter.mode(AppColors.primaryGreen, BlendMode.srcIn)
          : const ColorFilter.mode(AppColors.textGrey, BlendMode.srcIn),
    );
  }
}
