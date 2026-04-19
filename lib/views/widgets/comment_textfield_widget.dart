import 'package:demo_app/views/widgets/gallery_widget.dart';
import 'package:flutter/material.dart';

class CommentTextfieldWidget extends StatefulWidget {
  const CommentTextfieldWidget({super.key});

  @override
  State<CommentTextfieldWidget> createState() => _CommentTextfieldWidgetState();
}

class _CommentTextfieldWidgetState extends State<CommentTextfieldWidget> {
  TextEditingController commentController = TextEditingController();
  final FocusNode commentFocusNode = FocusNode();
  bool isFocused = false;
  bool hasText = false;
  @override
  void initState() {
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

  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return // Comment text field // Create comment
    Container(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 30),
      width: double.infinity,
      decoration: BoxDecoration(border: Border(top: BorderSide(width: .5))),
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
                backgroundImage: AssetImage("assets/blank_profile.png"),
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
                            return GalleryWidget(galleryFileType: "image");
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
                            return GalleryWidget(galleryFileType: "video");
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
                              color: Color.fromRGBO(7, 81, 91, 1.0),
                            ),
                          )
                        : SizedBox(),
                  ],
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
