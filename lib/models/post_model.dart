class PostModel {
  final int communityId;
  final int spaceId;
  final String feedTxt;
  final String uploadType;
  final int isBackground;
  final List<PostFile> files;

  PostModel({
    required this.communityId,
    required this.spaceId,
    required this.feedTxt,
    required this.uploadType,
    required this.isBackground,
    required this.files,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      communityId: json['community_id'],
      spaceId: json['space_id'],
      feedTxt: json['feed_txt'],
      uploadType: json['uploadType'],
      isBackground: json['is_background'],
      files: (json['files'] as List).map((e) => PostFile.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'community_id': communityId,
      'space_id': spaceId,
      'feed_txt': feedTxt,
      'uploadType': uploadType,
      'is_background': isBackground,
      'files': files.map((e) => e.toJson()).toList(),
    };
  }
}

class PostFile {
  final String extname;
  final String fileLoc;
  final String originalName;
  final int size;
  final String type;

  PostFile({
    required this.extname,
    required this.fileLoc,
    required this.originalName,
    required this.size,
    required this.type,
  });

  factory PostFile.fromJson(Map<String, dynamic> json) {
    return PostFile(
      extname: json['extname'],
      fileLoc: json['fileLoc'],
      originalName: json['originalName'],
      size: json['size'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'extname': extname,
      'fileLoc': fileLoc,
      'originalName': originalName,
      'size': size,
      'type': type,
    };
  }
}
