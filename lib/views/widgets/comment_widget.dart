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
    Future.microtask(() {
      ref.read(commentViewModelProvider.notifier).getComments(widget.feedId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final commentState = ref.watch(commentViewModelProvider);
    return SizedBox(
      height: MediaQuery.of(context).size.height * .85,
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(30),
        ),
        child: commentState.isLoading
            ? Center(child: CircularProgressIndicator())
            : commentState.error != null
            ? Center(child: Text("Error loading comments"))
            : commentState.comments != null && commentState.comments!.isNotEmpty
            ? ListView.builder(
                itemCount: commentState.comments!.length,
                itemBuilder: (BuildContext context, int index) {
                  final comments = commentState.comments;
                  final comment = comments![index];
                  print("name: ${comment.user.fullName}");
                  print("image: ${comment.user.id}");
                  return Row(
                    mainAxisAlignment: .start,
                    children: [
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
              )
            : Center(child: Text("No comments yet!")),
      ),
    );
  }
}
