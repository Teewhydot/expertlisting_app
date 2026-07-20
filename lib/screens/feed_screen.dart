import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/feed_provider.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/feed_post_card.dart';
import '../widgets/shimmer_post_card.dart';
import '../widgets/story_list.dart';
import '../widgets/shimmer_story_list.dart';
import '../models/story_model.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final ScrollController _scrollController = ScrollController();

  final List<StoryModel> _mockStories = [
    StoryModel(
      id: '1',
      userName: 'Your Story',
      profileUrl: 'https://i.pravatar.cc/150?img=11',
      hasUnviewedStory: false,
    ),
    StoryModel(
      id: '2',
      userName: 'Sarah',
      profileUrl: 'https://i.pravatar.cc/150?img=5',
    ),
    StoryModel(
      id: '3',
      userName: 'Mike',
      profileUrl: 'https://i.pravatar.cc/150?img=8',
    ),
    StoryModel(
      id: '4',
      userName: 'Emma',
      profileUrl: 'https://i.pravatar.cc/150?img=9',
    ),
    StoryModel(
      id: '5',
      userName: 'John',
      profileUrl: 'https://i.pravatar.cc/150?img=12',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<FeedProvider>().fetchMorePosts();
    }
  }

  void _scrollToTopAndCommit() {
    final provider = context.read<FeedProvider>();
    provider.commitNewPosts();
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Consumer<FeedProvider>(
        builder: (context, provider, child) {
          if (provider.errorMessage != null && provider.posts.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.wifi_off, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      provider.errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: provider.fetchInitialPosts,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          return Stack(
            children: [
              RefreshIndicator(
                onRefresh: provider.fetchInitialPosts,
                child: ListView.separated(
                  controller: _scrollController,
                  itemCount: (provider.isLoading && provider.posts.isEmpty)
                      ? 4
                      : provider.posts.length + 2,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    if (provider.isLoading && provider.posts.isEmpty) {
                      if (index == 0) return const ShimmerStoryList();
                      return const ShimmerPostCard();
                    }

                    if (index == 0) return StoryList(stories: _mockStories);

                    if (index == provider.posts.length + 1) {
                      return provider.isLoadingMore
                          ? const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(child: CircularProgressIndicator()),
                            )
                          : const SizedBox.shrink();
                    }

                    final post = provider.posts[index - 1];
                    return FeedPostCard(post: post);
                  },
                ),
              ),

              if (provider.newPostsCache.isNotEmpty)
                Positioned(
                  top: 110,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 300),
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset(0, -50 * (1 - value)),
                          child: Opacity(opacity: value, child: child),
                        );
                      },
                      child: ElevatedButton.icon(
                        onPressed: _scrollToTopAndCommit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 4,
                        ),
                        icon: const Icon(Icons.arrow_upward, size: 16),
                        label: Text(
                          '${provider.newPostsCache.length} New Post${provider.newPostsCache.length > 1 ? 's' : ''}',
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
