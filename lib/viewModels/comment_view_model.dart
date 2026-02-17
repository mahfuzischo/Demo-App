import 'package:demo_app/repositories/comment_repo.dart';

import 'package:demo_app/states/comment_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommentViewModel extends Notifier<CommentState> {
  @override
  build() {
    return CommentState();
  }

  CommentRepo repository = CommentRepo();

  Future<void> getComments(int feedId) async {
    debugPrint("inside getComments");
    state = state.copyWith(loadingState: true);
    debugPrint("in loading state");

    try {
      final comments = await repository.getComments(feedId);
      debugPrint("comments fetched $comments");
      state = state.copyWith(commentList: comments, loadingState: false);
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
