import '../models/post_model.dart';
import '../models/story_model.dart';

class DummyData {
  static final List<StoryModel> stories = [
    StoryModel(
      id: '1',
      userName: 'Alex',
      profileUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=150&h=150',
    ),
    StoryModel(
      id: '2',
      userName: 'Jordan',
      profileUrl: 'https://images.unsplash.com/photo-1527980965255-d3b416303d12?auto=format&fit=crop&q=80&w=150&h=150',
    ),
    StoryModel(
      id: '3',
      userName: 'Taylor',
      profileUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&q=80&w=150&h=150',
    ),
    StoryModel(
      id: '4',
      userName: 'Jamie',
      profileUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&q=80&w=150&h=150',
    ),
    StoryModel(
      id: '5',
      userName: 'Jordan',
      profileUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&q=80&w=150&h=150',
    ),
    StoryModel(
      id: '6',
      userName: 'Em...',
      profileUrl: 'https://images.unsplash.com/photo-1580489944761-15a19d654956?auto=format&fit=crop&q=80&w=150&h=150',
    ),
  ];

  static final List<PostModel> posts = [
    PostModel(
      id: 'p1',
      userProfileUrl: 'https://images.unsplash.com/photo-1531427186611-ecfd6d936c79?auto=format&fit=crop&q=80&w=150&h=150',
      userName: 'Maurice U',
      userRole: 'Individual',
      category: 'General',
      timeAgo: 'Just Now',
      content: 'How is everyone holding up with the flooding in Lekki this week? Stay safe out there — and let me know if anyone needs a temporary place to crash 🙏',
      location: 'Lekki Phase 1, Lagos',
      tagType: TagType.none,
      mediaType: MediaType.none,
      likes: 8,
      comments: 8,
      bookmarks: 2,
      likedByProfileUrls: [
        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=50&h=50',
        'https://images.unsplash.com/photo-1527980965255-d3b416303d12?w=50&h=50',
        'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=50&h=50',
      ],
      likedByText: 'Liked by miracle.h and 7 others',
    ),
    PostModel(
      id: 'p2',
      userProfileUrl: 'https://images.unsplash.com/photo-1506277886164-e25aa3f4ef7f?auto=format&fit=crop&q=80&w=150&h=150',
      userName: 'Boyd From',
      userRole: 'Developer',
      category: 'Property',
      timeAgo: '2h',
      content: 'Newly serviced 3-bedroom apartment with fitted kitchen, parking for 3 cars, and 24/7 power. Inspection opens this Saturday.',
      location: 'Lekki Phase 1, Lagos',
      tagType: TagType.forRent,
      mediaType: MediaType.image,
      mediaUrls: [
        'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?auto=format&fit=crop&q=80&w=800'
      ],
      likes: 23,
      comments: 0,
      bookmarks: 2,
      likedByProfileUrls: [
        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=50&h=50',
        'https://images.unsplash.com/photo-1527980965255-d3b416303d12?w=50&h=50',
        'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=50&h=50',
      ],
      likedByText: 'Liked by miracle.h and 22 others',
    ),
    PostModel(
      id: 'p3',
      userProfileUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&q=80&w=150&h=150',
      userName: 'Stranger Dan',
      userRole: 'Agent',
      category: 'General',
      timeAgo: '20m',
      content: 'Newly serviced 3-bedroom apartment with fitted kitchen, parking for 3 cars, and 24/7 power. Inspection opens this Saturday.',
      location: 'Lekki Phase 1, Lagos',
      tagType: TagType.forSale,
      mediaType: MediaType.carousel,
      mediaUrls: [
        'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?auto=format&fit=crop&q=80&w=800',
        'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?auto=format&fit=crop&q=80&w=800',
        'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&q=80&w=800',
        'https://images.unsplash.com/photo-1600566753086-00f18efc2291?auto=format&fit=crop&q=80&w=800',
      ],
      likes: 23,
      comments: 3,
      bookmarks: 2,
      likedByProfileUrls: [
        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=50&h=50',
        'https://images.unsplash.com/photo-1527980965255-d3b416303d12?w=50&h=50',
        'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=50&h=50',
      ],
      likedByText: 'Liked by miracle.h and 22 others',
    ),
    PostModel(
      id: 'p4',
      userProfileUrl: 'https://images.unsplash.com/photo-1599566150163-29194dcaad36?auto=format&fit=crop&q=80&w=150&h=150',
      userName: 'Felix Okon',
      userRole: 'Broker',
      category: 'Property',
      timeAgo: '21h',
      content: 'New 2-bedroom apartment in Yaba or Akoka. Must have constant water and parking for one car. Moving in by end of next month.\n\nServiced 3-bedroom apartment with fitted kitchen, parking for 3 cars, and 24/7 power. Inspection opens this Saturday.',
      location: 'Lekki Phase 1, Lagos',
      tagType: TagType.forSale,
      mediaType: MediaType.video,
      mediaUrls: [
        'https://images.unsplash.com/photo-1616486029423-aaa4789e8c9a?auto=format&fit=crop&q=80&w=800'
      ],
      videoDuration: '0:20',
      likes: 1,
      comments: 0,
      bookmarks: 0,
      likedByProfileUrls: [
        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=50&h=50',
      ],
      likedByText: 'Liked by miracle.h',
    ),
  ];
}
