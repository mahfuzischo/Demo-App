import 'package:demo_app/viewModels/reply_view_model.dart';
import 'package:demo_app/views/widgets/gallery_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReplyWidget extends ConsumerStatefulWidget {
  final int commentId;
  final int likeCount;

  const ReplyWidget({
    super.key,
    required this.commentId,
    required this.likeCount,
  });

  @override
  ConsumerState<ReplyWidget> createState() => _ReplyWidgetState();
}

class _ReplyWidgetState extends ConsumerState<ReplyWidget> {
  TextEditingController commentController = TextEditingController();
  final FocusNode commentFocusNode = FocusNode();
  bool isFocused = false;
  bool hasText = false;

  @override
  void initState() {
    Future.microtask(() {
      ref.read(replyViewModelProvider.notifier).getReplies(widget.commentId);
    });

    commentFocusNode.addListener(() {
      setState(() {
        isFocused = commentFocusNode.hasFocus;
        debugPrint("Input focus::::::::::::::::::::::: ${isFocused}");
      });
    });

    commentController.addListener(() {
      setState(() {
        hasText = commentController.value.text.isNotEmpty;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final replyState = ref.watch(replyViewModelProvider);
    return SizedBox(
      height: MediaQuery.of(context).size.height * .85,
      width: double.infinity,
      child: Container(
        padding: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: Color.fromRGBO(243, 243, 243, 1),
          // borderRadius: BorderRadius.circular(30),
        ),
        child: replyState.isLoading
            ? Center(child: CircularProgressIndicator())
            : replyState.error != null
            ? Center(child: Text("Error loading replies"))
            : replyState.replies != null && replyState.replies!.isNotEmpty
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
                      itemCount: replyState.replies!.length,
                      itemBuilder: (BuildContext context, int index) {
                        final replies = replyState.replies;
                        final reply = replies![index];

                        return Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 10,
                          ),
                          child: Row(
                            crossAxisAlignment: .start,
                            mainAxisAlignment: .start,
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                  reply.user.profilePic,
                                ),
                              ),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: .start,
                                children: [
                                  Container(
                                    // width: double.infinity,
                                    width:
                                        MediaQuery.of(context).size.width * .8,
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
                                            reply.user.fullName,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(reply.replyTxt),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                                    child: Row(
                                      spacing: 8,
                                      children: [
                                        Text(
                                          "7mo",
                                          style: TextStyle(
                                            color: Colors.grey.shade700,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Text(
                                          "Like",
                                          style: TextStyle(
                                            color: Colors.grey.shade700,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  // Comment text field // Create comment
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 30),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border(top: BorderSide(width: .5)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Avatar
                        Row(
                          crossAxisAlignment: .start,
                          spacing: 10,
                          children: [
                            CircleAvatar(
                              backgroundImage: AssetImage(
                                "assets/blank_profile.png",
                              ),
                            ),
                            SizedBox(height: 10),

                            Expanded(
                              child: TextField(
                                controller: commentController,
                                focusNode: commentFocusNode,
                                maxLines: 2,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Write a comment...",
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Buttons row
                        isFocused
                            ? Row(
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.photo_camera,
                                      color: Color.fromRGBO(7, 81, 91, 1.0),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      showBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return GalleryWidget(
                                            galleryFileType: "image",
                                          );
                                        },
                                      );

                                      debugPrint("Fetching gallery images");
                                    },
                                    icon: Icon(
                                      Icons.image,
                                      color: Color.fromRGBO(7, 81, 91, 1.0),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      showBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return GalleryWidget(
                                            galleryFileType: "video",
                                          );
                                        },
                                      );
                                      debugPrint("Fetching gallery videos");
                                    },
                                    icon: Icon(
                                      Icons.video_collection,
                                      color: Color.fromRGBO(7, 81, 91, 1.0),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.gif_box_outlined,
                                      color: Color.fromRGBO(7, 81, 91, 1.0),
                                    ),
                                  ),
                                  Spacer(),
                                  hasText
                                      ? IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.send,
                                            color: Color.fromRGBO(
                                              7,
                                              81,
                                              91,
                                              1.0,
                                            ),
                                          ),
                                        )
                                      : SizedBox(),
                                ],
                              )
                            : SizedBox(),
                      ],
                    ),
                  ),
                ],
              )
            : Center(child: Text("No comments yet!")),
      ),
    );
  }
}
