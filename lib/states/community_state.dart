import 'package:demo_app/models/community_model.dart';

class CommunityState {
  final List<CommunityModel>? communities;
  final bool isLoading;
  final String? error;

  CommunityState({this.communities, this.isLoading = false, this.error});

  CommunityState copyWith({
    List<CommunityModel>? communityList,
    bool? loadingState,
    String? err,
  }) {
    return CommunityState(
      communities: communityList ?? communities,
      isLoading: loadingState ?? isLoading,
      error: err ?? error,
    );
  }
}
