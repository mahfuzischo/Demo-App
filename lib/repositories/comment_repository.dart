import 'package:demo_app/models/comment_model.dart';

abstract class CommentRepository {
  Future<List<CommentModel>> getComments(int feedId);
}
