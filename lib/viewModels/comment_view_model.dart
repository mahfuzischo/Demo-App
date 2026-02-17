import 'package:demo_app/repositories/comment_repo.dart';

import 'package:demo_app/states/comment_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommentViewModel extends Notifier<CommentState> {
  @override
  CommentState build() {
    return CommentState();
  }

  final CommentRepo _repository = CommentRepo();

  Future<void> getComments(int feedId) async {
    state = state.copyWith(loadingState: true);

    try {
      final comments = await _repository.getComments(feedId);
      state = state.copyWith(commentList: comments, loadingState: false);
      debugPrint("comments fetched $comments");
    } catch (e) {
      debugPrint(e.toString());
      state = state.copyWith(err: e.toString(), loadingState: false);
    }
  }
}

final commentViewModelProvider =
    NotifierProvider<CommentViewModel, CommentState>(() {
      return CommentViewModel();
    });
