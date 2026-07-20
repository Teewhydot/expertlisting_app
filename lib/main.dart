import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'screens/main_screen.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'providers/feed_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://bdhbrcixuqcpcjxlyxnp.supabase.co',
    publishableKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJkaGJyY2l4dXFjcGNqeGx5eG5wIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODQ1NDQ4MDksImV4cCI6MjEwMDEyMDgwOX0.IQbLYt4GS4z0mqsw1oQOPKo8jax3oREC1m_nSmmngrY',
  );

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
