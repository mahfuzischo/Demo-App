import 'dart:convert';

import 'package:demo_app/data/secure_storage.dart';
import 'package:demo_app/models/feed_model.dart';
import 'package:demo_app/states/feed_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class FeedViewModel extends Notifier<FeedState> {
  @override
  build() {
    return FeedState();
  }

  SecureStorage storage = SecureStorage();
  Future<List<FeedModel>> fetchFeed(int communityId, int channelId) async {
    print(
      "fetching feed data: communityId: ${communityId}, channelId: ${channelId}",
    );

    final endpoint =
        '/public/feeds/$communityId?space_id=$channelId&status=feed&more=';
    final url = Uri.parse('${dotenv.env['base_url']}$endpoint');
    final token = await storage.readToken();
    state = state.copyWith(loadingState: true, feedList: null);
    final response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'Authorization': 'bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final tData = jsonDecode(response.body) as List;
      final data = tData.map((m) => FeedModel.fromJSON(m)).toList();

      state = state.copyWith(feedList: data, loadingState: false);
      return data;
    } else {
      state = state.copyWith(
        err: 'Failed to fetch feed data. Status code: ${response.statusCode}',
        loadingState: false,
      );
      return [];
    }
  }

  Future<void> deleteFeed(int feedId, int communityId) async {
    final endpoint = '/teacher/community/deleteFeed';
    final url = Uri.parse('${dotenv.env['base_url']}$endpoint');
    final token = await storage.readToken();
    state = state.copyWith(loadingState: true);
    final response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'Authorization': 'bearer $token',
      },
      body: jsonEncode({"id": feedId, "community_id": communityId}),
    );

    if (response.statusCode == 200) {
      state = state.copyWith(loadingState: false, err: null);

      debugPrint(
        'Post deleted successfully. Status code: ${response.statusCode}',
      );
    } else {
      print("feedID: ${feedId}");
      print("communityID: ${communityId}");
      print("body: ${response.body}");
      state = state.copyWith(
        loadingState: false,
        err: 'Failed to delete post. Status code: ${response.statusCode}',
      );
      debugPrint('Failed to delete post. Status code: ${response.statusCode}');
    }
  }
}

final feedViewModelProvider = NotifierProvider<FeedViewModel, FeedState>(() {
  return FeedViewModel();
});
