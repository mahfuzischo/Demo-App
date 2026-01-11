import 'package:demo_app/states/feed_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedViewModel extends Notifier<FeedState> {
  @override
  build() {
    return FeedState();
  }
}
