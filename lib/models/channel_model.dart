class ChannelModel {
  final int id;
  final String name;
  final int communityId;

  ChannelModel({
    required this.id,
    required this.name,
    required this.communityId,
  });

  factory ChannelModel.fromJSON(Map<String, dynamic> json) {
    return ChannelModel(
      id: json['id'],
      name: json['name'],
      communityId: json['community_id'],
    );
  }
}
