class StoryModel {
  final String id;
  final String userName;
  final String profileUrl;
  final bool hasUnviewedStory;

  StoryModel({
    required this.id,
    required this.userName,
    required this.profileUrl,
    this.hasUnviewedStory = true,
  });
}
