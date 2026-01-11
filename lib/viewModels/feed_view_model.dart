import 'package:demo_app/data/secure_storage.dart';
import 'package:demo_app/states/feed_state.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedViewModel extends Notifier<FeedState> {
  @override
  build() {
    return FeedState();
  }

  SecureStorage storage = SecureStorage();
  Future<void> fetchFeed() async {
    final endpoint =
        '/public/feeds/${communityId}?space_id=${communitySpaceId}&status=saved&more=';
    final url = Uri.parse('${dotenv.env['base_url']}$endpoint');
    final token = await storage.readToken();
    state = state.copyWith(loadingState: true);
  }
}
