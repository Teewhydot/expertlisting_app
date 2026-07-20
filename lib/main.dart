import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'screens/main_screen.dart';

import 'package:provider/provider.dart';
import 'providers/feed_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => FeedProvider())],
      child: const ExpertListingApp(),
    ),
  );
}

class ExpertListingApp extends StatelessWidget {
  const ExpertListingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expert Listing',
      theme: AppTheme.darkTheme,
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
