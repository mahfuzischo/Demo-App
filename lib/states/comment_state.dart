import 'package:demo_app/models/comment_model.dart';

class CommentState {
  final List<CommentModel>? comments;
  final bool isLoading;
  final String? error;

  CommentState({this.comments, this.isLoading = false, this.error});

  CommentState copyWith({
    List<CommentModel>? comments,
    bool? isLoading,
    String? error,
  }) {
    return CommentState(
      comments: comments ?? this.comments,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
