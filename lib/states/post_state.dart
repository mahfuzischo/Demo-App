import 'package:demo_app/models/post_model.dart';

class PostState {
  final PostModel? post;
  final bool isLoading;
  final String? error;

  PostState({this.post, this.isLoading = false, this.error});

  PostState copyWith({PostModel? post, bool? isLoading, String? error}) {
    return PostState(
      post: post ?? this.post,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
