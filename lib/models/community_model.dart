class CommunityModel {
  final int id;
  final String title;
  final String thumbnail;
  final int totalMembers;
  final int totalFeeds; // total posts

  CommunityModel({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.totalMembers,
    required this.totalFeeds,
  });

  factory CommunityModel.fromJSON(Map<String, dynamic> json) {
    return CommunityModel(
      id: json['id'],
      title: json['title'],
      thumbnail: json['thumbnail'],
      totalMembers: json['total_members'],
      totalFeeds: json['total_feeds'],
    );
  }
}
