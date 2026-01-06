import 'package:demo_app/models/community_model.dart';

class CommunityState {
  final List<CommunityModel>? communities;
  final bool isLoading;
  final String? error;
  final int page;

  CommunityState({
    this.communities,
    this.isLoading = false,
    this.error,
    this.page = 0,
  });

  CommunityState copyWith({
    List<CommunityModel>? communityList,
    bool? loadingState,
    String? err,
    int? currentPage,
  }) {
    return CommunityState(
      communities: communityList ?? communities,
      isLoading: loadingState ?? isLoading,
      error: err ?? error,
      page: currentPage ?? page,
    );
  }
}
