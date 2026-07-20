import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/story_list.dart';
import '../widgets/feed_post_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: ListView(
        children: [
          StoryList(stories: DummyData.stories),
          const Divider(),
          ...DummyData.posts.expand((post) => [
            FeedPostCard(post: post),
            const Divider(),
          ]),
        ],
      ),
    );
  }
}
