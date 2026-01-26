import 'package:demo_app/models/community_model.dart';

class CommunityState {
  final List<CommunityModel> communities;
  final bool isLoading;
  final String? error;
  final int page;
  final bool maxFetched;
  final bool loadingMoreData;

  CommunityState({
    required this.communities,
    this.isLoading = false,
    this.error,
    this.page = 0,
    this.maxFetched = false,
    this.loadingMoreData = false,
  });

  CommunityState copyWith({
    List<CommunityModel>? communityList,
    bool? loadingState,
    String? err,
    int? currentPage,
    bool? hasMaxed,
    bool? newCommunities,
  }) {
    return CommunityState(
      communities: communityList ?? communities,
      isLoading: loadingState ?? isLoading,
      error: err ?? error,
      page: currentPage ?? page,
      maxFetched: hasMaxed ?? maxFetched,
      loadingMoreData: newCommunities ?? loadingMoreData,
    );
  }
}
