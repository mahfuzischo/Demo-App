import 'package:demo_app/models/reply_model.dart';

class ReplyState {
  final List<ReplyModel>? replies;
  final bool isLoading;
  final String? error;

  ReplyState({this.replies, this.isLoading = false, this.error});

  ReplyState copyWith({
    List<ReplyModel>? replies,
    bool? isLoading,
    String? error,
  }) {
    return ReplyState(
      replies: replies ?? this.replies,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
