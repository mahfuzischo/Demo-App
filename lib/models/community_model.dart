class CommunityModel {
  final int id;
  final String title;
  final String thumbnail;
  final int total_members;

  CommunityModel({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.total_members,
  });

  factory CommunityModel.fromJSON(Map<String, dynamic> json) {
    return CommunityModel(
      id: json['id'],
      title: json['title'],
      thumbnail: json['thumbnail'],
      total_members: json['total_members'],
    );
  }
}
