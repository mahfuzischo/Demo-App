class FeedModel {
  final int feedId;
  final int userId;
  final int schoolId;
  final int channelId;
  final String feedTxt;
  final String name;
  final String pic;
  final DateTime createdAt;
  final List<FeedFileModel> files;
  final int likeCount;

  FeedModel({
    required this.feedId,
    required this.userId,
    required this.schoolId,
    required this.channelId,
    required this.name,
    required this.createdAt,
    required this.feedTxt,
    required this.pic,
    required this.files,
    required this.likeCount,
  });

  factory FeedModel.fromJSON(Map<String, dynamic> json) {
    return FeedModel(
      feedId: json["id"],
      userId: json["user_id"],
      schoolId: json["school_id"],
      channelId: json["space_id"],
      name: json["name"],
      createdAt: DateTime.parse(json["created_at"]),
      feedTxt: json["feed_txt"],
      likeCount: json["like_count"],
      pic: json["pic"],
      files: (json["files"] as List<dynamic>)
          .map((f) => FeedFileModel.fromJSON(f))
          .toList(),
    );
  }
}

class FeedFileModel {
  final String fileLocation;
  FeedFileModel({required this.fileLocation});
  factory FeedFileModel.fromJSON(Map<String, dynamic> json) {
    return FeedFileModel(fileLocation: json['fileLoc']);
  }
}
