class ReplyModel {
  final int id;
  final int schoolId;
  final int feedId;
  final int userId;
  final int replyCount;
  final int likeCount;
  final String replyTxt;
  final int? parentId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final dynamic file;
  final dynamic privateUserId;
  final int isAuthorAndAnonymous;
  final List<dynamic> replies;
  final List<dynamic> reactionTypes;
  final UserModel user;
  final dynamic privateUser;
  final List<dynamic> totalLikes;
  final dynamic commentLike;

  ReplyModel({
    required this.id,
    required this.schoolId,
    required this.feedId,
    required this.userId,
    required this.replyCount,
    required this.likeCount,
    required this.replyTxt,
    this.parentId,
    required this.createdAt,
    required this.updatedAt,
    this.file,
    this.privateUserId,
    required this.isAuthorAndAnonymous,
    required this.replies,
    required this.reactionTypes,
    required this.user,
    this.privateUser,
    required this.totalLikes,
    this.commentLike,
  });

  factory ReplyModel.fromJSON(Map<String, dynamic> json) {
    return ReplyModel(
      id: json['id'],
      schoolId: json['school_id'],
      feedId: json['feed_id'],
      userId: json['user_id'],
      replyCount: json['reply_count'],
      likeCount: json['like_count'],
      replyTxt: json['reply_txt'],
      parentId: json['parent_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      file: json['file'],
      privateUserId: json['private_user_id'],
      isAuthorAndAnonymous: json['is_author_and_anonymous'],
      replies: json['replies'] ?? [],
      reactionTypes: json['reaction_types'] ?? [],
      user: UserModel.fromJSON(json['user']),
      privateUser: json['private_user'],
      totalLikes: json['totallikes'] ?? [],
      commentLike: json['commentlike'],
    );
  }
}

class UserModel {
  final int id;
  final String fullName;
  final String profilePic;
  final String userType;
  final Map<String, dynamic> meta;

  UserModel({
    required this.id,
    required this.fullName,
    required this.profilePic,
    required this.userType,
    required this.meta,
  });

  factory UserModel.fromJSON(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      fullName: json['full_name'],
      profilePic: json['profile_pic'],
      userType: json['user_type'],
      meta: json['meta'] ?? {},
    );
  }
}
