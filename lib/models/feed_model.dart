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
  final String fileLoc;
  final String originalName;
  final String hlsLink;
  final String playLink;
  final String extname;
  final String type;
  final int size;
  final String thumbnailLink;
  final String videoID;
  final bool isNew;

  FeedFileModel({
    required this.fileLoc,
    required this.originalName,
    required this.hlsLink,
    required this.playLink,
    required this.extname,
    required this.type,
    required this.size,
    required this.thumbnailLink,
    required this.videoID,
    required this.isNew,
  });

  factory FeedFileModel.fromJSON(Map<String, dynamic> json) {
    return FeedFileModel(
      fileLoc: json['fileLoc'] ?? '',
      originalName: json['originalName'] ?? '',
      hlsLink: json['hls_link'] ?? '',
      playLink: json['play_link'] ?? '',
      extname: json['extname'] ?? '',
      type: json['type'] ?? '',
      size: json['size'] ?? 0,
      thumbnailLink: json['thumbnail_link'] ?? '',
      videoID: json['videoID'] ?? '',
      isNew: json['isNew'] ?? false,
    );
  }
}

// class FeedFileModel {
//   final String fileLocation;
//   FeedFileModel({required this.fileLocation});
//   factory FeedFileModel.fromJSON(Map<String, dynamic> json) {
//     return FeedFileModel(fileLocation: json['fileLoc']);
//   }
// }
