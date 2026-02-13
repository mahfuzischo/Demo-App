import 'package:demo_app/models/comment_model.dart';

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
    return CommentState(
      comments: commentList ?? comments,
      isLoading: loadingState ?? isLoading,
      error: err ?? error,
    );
  }
}
