import 'dart:convert';

import 'package:demo_app/data/secure_storage.dart';
import 'package:demo_app/models/post_model.dart';
import 'package:demo_app/states/post_state.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class PostViewModel extends Notifier<PostState> {
  @override
  build() {
    return PostState();
  }

  SecureStorage storage = SecureStorage();

  Future<void> createPost(PostModel post) async {
    final endpoint = '/teacher/community/createFeed';
    final url = Uri.parse('${dotenv.env['base_url']}$endpoint');
    final token = await storage.readToken();
    state = state.copyWith(isLoading: true);
    print("XXXXXXXXXXX");
    print(post.toJson());

    final response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'Authorization': 'bearer $token',
      },
      body: jsonEncode(post.toJson()),
    );

    if (response.statusCode == 200) {
      state = state.copyWith(isLoading: false, error: null);
      // final responseData = response.body;
      // final createdPost = PostModel.fromJson();
      // state = state.copyWith(post: createdPost, isLoading: false, error: null);
      debugPrint(
        'Post created successfully. Status code: ${response.statusCode}',
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to create post. Status code: ${response.statusCode}',
      );
      debugPrint('Failed to create post. Status code: ${response.statusCode}');
      debugPrint('Response: ${response.body}');
    }
  }
}

final PostViewModelProvider = NotifierProvider<PostViewModel, PostState>(() {
  return PostViewModel();
});
