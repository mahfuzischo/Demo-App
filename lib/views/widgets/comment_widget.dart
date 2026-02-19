import 'package:demo_app/viewModels/comment_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommentWidget extends ConsumerStatefulWidget {
  final int feedId;
  final int likeCount;

  const CommentWidget({
    super.key,
    required this.feedId,
    required this.likeCount,
  });

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
        padding: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: Color.fromRGBO(243, 243, 243, 1),
          // borderRadius: BorderRadius.circular(30),
        ),
        child: commentState.isLoading
            ? Center(child: CircularProgressIndicator())
            : commentState.error != null
            ? Center(child: Text("Error loading comments"))
            : commentState.comments != null && commentState.comments!.isNotEmpty
            ? Column(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: BoxBorder.fromLTRB(bottom: BorderSide(width: .5)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.thumb_up_off_alt),
                        SizedBox(width: 5),
                        Text(
                          "0 reactions",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade700,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: commentState.comments!.length,
                      itemBuilder: (BuildContext context, int index) {
                        final comments = commentState.comments;
                        final comment = comments![index];

                        return Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 10,
                          ),
                          child: Row(
                            mainAxisAlignment: .start,
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                  comment.user.profilePic,
                                ),
                              ),
                              SizedBox(width: 10),
                              Container(
                                // width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey.shade200,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: .start,
                                    children: [
                                      Text(
                                        comment.user.fullName,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(comment.commentTxt),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              )
            : Center(child: Text("No comments yet!")),
      ),
    );
  }
}
