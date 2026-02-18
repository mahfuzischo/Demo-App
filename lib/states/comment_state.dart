import 'package:demo_app/models/comment_model.dart';
import 'package:flutter/material.dart';

class CommentState {
  final List<CommentModel>? comments;
  final bool isLoading;
  final String? error;

  CommentState({this.comments, this.error, this.isLoading = false});

  CommentState copyWith({
    List<CommentModel>? commentList,
    bool? loadingState,
    String? err,
  }) {
    debugPrint("Loading state updating from copywith");
    return CommentState(
      comments: commentList ?? comments,
      isLoading: loadingState ?? isLoading,
      error: err ?? error,
    );
  }
}
