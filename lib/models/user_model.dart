class UserModel {
  final int id;
  final int schoolId;
  final int canWriteDoc;
  final String fullName;
  final String isVerified;
  final int isApproved;
  final String userType;
  final int createdBy;
  final DateTime createdAt;
  final int isPrivateChat;
  final DateTime updatedAt;
  final String profilePic;
  final String isOnline;
  final String firstName;
  final String lastName;

  UserModel({
    required this.id,
    required this.schoolId,
    required this.canWriteDoc,
    required this.fullName,
    required this.isVerified,
    required this.isApproved,
    required this.userType,
    required this.createdBy,
    required this.createdAt,
    required this.isPrivateChat,
    required this.updatedAt,
    required this.profilePic,
    required this.isOnline,
    required this.firstName,
    required this.lastName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      schoolId: json['school_id'],
      canWriteDoc: json['can_write_doc'],
      fullName: json['full_name'],
      isVerified: json['is_verified'],
      isApproved: json['is_approved'],
      userType: json['user_type'],
      createdBy: json['created_by'],
      createdAt: DateTime.parse(json['created_at']),
      isPrivateChat: json['is_private_chat'],
      updatedAt: DateTime.parse(json['updated_at']),
      profilePic: json['profile_pic'],
      isOnline: json['is_online'],
      firstName: json['first_name'],
      lastName: json['last_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'school_id': schoolId,
      'can_write_doc': canWriteDoc,
      'full_name': fullName,
      'is_verified': isVerified,
      'is_approved': isApproved,
      'user_type': userType,
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
      'is_private_chat': isPrivateChat,
      'updated_at': updatedAt.toIso8601String(),
      'profile_pic': profilePic,
      'is_online': isOnline,
      'first_name': firstName,
      'last_name': lastName,
    };
  }
}
