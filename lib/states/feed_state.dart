import 'package:demo_app/models/feed_model.dart';

class FeedState {
  final List<FeedModel>? feeds;
  final bool isLoading;
  final String? error;

  FeedState({this.feeds, this.isLoading = false, this.error});

  FeedState copyWith({
    List<FeedModel>? feedList,
    bool? loadingState,
    String? err,
  }) {
    return FeedState(
      feeds: feedList ?? feeds,
      isLoading: loadingState ?? isLoading,
      error: err ?? error,
    );
  }
}
