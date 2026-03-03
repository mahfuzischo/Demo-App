import 'dart:convert';

import 'package:demo_app/data/secure_storage.dart';
import 'package:demo_app/models/reply_model.dart';
import 'package:demo_app/states/reply_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class ReplyViewModel extends Notifier<ReplyState> {
  @override
  build() {
    return ReplyState();
  }

  Future<void> getReplies(int commentId) async {
    debugPrint("inside getReplies");
    state = state.copyWith(isLoading: true);
    debugPrint("in loading state");

    final SecureStorage _storage = SecureStorage();

    debugPrint("fetcing replies");
    final String endpoint = '/student/comment/getReply/$commentId';
    final url = Uri.parse('${dotenv.env['base_url']}$endpoint');
    final token = await _storage.readToken();

    final response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'Authorization': 'bearer $token',
      },
    );
    debugPrint("replies fetched with statuscode ${response.statusCode}");

    if (response.statusCode == 200) {
      final tempData = jsonDecode(response.body) as List;
      final replies = tempData.map((m) => ReplyModel.fromJSON(m)).toList();
      debugPrint("replies fetched $replies");
      state = state.copyWith(replies: replies, isLoading: false);
    } else {
      debugPrint(
        "Failed to load replies with status code: ${response.statusCode}",
      );
      state = state.copyWith(isLoading: false, error: 'Error loading replies');
    }
  }
}

final replyViewModelProvider = NotifierProvider<ReplyViewModel, ReplyState>(() {
  return ReplyViewModel();
});
