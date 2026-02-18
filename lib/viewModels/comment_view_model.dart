import 'dart:convert';
import 'package:demo_app/data/secure_storage.dart';
import 'package:demo_app/models/comment_model.dart';
import 'package:demo_app/states/comment_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class CommentViewModel extends Notifier<CommentState> {
  @override
  build() {
    return CommentState();
  }

  // CommentRepo repository = CommentRepo();

  Future<void> getComments(int feedId) async {
    debugPrint("inside getComments");
    state = state.copyWith(loadingState: true);
    debugPrint("in loading state");

    final SecureStorage _storage = SecureStorage();

    debugPrint("fetcing comments");
    final String endpoint = '/student/comment/getComment/$feedId';
    final url = Uri.parse('${dotenv.env['base_url']}$endpoint');
    final token = await _storage.readToken();

    final response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'Authorization': 'bearer $token',
      },
    );
    debugPrint("comments fetched with statuscode ${response.statusCode}");

    if (response.statusCode == 200) {
      final tempData = jsonDecode(response.body) as List;
      final comments = tempData.map((m) => CommentModel.fromJSON(m)).toList();
      debugPrint("comments fetched $comments");
      state = state.copyWith(commentList: comments, loadingState: false);
    } else {
      debugPrint(
        "Failed to load comments with status code: ${response.statusCode}",
      );
      state = state.copyWith(
        loadingState: false,
        err: 'Error loading comments',
      );
    }
  }
}

final commentViewModelProvider =
    NotifierProvider<CommentViewModel, CommentState>(() {
      return CommentViewModel();
    });
