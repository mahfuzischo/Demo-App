import 'package:demo_app/viewModels/comment_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommentWidget extends ConsumerStatefulWidget {
  final int feedId;

  const CommentWidget({super.key, required this.feedId});

  @override
  ConsumerState<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends ConsumerState<CommentWidget> {
  @override
  void initState() {
    super.initState();
    debugPrint("feed id: ${widget.feedId}");
    ref.read(commentViewModelProvider.notifier).getComments(widget.feedId);
  }

  @override
  Widget build(BuildContext context) {
    final comments = ref.watch(commentViewModelProvider).comments;
    return SizedBox(
      height: MediaQuery.of(context).size.height * .85,
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(30),
        ),
        child: comments == null || ref.watch(commentViewModelProvider).isLoading
            ? Center(child: CircularProgressIndicator())
            : comments.isEmpty
            ? Center(child: Text("No comments available"))
            : ListView.builder(
                itemCount: comments.length,
                itemBuilder: (BuildContext context, int index) {
                  final comment = comments[index];
                  return Row(
                    mainAxisAlignment: .start,
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(comment.user.profilePic),
                      ),
                      SizedBox(width: 10),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Text(
                              comment.user.fullName,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }
}
